import 'package:flutter/material.dart';
import 'package:volleylytics/globals.dart';

import '../widgets/sams_match_list_tile.dart';

class MatchesBrowserView extends StatefulWidget {
  const MatchesBrowserView({super.key});

  @override
  State<MatchesBrowserView> createState() => _MatchesBrowserViewState();
}

class _MatchesBrowserViewState extends State<MatchesBrowserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Matches Today"),
      ),
      body: ListView.builder(
          itemCount: globals.samsProvider.matches.length,
          itemBuilder: (context, index) {
            return SamsMatchListTile(
              matchInformation: globals.samsProvider.matches[index],
            );
          }),
    );
  }
}
