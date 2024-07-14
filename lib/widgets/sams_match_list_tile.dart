import 'package:flutter/material.dart';

import '../globals.dart';
import '../models/sams_information.dart';

class SamsMatchListTile extends ListTile {
  final SAMSMatchInformation matchInformation;

  late final SAMSTeam team1;
  late final SAMSTeam team2;

  static const teamFontStyle = TextStyle(
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis,
  );

  SamsMatchListTile({super.key, required this.matchInformation}) {
    team1 = globals.samsProvider.getTeamById(matchInformation.teamId1!)!;
    team2 = globals.samsProvider.getTeamById(matchInformation.teamId2!)!;
  }

  @override
  get title => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          team1.shortName != "" ? team1.shortName : team1.name,
          style: teamFontStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const Text("vs."),
      Expanded(
        child: Text(
          team2.shortName != "" ? team2.shortName : team2.name,
          style: teamFontStyle,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
        ),
      ),
    ],
  );

  @override
  get subtitle => Text(dateFormatted());

  @override
  get leading => Image.network(team1.logo200url ?? "https://via.placeholder.com/150");

  @override
  get trailing => Image.network(team2.logo200url ?? "https://via.placeholder.com/150");

  String dateFormatted() {
    // pattern example: Mo, 17.05 12:00
    return "${matchInformation.matchDate.weekday}, ${matchInformation.matchDate.day}.${matchInformation.matchDate.month} ${matchInformation.matchDate.hour}:${matchInformation.matchDate.minute}";
  }
}
