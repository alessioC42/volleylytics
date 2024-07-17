import 'package:flutter/material.dart';
import 'package:volleylytics/globals.dart';
import 'package:volleylytics/models/player_lineup.dart';
import 'package:volleylytics/models/volleyball_match.dart';
import 'package:volleylytics/widgets/lineup_display.dart';

import '../../models/player.dart';

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
          const Divider()
        ],
      ),
    );
  }
}