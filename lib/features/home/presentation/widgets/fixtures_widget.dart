import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';

class FixturesWidget extends StatelessWidget {
  const FixturesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fixtures",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),

          // Grouped fixtures by date
          ...controller.groupedFixtures.entries.map((entry) {
            final date = entry.key;
            final matches = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date header
                Container(
                  color: Colors.grey[900],
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        date,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Matches for this date
                ...matches.map((fix) {
                  return Container(
                    color: Colors.grey[850],
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Team 1 logo (first player's image for now)
                          Image.network(
                            fix.team1.players.isNotEmpty
                                ? fix.team1.players.first.imageUrl
                                : "",
                            height: 28,
                            width: 28,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.sports_tennis,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            fix.team1.teamName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      title: Center(
                        child: Text(
                          fix.time,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            fix.team2.teamName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Image.network(
                            fix.team2.players.isNotEmpty
                                ? fix.team2.players.first.imageUrl
                                : "",
                            height: 28,
                            width: 28,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.sports_tennis,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.star_border, color: Colors.white70),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            );
          }).toList(),

          // "See All" button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: navigate to full fixtures page
              },
              child: const Text(
                "See All",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
