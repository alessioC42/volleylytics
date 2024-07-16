import 'package:volleylytics/providers/match_provider.dart';
import 'package:volleylytics/providers/player_provider.dart';
import 'package:volleylytics/providers/sams_provider.dart';

class Globals {
  late final SamsProvider samsProvider = SamsProvider();
  late final PlayerProvider playerProvider = PlayerProvider();
  late final MatchProvider matchProvider = MatchProvider();

  void initializeGlobals() {
    samsProvider.initializeSocket();
    playerProvider.initializePlayers();
    matchProvider.initializeMatches();
  }
}

final Globals globals = Globals();
