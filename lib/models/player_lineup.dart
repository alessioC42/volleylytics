import 'package:volleylytics/models/player.dart';

class PlayerLineup {
  late List<Player> positions;

  PlayerLineup({required this.positions});

  void rotate() {
    final Player first = positions.removeAt(0);
    positions.add(first);
  }

  bool setRotation(int lauefer) {
    if (!(positions.any(
        (player) => player.position == PlayerPosition.ZUSPIELER))) return false;
    while (!(positions[lauefer].position == PlayerPosition.ZUSPIELER)) {
      rotate();
    }
    return true;
  }
}
