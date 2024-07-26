import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/volleyball_match.dart';
import 'package:localstorage/localstorage.dart';

/// Class to access/store the Match data and change it if needed
class MatchProvider {
  static String storageKey = 'matchDataAsJSON';

  List<VolleyballMatch> matches = [];

  void initializeMatches() {
    final String matchesJSON = localStorage.getItem(storageKey) ?? '[]';
    final List<dynamic>? matchesList = jsonDecode(matchesJSON);

    if (matchesList == null) {
      return;
    }

    matches = matchesList
        .map((player) => VolleyballMatch.fromJson(player))
        .toList()
        .cast<VolleyballMatch>();
  }

  void saveMatches({List<VolleyballMatch>? newMatchesData}) {
    if (newMatchesData != null) {
      matches = newMatchesData;
    }
    final jsonEncoded = jsonEncode(matches);
    localStorage.setItem(storageKey, jsonEncoded);
  }
}
