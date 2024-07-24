import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:volleylytics/models/player_lineup.dart';
import 'package:volleylytics/models/volleyball_score.dart';

import '../models/player.dart';

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

  static Color getRatingColor(double rating) {
    double x = rating / 5 * 510;
    int r = (x < 255) ? 255 : 510 - x.toInt();
    int g = (x > 255) ? 255 : x.toInt();
    return Color.fromARGB(255, r, g, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          const Text('Rate Action'),
          const SizedBox(height: 40),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(),//todo selector
                ),
                Expanded(
                  child: SfSliderTheme(
                    data: SfSliderThemeData(
                      activeTrackColor: Colors.blue,
                      activeTrackHeight: 10,
                      inactiveTrackHeight: 9,
                      thumbColor: Colors.blue,
                      thumbStrokeColor: getRatingColor(rating),
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
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {},
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }
}
