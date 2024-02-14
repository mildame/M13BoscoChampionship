import 'dart:convert';

class Team {
  int id;
  String name;
  String logo;
  String backdrop;
  Team({
    required this.id,
    required this.name,
    required this.logo,
    required this.backdrop,
  });

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'] as int,
      name: map['name'] ?? '',
      logo: map['logo'] ?? '',
      backdrop: map['backdrop'] ?? '',
    );
  }

  factory Team.fromJson(String source) => Team.fromMap(json.decode(source));
}
