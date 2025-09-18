class League { //! <--Will change after API-->
  final String id;
  final String name;
  final String backgroundImageUrl;
  final String logoImageUrl;
  final String? description;
  final int? memberCount;

  League({
    required this.id,
    required this.name,
    required this.backgroundImageUrl,
    required this.logoImageUrl,
    this.description,
    this.memberCount,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      name: json['name'],
      backgroundImageUrl: json['backgroundImageUrl'],
      logoImageUrl: json['logoImageUrl'],
      description: json['description'],
      memberCount: json['memberCount'],
    );
  }
}
