import 'package:flutter/material.dart';
import 'package:volleylytics/models/player_lineup.dart';
import 'package:volleylytics/models/rate_action.dart';
import 'package:volleylytics/models/volleyball_match.dart';
import 'package:volleylytics/widgets/lineup_display.dart';

import '../../models/player.dart';
import '../../widgets/player_swap_selector.dart';
import '../../widgets/rate_action_dialog.dart';
import '../../widgets/volleyball_score_editor.dart';

class GameEditor extends StatefulWidget {
  final VolleyballMatch match;
  const GameEditor({super.key, required this.match});

  @override
  State<GameEditor> createState() => _GameEditorState();
}

class _GameEditorState extends State<GameEditor> {
  final GlobalKey _lineupDisplayKey = GlobalKey();
  double _lineupDisplayHeight = 0;

  PlayerLineup get playerLineup {
    return widget.match.currentPlayerLineup!;
  }

  Players get benchPlayers {
    return widget.match.players
        .where((player) => !widget.match.currentPlayerLineup!.positions.contains(player))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _setLineupDisplayHeight());
  }

  void _setLineupDisplayHeight() {
    final RenderBox renderBox =
        _lineupDisplayKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _lineupDisplayHeight = renderBox.size.height;
    });
  }

  Player liberoSwapToBench() {
    int benchPlayerIndex = benchPlayers.indexWhere((player) =>
        int.tryParse(player.number) == int.tryParse(widget.match.numberPlayerLiberoSwaped!));
    Player libero = playerLineup.positions
        .firstWhere((player) => player.position == PlayerPosition.LIBERO);
    Player benchPlayer = benchPlayers.removeAt(benchPlayerIndex);
    setState(() {
      playerLineup.positions[playerLineup.positions.indexOf(libero)] =
          benchPlayer;
      benchPlayers.add(libero);
      widget.match.numberPlayerLiberoSwaped = null;
    });
    return libero;
  }

  void swapPlayers() async {
    Player? libero;
    int? liberoIndex = playerLineup.positions
        .indexWhere((player) => player.position == PlayerPosition.LIBERO);
    if (widget.match.numberPlayerLiberoSwaped != null) {
      libero = liberoSwapToBench();
    }

    Players relevantBenchPlayers = benchPlayers
        .where((player) => player.position != PlayerPosition.LIBERO)
        .toList();

    List<Player>? swap = await showDialog(
      context: context,
      builder: (context) {
        return PlayerSwapSelector(
          optionsA: playerLineup.positions,
          optionsB: relevantBenchPlayers,
          title: 'Swap players',
        );
      },
    );
    if (swap == null) return;

    Player activePlayer = swap[0];
    Player benchPlayer = swap[1];

    setState(() {
      playerLineup.positions[playerLineup.positions.indexOf(activePlayer)] =
          benchPlayer;
      benchPlayers.add(activePlayer);
      benchPlayers.remove(benchPlayer);
    });

    // swap libero back in if necessary
    if (libero != null) {
      setState(() {
        benchPlayers.add(playerLineup.positions[liberoIndex]);
        widget.match.numberPlayerLiberoSwaped = playerLineup.positions[liberoIndex].number;
        playerLineup.positions[liberoIndex] = libero!;
        benchPlayers.remove(libero);
      });
    }
  }

  void ensureLiberoNotAtNet() {
    if (widget.match.numberPlayerLiberoSwaped != null) {
      int liberoIndex = playerLineup.positions
          .indexWhere((player) => player.position == PlayerPosition.LIBERO);
      if (0 < liberoIndex && liberoIndex < 4) liberoSwapToBench();
    }
  }

  void onPlayerTapped(Player player) async {
    debugPrint('Player tapped: ${player.displayName}');
    RateAction? rateAction = await showDialog(
      context: context,
      builder: (context) {
        return RateActionDialog(
          player: player,
          score: widget.match.currentScore!,
          lineup: playerLineup,
        );
      },
    );
    rateAction;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          final NavigatorState navigator = Navigator.of(context);
          final bool? shouldPop = await _showBackDialog(context, () {
            final match = VolleyballMatch(widget.match.players,
              teamWe: widget.match.teamWe,
              teamThem: widget.match.teamThem,
              startTime: widget.match.startTime,
              sets: widget.match.sets,
              samsMatchInformation: widget.match.samsMatchInformation,
              currentPlayerLineup: playerLineup,
            );

            return match;
          });
          if (shouldPop ?? false) {
            navigator.pop();
          }
        },
        child: Scaffold(
          body: ListView(
            children: [
              ListTile(
                leading: Image.network(
                  widget.match.teamWe.logoURL ?? '',
                ),
                trailing: Image.network(
                  widget.match.teamThem.logoURL ?? '',
                ),
                title: Text(widget.match.teamWe.name,
                    overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  'vs ${widget.match.teamThem.name}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              VolleyballScoreEditor(
                score: widget.match.currentScore!,
              ),
              const Divider(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    LineupDisplay(
                      key: _lineupDisplayKey,
                      lineup: playerLineup,
                      onTap: (i) {
                        onPlayerTapped(playerLineup.positions[i]);
                      },
                    ),
                    SizedBox(
                      height: _lineupDisplayHeight,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            direction: Axis.vertical,
                            runSpacing: 8.0,
                            spacing: 8.0,
                            alignment: WrapAlignment.start,
                            children: benchPlayers.map((player) {
                              return PlayerDisplayContainer(
                                player: player,
                                onTap: () {
                                  onPlayerTapped(player);
                                },
                                smallFont: true,
                              );
                            }).toList(),
                          )),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.undo),
                    tooltip: 'undo Rotate',
                    onPressed: () {
                      setState(() {
                        playerLineup.rotateBack();
                        ensureLiberoNotAtNet();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    tooltip: 'Player swap',
                    onPressed: swapPlayers,
                  ),
                  Badge(
                    isLabelVisible: widget.match.numberPlayerLiberoSwaped != null,
                    label: Text(widget.match.numberPlayerLiberoSwaped ?? ''),
                    child: IconButton(
                      icon: playerLineup.liberoIn
                          ? const Icon(Icons.swap_vert_circle_outlined)
                          : const Icon(Icons.swap_vert_circle),
                      tooltip: 'Libero swap',
                      onPressed: () async {
                        if (widget.match.numberPlayerLiberoSwaped != null) {
                          // swap libero out
                          liberoSwapToBench();
                        } else {
                          //swap libero from bench in
                          Players availableLiberos = benchPlayers
                              .where((player) =>
                                  player.position == PlayerPosition.LIBERO)
                              .toList();
                          Players availableActivePlayers = [
                            playerLineup.positions[0],
                            playerLineup.positions[4],
                            playerLineup.positions[5]
                          ];

                          List<Player>? liberoSwap = await showDialog(
                            context: context,
                            builder: (context) {
                              return PlayerSwapSelector(
                                optionsA: availableLiberos,
                                optionsB: availableActivePlayers,
                                title: 'Swap libero',
                              );
                            },
                          );
                          if (liberoSwap == null) return;
                          Player libero = liberoSwap[0];
                          Player activePlayer = liberoSwap[1];
                          setState(() {
                            benchPlayers.add(activePlayer);
                            benchPlayers.remove(libero);
                            playerLineup.positions[playerLineup.positions
                                .indexOf(activePlayer)] = libero;
                            widget.match.numberPlayerLiberoSwaped = activePlayer.number;
                          });
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.redo),
                    tooltip: 'Rotate',
                    onPressed: () {
                      setState(() {
                        playerLineup.rotate();
                        ensureLiberoNotAtNet();
                      });
                    },
                  ),
                ],
              ),
              const Divider()
            ],
          ),
        ),
      ),
    );
  }
}

typedef CreateMatchData = VolleyballMatch Function();

Future<bool?> _showBackDialog(BuildContext context, CreateMatchData createMatchData) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Do you want to leave the game?'),
        content: const Text('All changes will be saved.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Leave'),
          ),
        ],
      );
    },
  );
}