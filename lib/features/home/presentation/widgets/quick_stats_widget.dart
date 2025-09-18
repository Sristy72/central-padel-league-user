import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';

class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Stats",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            color: Colors.grey.shade900,
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
                  child: Text(
                    "Teams",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "GP",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "W",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "L",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Pts",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "+/-",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table Body
          ...controller.quickStats.asMap().entries.map((entry) {
            final index = entry.key;
            final stat = entry.value; // Map<String, dynamic>

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade800, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  // Rank + Team + Avatar
                  Expanded(
                    flex: 3,
                    child: Row(
                      /*************  ✨ Windsurf Command 🌟  *************/
                      children: [
                        Text(
                          "${index + 1}${_getOrdinal(index + 1)}  ",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const CircleAvatar(
                          radius: 14,
                          backgroundImage: AssetImage(
                            "assets/player1.png",
                          ), //! replace with stat["imageUrl"] if API provides
                        ),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            stat["name"] ?? "",
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${stat["GP"]}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${stat["W"]}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${stat["L"]}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${stat["Pts"]}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${stat["+/-"]}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }),

          // "See All" link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: Navigate to full stats page
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

  /// Helper for 1st, 2nd, 3rd, etc.
  String _getOrdinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return "th";
    }
    switch (number % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }
}
