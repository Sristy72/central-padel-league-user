class Standing {
  final int pos;
  final String teamLogoPath;
  final String teamName;
  final int p;
  final int w;
  final int d;
  final int l;
  final int plusMinus;
  final int pts;

  const Standing({
    required this.pos,
    required this.teamLogoPath,
    required this.teamName,
    required this.p,
    required this.w,
    required this.d,
    required this.l,
    required this.plusMinus,
    required this.pts,
  });

  // Factory constructor to create a Standing object from a JSON map
  factory Standing.fromJson(Map<String, dynamic> json) {
    return Standing(
      pos: json['pos'] as int,
      teamLogoPath: json['teamLogoPath'] as String,
      teamName: json['teamName'] as String,
      p: json['p'] as int,
      w: json['w'] as int,
      d: json['d'] as int,
      l: json['l'] as int,
      plusMinus: json['plusMinus'] as int,
      pts: json['pts'] as int,
    );
  }
}