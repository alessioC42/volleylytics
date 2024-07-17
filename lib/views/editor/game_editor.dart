import 'package:flutter/material.dart';
import 'package:volleylytics/globals.dart';
import 'package:volleylytics/models/player_lineup.dart';
import 'package:volleylytics/models/volleyball_match.dart';
import 'package:volleylytics/widgets/lineup_display.dart';

import '../../models/player.dart';
import '../../widgets/player_swap_selector.dart';

class GameEditor extends StatefulWidget {
  final VolleyballMatch match;
  const GameEditor({super.key, required this.match});

  @override
  State<GameEditor> createState() => _GameEditorState();
}

class _GameEditorState extends State<GameEditor> {
  PlayerLineup? playerLineup;
  Players players = globals.playerProvider.players;
  final GlobalKey _lineupDisplayKey = GlobalKey();
  double _lineupDisplayHeight = 0;

  String? numberPlayerLiberoSwaped;

  void initPlayerLineup() {
    playerLineup = widget.match.latestLineup;
    if (playerLineup != null) return;
    Players zuspieler = globals.playerProvider.getPlayersOfPosition(PlayerPosition.ZUSPIELER);
    Players aussen = globals.playerProvider.getPlayersOfPosition(PlayerPosition.AUSSEN);
    Players mitte = globals.playerProvider.getPlayersOfPosition(PlayerPosition.MITTE);
    Players diagonal = globals.playerProvider.getPlayersOfPosition(PlayerPosition.DIAGONAL);
    //Players libero = globals.playerProvider.getPlayersOfPosition(PlayerPosition.LIBERO);

    if (zuspieler.length < 1 || aussen.length < 2 || mitte.length < 2 || diagonal.length < 1) {
      playerLineup = PlayerLineup(positions: [
        players[0],
        players[1],
        players[2],
        players[3],
        players[4],
        players[5],
      ]);
    } else {
      //create basic läufer 1 lineup
      playerLineup = PlayerLineup(positions: [
        zuspieler[0],
        aussen[0],
        mitte[0],
        diagonal[0],
        aussen[1],
        mitte[1],
      ]);
    }
  }

  Players get benchPlayers {
    return players.where((player) => !playerLineup!.positions.contains(player)).toList();
  }

  @override
  void initState() {
    initPlayerLineup();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setLineupDisplayHeight());
  }

  void _setLineupDisplayHeight() {
    final RenderBox renderBox = _lineupDisplayKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _lineupDisplayHeight = renderBox.size.height;
    });
  }

  Player liberoSwapToBench() {
    int benchPlayerIndex = benchPlayers.indexWhere((player) => int.tryParse(player.number) == int.tryParse(numberPlayerLiberoSwaped!));
    Player libero = playerLineup!.positions.firstWhere((player) => player.position == PlayerPosition.LIBERO);
    Player benchPlayer = benchPlayers.removeAt(benchPlayerIndex);
    setState(() {
      playerLineup!.positions[playerLineup!.positions.indexOf(libero)] = benchPlayer;
      benchPlayers.add(libero);
      numberPlayerLiberoSwaped = null;
    });
    return libero;
  }

  void swapPlayers() async {
    Player? libero;
    int? liberoIndex = playerLineup!.positions.indexWhere((player) => player.position == PlayerPosition.LIBERO);
    if (numberPlayerLiberoSwaped != null) {
      libero = liberoSwapToBench();
    }

    Players relevantBenchPlayers = benchPlayers.where((player) => player.position != PlayerPosition.LIBERO).toList();

    List<Player>? swap = await showDialog(
      context: context,
      builder: (context) {
        return PlayerSwapSelector(
          optionsA: playerLineup!.positions,
          optionsB: relevantBenchPlayers,
          title: 'Swap players',
        );
      },
    );
    if (swap == null) return;

    Player activePlayer = swap[0];
    Player benchPlayer = swap[1];

    setState(() {
      playerLineup!.positions[playerLineup!.positions.indexOf(activePlayer)] = benchPlayer;
      benchPlayers.add(activePlayer);
      benchPlayers.remove(benchPlayer);
    });

    // swap libero back in if necessary
    if (libero != null) {
      setState(() {
        benchPlayers.add(playerLineup!.positions[liberoIndex]);
        numberPlayerLiberoSwaped = playerLineup!.positions[liberoIndex].number;
        playerLineup!.positions[liberoIndex] = libero!;
        benchPlayers.remove(libero);
      });
    }

  }

  void ensureLiberoNotAtNet() {
    if (numberPlayerLiberoSwaped != null) {
      int liberoIndex = playerLineup!.positions.indexWhere((player) => player.position == PlayerPosition.LIBERO);
      if (0<liberoIndex && liberoIndex < 4) liberoSwapToBench();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Match'),
      ),
      body: ListView(
        children: [
          const Divider(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                LineupDisplay(
                  key: _lineupDisplayKey,
                  lineup: playerLineup!,
                  onTap: (i) {},
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
                          onTap: () {},
                          smallFont: true,
                        );
                      }).toList(),
                    )
                  ),
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
                    playerLineup!.rotateBack();
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
                isLabelVisible: numberPlayerLiberoSwaped != null,
                label: Text(numberPlayerLiberoSwaped ?? ''),
                child: IconButton(
                  icon: playerLineup!.liberoIn ? const Icon(Icons.swap_vert_circle_outlined) : const Icon(Icons.swap_vert_circle),
                  tooltip: 'Libero swap',
                  onPressed: () async {
                    if (numberPlayerLiberoSwaped != null) { // swap libero out
                      liberoSwapToBench();
                    } else { //swap libero from bench in
                      Players availableLiberos = benchPlayers.where((player) => player.position == PlayerPosition.LIBERO).toList();
                      Players availableActivePlayers = [playerLineup!.positions[0], playerLineup!.positions[4], playerLineup!.positions[5]];

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
                        playerLineup!.positions[playerLineup!.positions.indexOf(activePlayer)] = libero;
                        numberPlayerLiberoSwaped = activePlayer.number;
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
                    playerLineup!.rotate();
                    ensureLiberoNotAtNet();
                  });
                },
              ),
            ],
          ),
          const Divider()
        ],
      ),
    );
  }
}