import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/rate_action.dart';

class RateActionChart extends StatefulWidget {
  final List<RateAction> rateActions;

  const RateActionChart({super.key, required this.rateActions});

  @override
  State<RateActionChart> createState() => _RateActionChartState();
}

class _RateActionChartState extends State<RateActionChart> {

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      series: <LineSeries<RateAction, String>>[
        LineSeries<RateAction, String>(
          dataSource: widget.rateActions,
          xValueMapper: (RateAction rateAction, _) => DateFormat('mm:ss').format(rateAction.time),
          yValueMapper: (RateAction rateAction, _) => rateAction.rating,
        )
      ],
    );
  }
}