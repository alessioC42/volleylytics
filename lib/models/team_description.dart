class TeamDescription {
  String name;
  String? logoURL;

  TeamDescription({
    required this.name,
    this.logoURL,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logoURL': logoURL,
    };
  }

  TeamDescription.fromJson(Map<String, dynamic> json) :
    name = json['name'],
    logoURL = json['logoURL'];
}