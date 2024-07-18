class VolleyballScore {
  int scoreWe;
  int scoreThem;
  int setScorewe;
  int setScoreThem;
  int setNumber;

  VolleyballScore({
    this.scoreWe = 0,
    this.scoreThem = 0,
    this.setScorewe = 0,
    this.setScoreThem = 0,
    this.setNumber = 1,
  });

  void handleIncrement() {
    if (isSetOver) {
      if (scoreThem > scoreWe) {
        incrementSetThem();
      } else {
        incrementSetWe();
      }
      scoreWe = 0;
      scoreThem = 0;
    }
  }

  void incrementWe() {
    scoreWe++;
    handleIncrement();
  }

  void incrementThem() {
    scoreThem++;
    handleIncrement();
  }

  void decrementWe() {
    if (scoreWe > 0) {
      scoreWe--;
    }
  }

  void decrementThem() {
    if (scoreThem > 0) {
      scoreThem--;
    }
  }

  void decrementSetWe() {
    if (setScorewe > 0) {
      setScorewe--;
    }
  }

  void decrementSetThem() {
    if (setScoreThem > 0) {
      setScoreThem--;
    }
  }

  void incrementSetWe() {
    setScorewe++;
  }

  void incrementSetThem() {
    setScoreThem++;
  }


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
      'setScoreWe': setScorewe,
      'setScoreThem': setScoreThem,
    };
  }

  VolleyballScore.fromJson(Map<String, dynamic> json) :
    scoreWe = json['scoreWe'],
    scoreThem = json['scoreThem'],
    setNumber = json['setNumber'],
    setScorewe = json['setScoreWe'],
    setScoreThem = json['setScoreThem'];
}
