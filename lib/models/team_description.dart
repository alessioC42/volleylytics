class TeamDescription {
  final String name;
  final String info;
  final String? logoURL;

  TeamDescription({
    required this.name,
    required this.info,
    this.logoURL,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'info': info,
      'logoURL': logoURL,
    };
  }

  TeamDescription.fromJson(Map<String, dynamic> json) :
    name = json['name'],
    info = json['info'],
    logoURL = json['logoURL'];
}