import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:volleylytics/models/player_lineup.dart';
import 'package:volleylytics/models/volleyball_score.dart';
import 'package:volleylytics/widgets/lineup_display.dart';

import '../models/player.dart';
import '../models/rate_action.dart';

class RateActionDialog extends StatefulWidget {
  const RateActionDialog(
      {super.key,
      required this.player,
      required this.score,
      required this.lineup});

  final Player player;
  final VolleyballScore score;
  final PlayerLineup lineup;

  @override
  State<RateActionDialog> createState() => _RateActionDialogState();
}

class _RateActionDialogState extends State<RateActionDialog> {
  double rating = 2.5;
  RecordAction selectedAction = RecordAction.values.first;

  @override
  Widget build(BuildContext context) {
    Color ratingColor = getRatingColor(rating);

    return Dialog.fullscreen(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 30),
          PlayerDisplayContainer(player: widget.player, onTap: () {}),
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 30,),
                Expanded(
                  child: SingleChildScrollView(

                    child: Column(
                      children: RecordAction.values
                          .map((action) => InkWell(
                        onTap: () {
                          setState(() {
                            selectedAction = action;
                          });
                        },
                          child: Row(
                            children: [
                              Radio<RecordAction>(
                                value: action,
                                groupValue: selectedAction,
                                onChanged: (RecordAction? value) {
                                  setState(() {
                                    selectedAction = value!;
                                  });
                                },
                              ),
                              Icon(action.icon),
                              Text(' ${action.toString().split('.').last}', style: Theme.of(context).textTheme.headlineMedium,),
                            ],
                          ),
                      ))
                          .toList(),
                    ),
                  ),
                ),
                SfSliderTheme(
                    data: SfSliderThemeData(
                      activeTrackColor: ratingColor,
                      activeTrackHeight: 10,
                      inactiveTrackHeight: 9,
                      thumbColor: Color.lerp(ratingColor, Colors.blueAccent, 0.3),
                      thumbStrokeColor: ratingColor,
                      thumbStrokeWidth: 15,
                      thumbRadius: 30,
                      overlayColor: Colors.blue.withOpacity(0.12),
                      inactiveTrackColor: Colors.grey,
                    ),
                    child: SfSlider.vertical(
                      min: 0.0,
                      max: 5.0,
                      value: rating,
                      interval: 1,
                      showTicks: false,
                      showLabels: false,
                      onChanged: (dynamic value) {
                        setState(() {
                          rating = value;
                        });
                      },
                    ),
                  ),
                const SizedBox(width: 30,)
              ],
            ),
          ),
          FilledButton(
            onPressed: () {
              final RateAction rateAction = RateAction(
                player: widget.player.number,
                action: selectedAction,
                rating: rating,
                score: widget.score.copy(),
                lineup: widget.lineup.copy(),
              );
              Navigator.of(context).pop(rateAction);
            },
            child: const Text('Submit'),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

Color getRatingColor(double rating) {
  double x = rating / 5 * 510;
  int r = (x < 255) ? 255 : 510 - x.toInt();
  int g = (x > 255) ? 255 : x.toInt();
  return Color.fromARGB(255, r, g, 0);
}