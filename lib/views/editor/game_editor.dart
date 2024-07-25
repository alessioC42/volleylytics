import 'dart:async';

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
  List<RateAction> lastRateActions = [];

  PlayerLineup get playerLineup {
    return widget.match.currentPlayerLineup!;
  }

  Player getPlayer(PlayerNumber number) {
    return widget.match.getPlayer(number);
  }

  List<PlayerNumber> get benchPlayers {
    List<PlayerNumber> result = [];
    for (Player player in widget.match.players) {
      if (!playerLineup.positions.contains(player.number)) {
        result.add(player.number);
      }
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _setLineupDisplayHeight());

    setState(() {
      lastRateActions = widget.match.getLastRateActions(10);
    });
    // ensuring that the minute display for the rateActions is updated
    Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          lastRateActions = widget.match.getLastRateActions(10);
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _setLineupDisplayHeight() {
    final RenderBox renderBox =
        _lineupDisplayKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _lineupDisplayHeight = renderBox.size.height;
    });
  }

  PlayerNumber liberoSwapToBench() {
    int benchPlayerIndex = benchPlayers.indexWhere((playerNumber) =>
        playerNumber == widget.match.numberPlayerLiberoSwaped);
    PlayerNumber libero = playerLineup.positions.firstWhere((player) =>
        widget.match.getPlayer(player).position == PlayerPosition.LIBERO);
    PlayerNumber benchPlayer = benchPlayers.removeAt(benchPlayerIndex);
    setState(() {
      playerLineup.positions[playerLineup.positions.indexOf(libero)] =
          benchPlayer;
      benchPlayers.add(libero);
      widget.match.numberPlayerLiberoSwaped = null;
    });
    return libero;
  }

  void swapPlayers() async {
    PlayerNumber? libero;
    int? liberoIndex = playerLineup.positions.indexWhere((playerNumber) =>
        getPlayer(playerNumber).position == PlayerPosition.LIBERO);
    if (widget.match.numberPlayerLiberoSwaped != null) {
      libero = liberoSwapToBench();
    }

    List<PlayerNumber> relevantBenchPlayers = benchPlayers
        .where((player) => getPlayer(player).position != PlayerPosition.LIBERO)
        .toList();

    List<PlayerNumber>? swap = await showDialog(
      context: context,
      builder: (context) {
        return PlayerSwapSelector(
          optionsA: playerLineup.positions,
          optionsB: relevantBenchPlayers,
          getPlayer: getPlayer,
          title: 'Swap players',
        );
      },
    );
    if (swap == null) return;

    PlayerNumber activePlayer = swap[0];
    PlayerNumber benchPlayer = swap[1];

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
        widget.match.numberPlayerLiberoSwaped =
            playerLineup.positions[liberoIndex];
        playerLineup.positions[liberoIndex] = libero!;
        benchPlayers.remove(libero);
      });
    }
  }

  void ensureLiberoNotAtNet() {
    if (widget.match.numberPlayerLiberoSwaped != null) {
      int liberoIndex = playerLineup.positions.indexWhere(
          (player) => getPlayer(player).position == PlayerPosition.LIBERO);
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
    if (rateAction == null) return;
    debugPrint(widget.match.sets.toString());
    setState(() {
      widget.match.latestSet.actions.add(rateAction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VolleyLytics'),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset('assets/images/icon144.png'),
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          final NavigatorState navigator = Navigator.of(context);
          final bool? shouldPop = await _showBackDialog(context, () {
            final match = VolleyballMatch(
              widget.match.players,
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
        child: ListView(
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
                      onPlayerTapped(getPlayer(playerLineup.positions[i]));
                    },
                    getPlayer: getPlayer,
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
                              player: getPlayer(player),
                              onTap: () {
                                onPlayerTapped(getPlayer(player));
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
                  label: Text(
                      widget.match.numberPlayerLiberoSwaped?.toString() ?? ''),
                  child: IconButton(
                    icon: playerLineup.liberoIn(widget.match.players)
                        ? const Icon(Icons.swap_vert_circle_outlined)
                        : const Icon(Icons.swap_vert_circle),
                    tooltip: 'Libero swap',
                    onPressed: () async {
                      if (widget.match.numberPlayerLiberoSwaped != null) {
                        // swap libero out
                        liberoSwapToBench();
                      } else {
                        //swap libero from bench in
                        List<PlayerNumber> availableLiberos = benchPlayers
                            .where((player) =>
                                getPlayer(player).position ==
                                PlayerPosition.LIBERO)
                            .toList();
                        List<PlayerNumber> availableActivePlayers = [
                          playerLineup.positions[0],
                          playerLineup.positions[4],
                          playerLineup.positions[5]
                        ];

                        List<PlayerNumber>? liberoSwap = await showDialog(
                          context: context,
                          builder: (context) {
                            return PlayerSwapSelector(
                              optionsA: availableLiberos,
                              optionsB: availableActivePlayers,
                              title: 'Swap libero',
                              getPlayer: getPlayer,
                            );
                          },
                        );
                        if (liberoSwap == null) return;
                        PlayerNumber libero = liberoSwap[0];
                        PlayerNumber activePlayer = liberoSwap[1];
                        setState(() {
                          benchPlayers.add(activePlayer);
                          benchPlayers.remove(libero);
                          playerLineup.positions[playerLineup.positions
                              .indexOf(activePlayer)] = libero;
                          widget.match.numberPlayerLiberoSwaped = activePlayer;
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
            const Divider(),
            Column(
              children: lastRateActions.map((action) {
                return ListTile(
                  title: Row(
                    children: [
                      Text(getPlayer(action.player).displayName),
                    ],
                  ),
                  subtitle: Text(action.action.toString().split('.').last),
                  leading: Icon(action.action.icon),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: getRatingColor(action.rating),
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8.0), topLeft: Radius.circular(8.0)),
                        ),
                        child: Text(
                          action.rating.toStringAsFixed(2),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                        ),
                        child: Text(getMinutesPassed(action.time), style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

typedef CreateMatchData = VolleyballMatch Function();

Future<bool?> _showBackDialog(
    BuildContext context, CreateMatchData createMatchData) {
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

String getMinutesPassed(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  final minutesPassed = difference.inMinutes;

  return '$minutesPassed min';
}