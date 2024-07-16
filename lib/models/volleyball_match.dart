import 'package:volleylytics/models/rate_action.dart';
import 'package:volleylytics/models/sams_information.dart';
import 'package:volleylytics/models/team_description.dart';
import 'package:volleylytics/models/volleyball_score.dart';

class VolleyballMatch {
  final SAMSMatchInformation? samsMatchInformation;
  final TeamDescription teamWe;
  final TeamDescription teamThem;
  List<VolleyballSet> sets = [];
  final DateTime startTime;

  VolleyballMatch({
    required this.teamWe, required this.teamThem,
    this.samsMatchInformation, required this.startTime
  });

  VolleyballSet get latestSet {
    if (sets.isEmpty) {
      sets.add(VolleyballSet(setNumber: 1));
    }
    return sets.last;
  }

  Map<String, dynamic> toJson() {
    return {
      'teamWe': teamWe.toJson(),
      'teamThem': teamThem.toJson(),
      'sets': sets.map((set) => set.toJson()).toList(),
      'samsMatchInformation': samsMatchInformation?.toJson(),
      'startTime': startTime.toIso8601String(),
    };
  }

  VolleyballMatch.fromJson(Map<String, dynamic> json) :
    teamWe = TeamDescription.fromJson(json['teamWe']),
    teamThem = TeamDescription.fromJson(json['teamThem']),
    samsMatchInformation = json['samsMatchInformation'] != null ? SAMSMatchInformation.fromJson(json['samsMatchInformation']) : null,
    sets = (json['sets'] as List).map((set) => VolleyballSet.fromJson(set)).toList(),
    startTime = DateTime.parse(json['startTime']);
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
