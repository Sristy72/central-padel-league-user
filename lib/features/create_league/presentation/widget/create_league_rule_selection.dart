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
                "   \u2022 Best of 3 sets: First to win 2 sets wins the match \n     (scores: 2–0 or 2–1).\n\n"
                "   \u2022 If you are (for example)  1 set each 3 games each and one team is \n\t\t\t\t\t40/15, that team wins and takes all 3 points if the games has to \n\t\t\t\t\tfinish. (This has to be agreed before the match starts) or it’s a \n\t\t\t\t\tdraw based on 1 set each 3 games each. Each team gets a point.\n\n ",
              ),
              TextSpan(
                text: "2. Tiebreak Options\n",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                "   \u2022 At 6–6 games, choose:\n"
                    "       - Standard Tiebreak (7 points) – win by 2\n"
                    "       - No Tiebreak – play until 2-game lead\n"
                    "       - Super Tiebreak (10 points) – used instead of full 3rd set\n\n",
              ),
              TextSpan(
                text: "3. Points for a win. 1 point for a draw.\n\n",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
               TextSpan(
                text: "4. Games must be organised between the two teams and payment to \n\t\t\t\t\tbe split.\n\n",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),          
               TextSpan(
                text: "5. Score to be entered into the app as soon as the match has \n\t\t\t\t\tfinished and agreed by both teams.\n\n",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
               TextSpan(
                text: "6.To be agreed before the match if the scores are to be recorded \n\t\t\t\t\tonto the Playt*mic app.\n\n",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              //  TextSpan(
              //   text: "\u2605 Once the league has finished have an option to delete league.",
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}




