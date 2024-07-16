class VolleyballScore {
  final int scoreWe;
  final int scoreThem;
  final int setNumber;

  VolleyballScore({
    required this.scoreWe,
    required this.scoreThem,
    required this.setNumber,
  });

  bool get isHomeLeading {
    return scoreWe > scoreThem;
  }

  bool get isGuestLeading {
    return scoreThem > scoreWe;
  }

  bool get isDraw {
    return scoreWe == scoreThem;
  }

  bool get isSetOver {
    int difference = (scoreWe - scoreThem).abs();

    if ((scoreWe >= 25 || scoreThem >= 25) && difference >= 2) {
      return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'scoreWe': scoreWe,
      'scoreThem': scoreThem,
      'setNumber': setNumber,
    };
  }

  VolleyballScore.fromJson(Map<String, dynamic> json) :
    scoreWe = json['scoreWe'],
    scoreThem = json['scoreThem'],
    setNumber = json['setNumber'];
}
