import 'package:volleylytics/models/player.dart';

class PlayerLineup {
  late List<PlayerNumber> positions;

  PlayerLineup({required this.positions});

  void rotate() {
    final PlayerNumber first = positions.removeAt(0);
    positions.add(first);
  }

  void rotateBack() {
    final PlayerNumber last = positions.removeLast();
    positions.insert(0, last);
  }

  bool liberoIn(List<Player> players) {
    return positions.any((position) => players.any((player) => player.number == position && player.position == PlayerPosition.LIBERO));
  }

  List<int> toJson() {
    return positions;
  }

  PlayerLineup.fromJson(List<dynamic> json) :
    positions = json.map((x) => int.tryParse(x.toString()) ?? -1).toList();

  PlayerLineup copy() {
    return PlayerLineup(positions: List<PlayerNumber>.from(positions));
  }
}
