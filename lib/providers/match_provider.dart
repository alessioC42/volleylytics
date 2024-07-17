import 'dart:convert';

import '../models/volleyball_match.dart';
import 'package:localstorage/localstorage.dart';

/// Class to access/store the Match data and change it if needed
class MatchProvider {
  static String storageKey = 'matchDataAsJSON';

  List<VolleyballMatch> matches = [];

  void initializeMatches() {
    final String matchesJSON = localStorage.getItem(storageKey) ?? '[]';
    final List<dynamic> matchesList = jsonDecode(matchesJSON);
    matches = matchesList
        .map((player) => VolleyballMatch.fromJson(player))
        .toList()
        .cast<VolleyballMatch>();
  }

  void saveMatches(List<VolleyballMatch> newMatchesData) {
    matches = newMatchesData;
    final jsonEncoded = jsonEncode(newMatchesData);
    localStorage.setItem(storageKey, jsonEncoded);
  }
}