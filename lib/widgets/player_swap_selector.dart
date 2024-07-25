import 'package:flutter/material.dart';

import '../models/player.dart';
import 'lineup_display.dart';

typedef GetPlayer = Player Function(PlayerNumber number);

class PlayerSwapSelector extends StatefulWidget {
  final List<PlayerNumber> optionsA;
  final List<PlayerNumber> optionsB;
  final GetPlayer getPlayer;
  final String title;

  const PlayerSwapSelector({super.key, required this.optionsA, required this.optionsB, required this.title, required this.getPlayer});

  @override
  State<PlayerSwapSelector> createState() => _PlayerSwapSelectorState();
}

class _PlayerSwapSelectorState extends State<PlayerSwapSelector> {
  int selectedA = 0;
  int selectedB = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.title, style: Theme.of(context).textTheme.titleMedium,),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.optionsA.map((player) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                        color: selectedA == widget.optionsA.indexOf(player) ? Colors.amber : Colors.transparent,
                      ),
                      child: PlayerDisplayContainer(
                        player: widget.getPlayer(player),
                        onTap: () {
                          setState(() {
                            selectedA = widget.optionsA.indexOf(player);
                          });
                        },
                        smallFont: true,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Icon(Icons.swap_vert, size: 50),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.optionsB.map((player) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                        color: selectedB == widget.optionsB.indexOf(player) ? Colors.amber : Colors.transparent,
                      ),
                      child: PlayerDisplayContainer(
                        player: widget.getPlayer(player),
                        onTap: () {
                          setState(() {
                            selectedB = widget.optionsB.indexOf(player);
                          });
                        },
                        smallFont: true,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.pop(context, [widget.optionsA[selectedA], widget.optionsB[selectedB]]);
              },
              child: Text('Swap', style: Theme.of(context).textTheme.titleMedium),
            ),
          ],
        ),
      ),
    );
  }
}