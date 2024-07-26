import 'package:flutter/material.dart';
import 'package:volleylytics/models/player.dart';
import 'package:volleylytics/models/volleyball_match.dart';

import '../../models/rate_action.dart';
import '../../widgets/analyzer/rate_action_chart.dart';

class GameAnalyzer extends StatefulWidget {
  final VolleyballMatch match;

  const GameAnalyzer({super.key, required this.match});

  @override
  State<GameAnalyzer> createState() => _GameAnalyzerState();
}

class _GameAnalyzerState extends State<GameAnalyzer> {
  late List<AnalyzingGroup> analyzingGroups;

  @override void initState() {
    super.initState();
    analyzingGroups = generateAnalyzingGroups(widget.match);
  }

  List<AnalyzingGroup> generateAnalyzingGroups(VolleyballMatch match) {
    List<AnalyzingGroup> result = [];

    result.add(AnalyzingGroup(
      title: 'All',
      rateActions: match.allRateActions,
      icon: (context) => const Icon(Icons.people),
    ));

    List<PlayerNumber> uniquePlayers = match.allRateActions.map((action) => action.player).toSet().toList();
    for (PlayerNumber playerNumber in uniquePlayers) {
      Player player = match.getPlayer(playerNumber);

      result.add(AnalyzingGroup(
        title: player.displayName,
        rateActions: match.allRateActions.where((action) => action.player == playerNumber).toList(),
        icon: (context) => Badge(
          label: Text(player.position?.getIndicationLetter() ?? '?'),
          backgroundColor: player.isCaptain ? null : Colors.blue,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: player.isLibero ? Colors.deepOrange : Theme.of(context).colorScheme.tertiaryContainer,
            ),
            padding: const EdgeInsets.all(6),
            child: Text(player.displayNumber,
              style: Theme.of(context).textTheme.bodySmall, ),
          ),
        ),
      ));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: analyzingGroups.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analyzer'),
          bottom: TabBar(
            dividerColor: Colors.transparent,
            tabs: analyzingGroups.map((group) => Tab(
              text: group.title,
              icon: group.icon(context),
            )).toList(),
            isScrollable: true,
          ),
        ),
        body: TabBarView(
          children: analyzingGroups.map((group) => SetWiseAnalyzer(group.rateActions)).toList(),
        ),
      ),
    );
  }
}

class SetWiseAnalyzer extends StatefulWidget {
  const SetWiseAnalyzer(this.rateActions, {super.key});

  final List<RateAction> rateActions;

  @override
  State<SetWiseAnalyzer> createState() => _SetWiseAnalyzerState();
}

class _SetWiseAnalyzerState extends State<SetWiseAnalyzer>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  late List<RateActionsWithTitle> tabs;

  List<RateActionsWithTitle> generateTabs(List<RateAction> rateActions) {
    List<RateActionsWithTitle> result = [];

    result.add(RateActionsWithTitle(
      rateActions: rateActions,
      title: 'All',
    ));

    List<int> uniqueSetNumbers = rateActions.map((action) => action.score.setNumber).toSet().toList();
    uniqueSetNumbers.sort();
    for (int setNumber in uniqueSetNumbers) {
      result.add(RateActionsWithTitle(
        rateActions: rateActions.where((action) => action.score.setNumber == setNumber).toList(),
        title: 'Set $setNumber',
      ));
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
    tabs = generateTabs(widget.rateActions);
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar.secondary(
          controller: _tabController,
          tabs: tabs.map((tab) => Tab(text: tab.title)).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: tabs.map((all) {
              return Card(
                margin: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [RateActionChart(
                    rateActions: all.rateActions,
                  )],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class RateActionsWithTitle {
  final List<RateAction> rateActions;
  String title;

  RateActionsWithTitle({required this.rateActions, required this.title});
}

typedef GetIcon = Widget Function(BuildContext context);

class AnalyzingGroup {
  String title;
  List<RateAction> rateActions;
  GetIcon icon;

  AnalyzingGroup({required this.title, required this.rateActions, required this.icon});
}