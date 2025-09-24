class StandingRowData {
  final String pos, team, p, w, d, l, gd, pts;
  final String? teamIcon;
  final bool highlight;

  StandingRowData({
    required this.pos,
    required this.team,
    required this.p,
    required this.w,
    required this.d,
    required this.l,
    required this.gd,
    required this.pts,
    this.teamIcon,
    this.highlight = false,
  });
}
