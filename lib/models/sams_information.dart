//This file contains data models for SAMS system responses on initial connect with websocket server at
// wss://backend.sams-ticker.de/hvv

typedef MatchSeriesId = String;

/// Contains Match information in SAMS system
class SAMSMatchInformation {
  final String matchId;
  final String teamDescription1;
  final String? teamId1;
  final String teamDescription2;
  final String? teamId2;
  final DateTime matchDate;
  final bool indefinitelyRescheduled;
  final bool delayPossible;
  final MatchSeriesId matchSeriesId;

  SAMSMatchInformation({
    required this.matchId,
    required this.teamDescription1,
    this.teamId1,
    required this.teamDescription2,
    this.teamId2,
    required this.matchDate,
    required this.indefinitelyRescheduled,
    required this.delayPossible,
    required this.matchSeriesId,
  });

  factory SAMSMatchInformation.fromJson(Map<String, dynamic> json) {
    return SAMSMatchInformation(
      matchId: json['matchId'],
      teamDescription1: json['teamDescription1'],
      teamId1: json['teamId1'],
      teamDescription2: json['teamDescription2'],
      teamId2: json['teamId2'],
      matchDate: DateTime.parse(json['matchDate']),
      indefinitelyRescheduled: json['indefinitelyRescheduled'],
      delayPossible: json['delayPossible'],
      matchSeriesId: json['matchSeries'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'teamDescription1': teamDescription1,
      'teamId1': teamId1,
      'teamDescription2': teamDescription2,
      'teamId2': teamId2,
      'matchDate': matchDate.toIso8601String(),
      'indefinitelyRescheduled': indefinitelyRescheduled,
      'delayPossible': delayPossible,
      'matchSeries': matchSeriesId,
    };
  }
}

/// Contains information about a Match Series (Liga) in SAMS system
class SAMSMatchSeries {
  final String seriesId;
  final String name;
  final String seriesClass;
  final String shortName;
  /// "MALE" or "FEMALE" todo: enum
  final String gender;
  final List<SAMSTeam> teams;

  SAMSMatchSeries({
    required this.seriesId,
    required this.name,
    required this.seriesClass,
    required this.shortName,
    required this.gender,
    required this.teams,
  });

  factory SAMSMatchSeries.fromJson(Map<String, dynamic> json) {
    return SAMSMatchSeries(
      seriesId: json['seriesId'],
      name: json['name'],
      seriesClass: json['seriesClass'],
      shortName: json['shortName'],
      gender: json['gender'],
      teams: (json['teams'] as List).map((team) => SAMSTeam.fromJson(team)).toList(),
    );}

  Map<String, dynamic> toJson() {
    return {
      'seriesId': seriesId,
      'name': name,
      'seriesClass': seriesClass,
      'shortName': shortName,
      'gender': gender,
      'teams': teams,
    };
  }
}

/// Contains information about a Team in SAMS system
class SAMSTeam {
  final String teamId;
  final String name;
  final String shortName;
  final String clubCode;
  final String letter;
  final String? logo200url;

  SAMSTeam({
    required this.teamId,
    required this.name,
    required this.shortName,
    required this.clubCode,
    required this.letter,
    required this.logo200url,
  });

  factory SAMSTeam.fromJson(Map<String, dynamic> json) {
    return SAMSTeam(
      teamId: json['teamId'],
      name: json['name'],
      shortName: json['shortName'],
      clubCode: json['clubCode'],
      letter: json['letter'],
      logo200url: json['logo200url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teamId': teamId,
      'name': name,
      'shortName': shortName,
      'clubCode': clubCode,
      'letter': letter,
      'logo200url': logo200url,
    };
  }
}