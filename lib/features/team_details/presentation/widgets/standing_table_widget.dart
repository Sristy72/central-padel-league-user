import 'package:flutter/material.dart';
import '../../data/models/standing_row_data.dart';

Widget buildStandingTable(List<StandingRowData> rows) {
  return Column(
    children: [
      buildStandingRow("Pos", "Team", "P", "W", "D", "L", "+/-", "PTS",
          header: true),
      const SizedBox(height: 6),
      for (var row in rows) ...[
        buildStandingRow(
          row.pos,
          row.team,
          row.p,
          row.w,
          row.d,
          row.l,
          row.gd,
          row.pts,
          teamIcon: row.teamIcon,
          highlight: row.highlight,
        ),
        const SizedBox(height: 6),
      ]
    ],
  );
}

Widget buildStandingRow(
    String pos,
    String team,
    String p,
    String w,
    String d,
    String l,
    String gd,
    String pts, {
      bool header = false,
      String? teamIcon,
      bool highlight = false,
      bool isEven = false,
    }) {
  Color textColor;
  if (header) {
    textColor = Colors.white;
  } else if (highlight) {
    textColor = Colors.white;
  } else {
    textColor = Colors.black;
  }

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    decoration: BoxDecoration(
      color: header
          ? const Color(0xFF141414)
          : highlight
          ? const Color(0xFF464646)
          : isEven
          ? const Color(0xFFB1B1B1)
          : const Color(0xFFB1B1B1),
      border: Border(
        bottom: BorderSide(
          color: Colors.white24,
          width: header ? 1 : 0.5,
        ),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            pos,
            style: TextStyle(
              color: textColor,
              fontWeight: header ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              if (!header && teamIcon != null) ...[
                Image.asset(teamIcon, width: 16, height: 16),
                const SizedBox(width: 6),
              ],
              Text(
                team,
                style: TextStyle(
                  color: textColor,
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: Text(p,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 12))),
        Expanded(
            child: Text(w,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 12))),
        Expanded(
            child: Text(d,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 12))),
        Expanded(
            child: Text(l,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 12))),
        Expanded(
            child: Text(gd,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 12))),
        Expanded(
            child: Text(pts,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 12))),
      ],
    ),
  );
}
