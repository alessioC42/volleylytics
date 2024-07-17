import 'dart:convert';

import '../models/player.dart';
import 'package:localstorage/localstorage.dart';

/// Class to access/store the Player data and change it if needed
class PlayerProvider {
  static String storageKey = 'playerDataAsJSON';

  List<Player> players = [];

  void initializePlayers() {
    final String playerJSON = localStorage.getItem(storageKey) ?? '[]';
    final List<dynamic> playerList = jsonDecode(playerJSON);
    players = playerList
        .map((player) => Player.fromJson(player))
        .toList()
        .cast<Player>();
  }

  void savePlayers(List<Player> newPlayerData) {
    players = newPlayerData;
    final jsonEncoded = jsonEncode(newPlayerData);
    localStorage.setItem(storageKey, jsonEncoded);
  }

  bool doesCaptainExist() {
    return players.any((player) => player.isCaptain);
  }

  List<Player> getPlayersOfPosition(PlayerPosition? position) {
    return players.where((player) => player.position == position).toList();
  }
}
