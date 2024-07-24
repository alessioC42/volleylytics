import 'package:volleylytics/globals.dart';
import 'package:volleylytics/models/player.dart';
import 'package:volleylytics/models/player_lineup.dart';
import 'package:volleylytics/models/rate_action.dart';
import 'package:volleylytics/models/sams_information.dart';
import 'package:volleylytics/models/team_description.dart';
import 'package:volleylytics/models/volleyball_score.dart';

class VolleyballMatch {
  final SAMSMatchInformation? samsMatchInformation;
  final TeamDescription teamWe;
  final TeamDescription teamThem;
  late List<VolleyballSet> sets;
  final DateTime startTime;
  final List<Player> players;
  PlayerLineup? currentPlayerLineup;
  VolleyballScore? currentScore;
  String? numberPlayerLiberoSwaped;


  VolleyballMatch(this.players, {
    required this.teamWe, required this.teamThem,
    this.samsMatchInformation, required this.startTime,
    List<VolleyballSet>? sets, PlayerLineup? currentPlayerLineup,
    VolleyballScore? currentScore, this.numberPlayerLiberoSwaped
  }) : sets = sets ?? [] {
    this.currentPlayerLineup = currentPlayerLineup ?? generatePlayerLineup();
    this.currentScore = currentScore ?? VolleyballScore();
  }

  PlayerLineup generatePlayerLineup() {
    Players playersNoLibero = globals.playerProvider.players
        .where((player) => !player.isLibero)
        .toList();

    if (playersNoLibero.length < 6) {
      throw Exception('Not enough players to generate a lineup');
    }

    Players zuspieler =
    globals.playerProvider.getPlayersOfPosition(PlayerPosition.ZUSPIELER);
    Players aussen =
    globals.playerProvider.getPlayersOfPosition(PlayerPosition.AUSSEN);
    Players mitte =
    globals.playerProvider.getPlayersOfPosition(PlayerPosition.MITTE);
    Players diagonal =
    globals.playerProvider.getPlayersOfPosition(PlayerPosition.DIAGONAL);
    //Players libero = globals.playerProvider.getPlayersOfPosition(PlayerPosition.LIBERO);

    if (zuspieler.length < 1 ||
        aussen.length < 2 ||
        mitte.length < 2 ||
        diagonal.length < 1) {
      return PlayerLineup(positions: [
        playersNoLibero[0],
        playersNoLibero[1],
        playersNoLibero[2],
        playersNoLibero[3],
        playersNoLibero[4],
        playersNoLibero[5],
      ]);
    } else {
      //create basic läufer 1 lineup
      return PlayerLineup(positions: [
        zuspieler[0],
        aussen[0],
        mitte[0],
        diagonal[0],
        aussen[1],
        mitte[1],
      ]);
    }
  }

  VolleyballSet get latestSet {
    if (sets.isEmpty) {
      sets.add(VolleyballSet(setNumber: 1));
    }
    return sets.last;
  }

  PlayerLineup? get latestLineup {
    if (latestSet.actions.isEmpty) {
      return null;
    }
    return latestSet.actions.last.lineup;
  }

  VolleyballScore get latestScore => latestSet.latestScore;

  Map<String, dynamic> toJson() {
    return {
      'teamWe': teamWe.toJson(),
      'teamThem': teamThem.toJson(),
      'sets': sets.map((set) => set.toJson()).toList(),
      'samsMatchInformation': samsMatchInformation?.toJson(),
      'startTime': startTime.toIso8601String(),
      'players': players.map((player) => player.toJson()).toList(),
      'currentPlayerLineup': currentPlayerLineup?.toJson(),
      'currentScore': currentScore?.toJson(),
      'numberPlayerLiberoSwaped': numberPlayerLiberoSwaped,
    };
  }

  VolleyballMatch.fromJson(Map<String, dynamic> json) :
    teamWe = TeamDescription.fromJson(json['teamWe']),
    teamThem = TeamDescription.fromJson(json['teamThem']),
    samsMatchInformation = json['samsMatchInformation'] != null ? SAMSMatchInformation.fromJson(json['samsMatchInformation']) : null,
    sets = (json['sets'] as List).map((set) => VolleyballSet.fromJson(set)).toList(),
    startTime = DateTime.parse(json['startTime']),
    players = (json['players'] as List).map((player) => Player.fromJson(player)).toList(),
    currentPlayerLineup = json['currentPlayerLineup'] != null ? PlayerLineup.fromJson(json['currentPlayerLineup']) : null,
    currentScore = json['currentScore'] != null ? VolleyballScore.fromJson(json['currentScore']) : null,
    numberPlayerLiberoSwaped = json['numberPlayerLiberoSwaped'];
}

class VolleyballSet {
  List<RateAction> actions = [];
  int setNumber;
  DateTime startTime = DateTime.now();

  VolleyballSet({required this.setNumber});

  VolleyballScore get latestScore {
    if (actions.isEmpty) {
      return VolleyballScore(scoreThem: 0, scoreWe: 0, setNumber: setNumber);
    } else {
      return actions.last.score;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'actions': actions.map((action) => action.toJson()).toList(),
      'setNumber': setNumber,
      'startTime': startTime.toIso8601String(),
    };
  }

  VolleyballSet.fromJson(Map<String, dynamic> json) :
    setNumber = json['setNumber'],
    startTime = DateTime.parse(json['startTime']),
    actions = (json['actions'] as List).map((action) => RateAction.fromJson(action)).toList();
}
