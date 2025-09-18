import 'package:flutter/material.dart';
import 'package:karlfive/core/theme/app_colors.dart';

class FixturesTab extends StatefulWidget {
  const FixturesTab({super.key});

  @override
  State<FixturesTab> createState() => _FixturesTabState();
}

class _FixturesTabState extends State<FixturesTab> {
  int selectedWeek = 0;

  final weeks = ["Game Week 1", "Game Week 2", "Game Week 3", "Game Week 4"];

  final fixtures = {
    "SAT 16 AUG 2025": [
      {"home": "Baseline Smashers", "away": "Topspin Titans", "time": "01:00"},
      {"home": "Baseline Smashers", "away": "Topspin Titans", "time": "01:00"},
      {"home": "Baseline Smashers", "away": "Topspin Titans", "time": "01:00"},
    ],
    "SUN 17 AUG 2025": [
      {"home": "Baseline Smashers", "away": "Topspin Titans", "time": "01:00"},
      {"home": "Baseline Smashers", "away": "Topspin Titans", "time": "01:00"},
      {"home": "Baseline Smashers", "away": "Topspin Titans", "time": "01:00"},
    ],
    "SAT 21 AUG 2025": [
      {"home": "Baseline Smashers", "away": "Topspin Titans", "time": "01:00"},
      {"home": "Baseline Smashers", "away": "Topspin Titans", "time": "01:00"},
      {"home": "Baseline Smashers", "away": "Topspin Titans", "time": "01:00"},
    ],
    "SUN 30 AUG 2025": [
      {"home": "Baseline Smashers", "away": "Topspin Titans", "time": "01:00"},
      {"home": "Baseline Smashers", "away": "Topspin Titans", "time": "01:00"},
      {"home": "Baseline Smashers", "away": "Topspin Titans", "time": "01:00"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          //* This is the "LINE"
          padding: const EdgeInsets.only(
            left: 21,
            right: 21,
            top: 27,
            bottom: 21,
          ),
          child: Container(height: 2, color: AppColors.gray),
        ),

        const Text(
          "Fixtures",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 12),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(weeks.length, (index) {
              final isSelected = selectedWeek == index;
              return Padding(
                padding: const EdgeInsets.only(left: 12),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    backgroundColor: AppColors.leagueFixtureBackground,
                    // textStyle: TextStyle(color: AppColors.),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedWeek = index;
                    });
                  },
                  child: Text(
                    weeks[index],
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.white,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 16),

        // Fixtures list
        Expanded(
          child: ListView.builder(
            itemCount: fixtures.keys.length,
            itemBuilder: (context, dateIndex) {
              String date = fixtures.keys.elementAt(dateIndex);
              var matches = fixtures[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date header
                  Container(
                    width: double.infinity,
                    color: Colors.grey.shade800,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Text(
                      date,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  //* <--- Matches list --->
                  ...List.generate(matches.length, (i) {
                    var match = matches[i];
                    return Container(
                      color: i.isEven ? Colors.black : Colors.grey.shade900,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Home team
                          Expanded(
                            child: Text(
                              match["home"]!,
                              style: const TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Time
                          Row(
                            children: [
                              const Icon(
                                Icons.sports_soccer,
                                color: Colors.green,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                match["time"]!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          // Away team
                          Expanded(
                            child: Text(
                              match["away"]!,
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Favorite star
                          IconButton(
                            icon: const Icon(
                              Icons.star_border,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
