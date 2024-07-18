import 'package:flutter/material.dart';

import '../models/player.dart';
import '../models/player_lineup.dart';

typedef OnTapCallback = void Function(int index);

class LineupDisplay extends StatelessWidget {
  final PlayerLineup lineup;
  final OnTapCallback onTap;

  const LineupDisplay({super.key, required this.lineup, required this.onTap});

  final borderWidth = 4.0;
  final backgroundColor = Colors.orangeAccent;

  @override
  Widget build(BuildContext context) {
    // Maximum Square board size
    Size boardSize = MediaQuery.of(context).size;
    boardSize = Size(boardSize.width, boardSize.width * 0.7);

    return Container(
      height: boardSize.height,
      width: boardSize.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: borderWidth),
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(borderWidth)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: boardSize.height * 0.4  - borderWidth / 2,
            left: 0,
            child: Container(
              width: boardSize.width,
              height: borderWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: boardSize.height * 0.03,
            left: 0,
            height: boardSize.height / 3,
            width: boardSize.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: PlayerDisplayContainer(
                        player: lineup.positions[3], onTap: () => onTap(3))),
                Expanded(
                    child: PlayerDisplayContainer(
                        player: lineup.positions[2], onTap: () => onTap(2))),
                Expanded(
                    child: PlayerDisplayContainer(
                        player: lineup.positions[1], onTap: () => onTap(1))),
              ],
            ),
          ),
          Positioned(
            top: boardSize.height * 0.5,
            left: 0,
            height: boardSize.height / 3,
            width: boardSize.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: PlayerDisplayContainer(
                        player: lineup.positions[4], onTap: () => onTap(4))),
                Expanded(
                    child: PlayerDisplayContainer(
                        player: lineup.positions[5], onTap: () => onTap(5))),
                Expanded(
                    child: PlayerDisplayContainer(
                        player: lineup.positions[0], onTap: () => onTap(0))),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PlayerDisplayContainer extends StatelessWidget {
  final Player player;
  final VoidCallback onTap; // Changed to VoidCallback for better type safety
  final bool smallFont;

  const PlayerDisplayContainer(
      {super.key, required this.player, required this.onTap, this.smallFont = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Use the onTap callback here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Badge(
            label: Text(player.position?.getIndicationLetter() ?? '?'),
            backgroundColor: player.isCaptain ? null : Colors.blue,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
              padding: const EdgeInsets.all(6),
              child: Text(player.displayNumber,
                  style: Theme.of(context).textTheme.displaySmall),
            ),
          ),
          Text(
            smallFont ? limitChars(player.displayName, 7) : player.displayName,
            style: smallFont ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

String limitChars(String text, int limit) {
  if (text.length <= limit) {
    return text;
  }
  return '${text.substring(0, limit - 3)}…';
}