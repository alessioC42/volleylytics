import 'package:flutter/material.dart';
import 'package:volleylytics/models/player.dart';
import 'package:volleylytics/models/player_lineup.dart';
import 'package:volleylytics/models/volleyball_score.dart';

enum RecordAction {
  /// Aufschlag
  serve,
  /// Annahme
  receive,
  /// Angriff
  set,
  /// Angriff
  attack,
  /// Block
  block,
  /// Bagger
  dig,
  /// Zuspiel
  assist,
  /// Fehler
  error,
}

/// A record of a sings event of an player
class RateAction {
  final Player player;
  final RecordAction action;
  /// Rating from 0 to 5
  final double rating;
  final VolleyballScore score;
  final PlayerLineup lineup;
  DateTime time;

  RateAction({
    required this.player,
    required this.action,
    required this.rating,
    required this.score,
    required this.lineup,
    DateTime? time,
  }) : time = time ?? DateTime.now();

  get ratingColor {
    if (rating < 1) {
      return Colors.red;
    } else if (rating < 2) {
      return Colors.orange;
    } else if (rating < 3) {
      return Colors.yellow;
    } else if (rating < 4) {
      return Colors.lightGreen;
    } else {
      return Colors.green;
    }
  }

  //toJSON
  Map<String, dynamic> toJson() {
    return {
      'player': player.toJson(),
      'action': action.toString(),
      'rating': rating,
      'score': score.toJson(),
      'time': time.toIso8601String(),
      'lineup': lineup.toJson(),
    };
  }

  //fromJSON
  RateAction.fromJson(Map<String, dynamic> json) :
    player = Player.fromJson(json['player']),
    action = RecordAction.values.firstWhere((e) => e.toString() == json['action']),
    rating = json['rating'],
    score = VolleyballScore.fromJson(json['score']),
    time = DateTime.parse(json['time']),
    lineup = PlayerLineup.fromJson(json['lineup']);
}
