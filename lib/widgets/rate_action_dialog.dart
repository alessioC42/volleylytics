import 'package:flutter/material.dart';
import 'package:volleylytics/models/player_lineup.dart';
import 'package:volleylytics/models/volleyball_score.dart';

import '../models/player.dart';

class RateActionDialog extends StatefulWidget {
  const RateActionDialog({super.key, required this.player, required this.score, required this.lineup});

  final Player player;
  final VolleyballScore score;
  final PlayerLineup lineup;

  @override
  State<RateActionDialog> createState() => _RateActionDialogState();
}

class _RateActionDialogState extends State<RateActionDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Column(
        children: [
          const Text('Rate Action'),
          Text('Player: ${widget.player.displayName}'),
          Text('Score: ${widget.score}'),
          Text('Lineup: ${widget.lineup}'),
        ],
      ),
    );
  }
}