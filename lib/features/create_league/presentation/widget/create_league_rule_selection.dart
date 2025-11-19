import 'package:flutter/material.dart';

class CreateLeagueRulesSection extends StatelessWidget {
  const CreateLeagueRulesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rules & Regulation",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
            children: [
              TextSpan(
                text: "1. Match Format\n",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                "   • Best of 3 sets: First to win 2 sets wins the match \n     (scores: 2–0 or 2–1).\n\n",
              ),
              TextSpan(
                text: "2. Tiebreak Options\n",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                "   • At 6–6 games, choose:\n"
                    "       - Standard Tiebreak (7 points) – win by 2\n"
                    "       - No Tiebreak – play until 2-game lead\n"
                    "       - Super Tiebreak (10 points) – used instead of full 3rd set\n\n",
              ),
              TextSpan(
                text: "3. Scoring Rules\n",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                "   • Traditional: 15–30–40–Game\n"
                    "   • No-Advantage (Golden Point): 40–40 → next point wins\n"
                    "   • Points for standings: Win = 3, Loss = 1 (customizable; bonuses possible)\n",
              ),
            ],
          ),
        ),
      ],
    );
  }
}