import 'package:volleylytics/models/player.dart';

enum ScoreType {
  BLOCK,
  ANGRIFF,
  DANKE,
  LOP,
  GELEGT,
  TUSCH,
}

class ScoreEvent {
  final ScoreType type;
  final List<Player> players;

  ScoreEvent({
    required this.type,
    required this.players,
  });
}