import 'dart:convert';
import 'dart:io';


import '../models/sams_information.dart';

///Interface to access the SAMS-Ticker websocket API
///
/// Currently hard coded on HVV
class SamsProvider {
  static const apiUri = 'wss://backend.sams-ticker.de/hvv'; //todo: make this configurable
  
  late final WebSocket channel;

  List<SAMSMatchSeries> matchSeries = [];
  List<SAMSMatchInformation> matches = [];

  Future<void> initializeSocket() async {
    channel = await WebSocket.connect(apiUri);

    channel.listen((data) {
      final Map json = jsonDecode(data);
      final type = json['type'];
      final payload = json['payload'];
      if (type == 'FETCH_ASSOCIATION_TICKER_RESPONSE') {
        //parsing the payload to data models to avoid using dynamic types
        for (final seriesId in (payload['matchSeries'].keys)) {
          final matchSeries = payload['matchSeries'][seriesId];
          this.matchSeries.add(SAMSMatchSeries(
            seriesId: matchSeries['id'],
            name: matchSeries['name'],
            shortName: matchSeries['shortName'],
            gender: matchSeries['gender'],
            seriesClass: matchSeries['class'],
            teams: (matchSeries['teams'].map((team) => SAMSTeam(
              teamId: team['id'],
              name: team['name'],
              shortName: team['shortName'],
              clubCode: team['clubCode'],
              letter: team['letter'],
              logo200url: team['logoImage200'],
            ))).toList().cast<SAMSTeam>(),
          ));
        }
        for (final matchDay in payload['matchDays']) {
          DateTime date = DateTime.parse(matchDay['date']);
          List<SAMSMatchInformation> matches = [];
          for (final match in matchDay['matches']) {
            matches.add(SAMSMatchInformation(
              matchId: match['id'],
              teamId1: match['team1'],
              teamDescription1: match['teamDescription1'],
              teamId2: match['team2'],
              teamDescription2: match['teamDescription2'],
              matchSeriesId: match['matchSeries'],
              delayPossible: match['delayPossible'],
              indefinitelyRescheduled: match['indefinitelyRescheduled'],
              matchDate: DateTime.fromMillisecondsSinceEpoch(match['date'] * 1000),
            ));
          }
          this.matches.addAll(matches);
        }
      }
    });
  }

  SAMSMatchSeries? getMatchSeriesById(String id) {
    if (matchSeries.isEmpty) return null;
    return matchSeries.firstWhere((series) => series.seriesId == id);
  }

  SAMSTeam? getTeamById(String id) {
    if (matchSeries.isEmpty) return null;
    return matchSeries.expand((series) => series.teams).firstWhere((team) => team.teamId == id);
  }

  void closeSocket() {
    channel.close();
  }

  void dispose() {
    closeSocket();
  }
}