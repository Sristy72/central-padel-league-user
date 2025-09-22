import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';
import '../screens/home_standings_screen.dart';

class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quick Stats",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),

            //* <--- Table Header --->
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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

            //! <--- Quick Stats --->
            ...controller.quickStats.asMap().entries.map((entry) {
              final index = entry.key;
              final stat = entry.value;
              final imageUrl = (stat["imageUrl"] ?? '').toString();

              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade800, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    //* <--- Rank + Team Members + Avatar --->
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Text(
                            "${index + 1}${_getOrdinal(index + 1)}  ",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Builder(
                            builder: (_) {
                              final controller = Get.find<HomeController>();
                              final teamName = (stat["name"] ?? '').toString();

                              List<Map<String, String>> players = [];
                              for (final lm in controller.leagueMatches) {
                                if (lm.teamOne.teamName == teamName) {
                                  final cap = lm.teamOne.captainName;
                                  final partner = lm.teamOne.partnerName;
                                  final logo = lm.teamOne.logoPhotoUrl;
                                  if (cap.isNotEmpty) {
                                    players.add({
                                      'name': cap,
                                      'imageUrl': logo,
                                    });
                                  }
                                  if (partner.isNotEmpty) {
                                    players.add({
                                      'name': partner,
                                      'imageUrl': logo,
                                    });
                                  }
                                  break;
                                }
                                if (lm.teamTwo.teamName == teamName) {
                                  final cap = lm.teamTwo.captainName;
                                  final partner = lm.teamTwo.partnerName;
                                  final logo = lm.teamTwo.logoPhotoUrl;
                                  if (cap.isNotEmpty) {
                                    players.add({
                                      'name': cap,
                                      'imageUrl': logo,
                                    });
                                  }
                                  if (partner.isNotEmpty) {
                                    players.add({
                                      'name': partner,
                                      'imageUrl': logo,
                                    });
                                  }
                                  break;
                                }
                              }

                              if (players.isNotEmpty) {
                                //* <--- Render up to two players inline. --->
                                final toShow = players.take(2).toList();
                                return Column(
                                  children: toShow.map((pl) {
                                    final playerName = pl['name'] ?? '';
                                    final playerImage = (pl['imageUrl'] ?? '')
                                        .toString();
                                    return Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.grey[800],
                                          backgroundImage:
                                              playerImage.isNotEmpty
                                              ? NetworkImage(playerImage)
                                              : null,
                                          child: playerImage.isEmpty
                                              ? const Icon(
                                                  Icons.person,
                                                  size: 14,
                                                  color: Colors.white70,
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 4),
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            playerName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                );
                              }

                              return Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundImage: imageUrl.isNotEmpty
                                        ? NetworkImage(imageUrl)
                                        : null,
                                    child: imageUrl.isEmpty
                                        ? const Icon(
                                            Icons.sports,
                                            size: 14,
                                            color: Colors.white70,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 110,
                                    child: Text(
                                      stat["name"] ?? "",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              );
                            },
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

            //* <--- "See All" link --->
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.to(() => const HomeStandingsScreen());
                },
                child: const Text(
                  "See All",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
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
