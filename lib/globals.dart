import 'package:volleylytics/providers/player_provider.dart';
import 'package:volleylytics/providers/sams_provider.dart';

class Globals {
  late final SamsProvider samsProvider = SamsProvider();
  late final PlayerProvider playerProvider = PlayerProvider();

  void initializeGlobals() {
    samsProvider.initializeSocket();
    playerProvider.initializePlayers();
  }
}

final Globals globals = Globals();
