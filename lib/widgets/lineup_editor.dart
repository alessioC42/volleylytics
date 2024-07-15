import 'package:flutter/material.dart';

import '../models/player.dart';
import '../models/player_lineup.dart';

class LineupEditor extends StatelessWidget {
  final PlayerLineup lineup;
  final Size boardSize;
  final double padding;

  const LineupEditor(
      {super.key,
      required this.lineup,
      required this.boardSize,
      required this.padding});

  final borderWidth = 4.0;
  final backgroundColor = Colors.orangeAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boardSize.width - padding / 2,
      height: boardSize.height - padding / 2,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: borderWidth),
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(borderWidth)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: boardSize.height / 3 - borderWidth / 2,
            left: 0,
            child: Container(
              width: boardSize.height,
              height: borderWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            height: boardSize.height / 3,
            width: boardSize.width - padding / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: NumberContainer(
                        player: lineup.positions[3],
                        onTap: () => debugPrint('4'))),
                Expanded(
                    child: NumberContainer(
                        player: lineup.positions[2],
                        onTap: () => debugPrint('3'))),
                Expanded(
                    child: NumberContainer(
                        player: lineup.positions[1],
                        onTap: () => debugPrint('2'))),
              ],
            ),
          ),
          Positioned(
            top: (boardSize.height / 5) * 2,
            left: 0,
            height: boardSize.height / 3,
            width: boardSize.width - padding / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: NumberContainer(
                        player: lineup.positions[4],
                        onTap: () => debugPrint('5'))),
                Expanded(
                    child: NumberContainer(
                        player: lineup.positions[5],
                        onTap: () => debugPrint('6'))),
                Expanded(
                    child: NumberContainer(
                        player: lineup.positions[0],
                        onTap: () => debugPrint('1'))),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NumberContainer extends StatelessWidget {
  final Player player;
  final VoidCallback onTap; // Changed to VoidCallback for better type safety

  const NumberContainer({super.key, required this.player, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Use the onTap callback here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Theme.of(context).colorScheme.tertiaryContainer,
            ),
            padding: const EdgeInsets.all(6),
            child: Text(player.number,
                style: Theme.of(context).textTheme.displaySmall),
          ),
          Text(
            player.displayName,
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
