import 'package:flutter/material.dart';
import '../../data/models/match_data.dart';

Widget buildMatchCard(MatchData match, VoidCallback onStarToggle) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.all(12),
    height: 83,
    decoration: BoxDecoration(
      color: const Color(0xFF202020),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: date + league + star
        Row(
          children: [
            Text(
              match.date,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            const Spacer(),
            const Text("Premier League",
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            const Spacer(),
            GestureDetector(
              onTap: onStarToggle,
              child: Icon(
                match.isStarred ? Icons.star : Icons.star_border,
                color: match.isStarred ? Colors.green : Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Bottom row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(match.team1,
                    style:
                    const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(width: 6),
                Image.asset(
                  "assets/icons/team1.png",
                  width: 22,
                  height: 22,
                ),
              ],
            ),
            const Text("01:00",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
            Row(
              children: [
                Image.asset(
                  "assets/icons/team2.png",
                  width: 22,
                  height: 22,
                ),
                const SizedBox(width: 6),
                Text(match.team2,
                    style:
                    const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
