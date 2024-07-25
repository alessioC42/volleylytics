enum PlayerPosition { AUSSEN, MITTE, LIBERO, ZUSPIELER, DIAGONAL }

typedef Players = List<Player>;
typedef PlayerNumber = int;

extension PlayerPositionExtension on PlayerPosition {
  String toShortString() {
    return toString().split('.').last;
  }

  String getIndicationLetter() {
    return toShortString().substring(0, 1);
  }

  String getDisplayName() {
    switch (this) {
      case PlayerPosition.AUSSEN:
        return 'Außen';
      case PlayerPosition.MITTE:
        return 'Mitte';
      case PlayerPosition.LIBERO:
        return 'Libero';
      case PlayerPosition.ZUSPIELER:
        return 'Zuspieler';
      case PlayerPosition.DIAGONAL:
        return 'Diagonal';
    }
  }

  static PlayerPosition fromShortString(String str) {
    switch (str) {
      case 'AUSSEN':
        return PlayerPosition.AUSSEN;
      case 'MITTE':
        return PlayerPosition.MITTE;
      case 'LIBERO':
        return PlayerPosition.LIBERO;
      case 'ZUSPIELER':
        return PlayerPosition.ZUSPIELER;
      case 'DIAGONAL':
        return PlayerPosition.DIAGONAL;
      default:
        throw ArgumentError('Unknown player position string: $str');
    }
  }
}

class Player {
  String firstName;
  String secondName;
  String? nickname;
  PlayerNumber number;
  PlayerPosition? position;
  bool isCaptain;

  Player(
      {required this.firstName,
      required this.secondName,
      required this.number,
      this.position,
      this.nickname,
      this.isCaptain = false});

  String get displayName => nickname ?? secondName;
  bool get isLibero => position == PlayerPosition.LIBERO;

  // fill up to two digits
  String get displayNumber {
    if (number.toString().length == 1) {
    return '0$number';
    } else {
    return number.toString();
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Player &&
      other.firstName == firstName &&
      other.secondName == secondName &&
      other.nickname == nickname &&
      other.number == number &&
      other.position == position &&
      other.isCaptain == isCaptain;
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'secondName': secondName,
      'nickname': nickname,
      'number': number,
      'position': position?.toShortString(),
      'isCaptain': isCaptain
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      firstName: json['firstName'],
      secondName: json['secondName'],
      number: json['number'],
      position: json['position'] != null
          ? PlayerPositionExtension.fromShortString(json['position'])
          : null,
      nickname: json['nickname'],
      isCaptain: json['isCaptain'] ?? false,
    );
  }

  @override
  int get hashCode => firstName.hashCode ^ secondName.hashCode ^ number.hashCode ^ position.hashCode ^ isCaptain.hashCode ^ nickname.hashCode;
}
