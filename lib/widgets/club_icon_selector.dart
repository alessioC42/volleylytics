import 'package:flutter/material.dart';

import '../globals.dart';

typedef ClubIconSelectorCallback = void Function(String? query);

class ClubIconSelector extends StatefulWidget {
  final String query;
  final ClubIconSelectorCallback onIconSelected;

  const ClubIconSelector({super.key, required this.query, required this.onIconSelected});

  @override
  State<ClubIconSelector> createState() => _ClubIconSelectorState();
}

class _ClubIconSelectorState extends State<ClubIconSelector> {
  int selectedIcon = 0;

  String? searchClubIcon(String query) {
    if (query.isEmpty) {
      return null;
    }

    query = query.toLowerCase();
    int highestScore = 0;
    String? bestMatchUrl;

    for (var team in globals.samsProvider.matchSeries.expand((series) => series.teams)) {
      String teamName = team.name.toLowerCase();
      int score = longestCommonSubstring(query, teamName).length;
      if (score > highestScore) {
        highestScore = score;
        bestMatchUrl = team.logo200url;
      }
    }

    return bestMatchUrl;
  }

  String longestCommonSubstring(String s1, String s2) {
    int m = s1.length;
    int n = s2.length;
    List<List<int>> dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));
    int lengthOfLongest = 0;
    int endIndex = 0;

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1] + 1;
          if (dp[i][j] > lengthOfLongest) {
            lengthOfLongest = dp[i][j];
            endIndex = i;
          }
        }
      }
    }

    return s1.substring(endIndex - lengthOfLongest, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    String? imageUrl = searchClubIcon(widget.query);
    widget.onIconSelected(imageUrl);
    return imageUrl == null
        ? const Icon(Icons.sports_volleyball)
        : Image.network(imageUrl);
  }
}