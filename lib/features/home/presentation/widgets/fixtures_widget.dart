import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import '../../controller/home_controller.dart';
import '../screens/home_fixtures_screen.dart';

class FixturesWidget extends StatelessWidget {
  const FixturesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      // If no fixtures, show a small placeholder
      if (controller.groupedFixtures.isEmpty) {
        return const Center(
          child: Text(
            "No fixtures available",  
            style: TextStyle(color: Colors.white70),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width < 350 ? 12.0 : 24.0,
              right: MediaQuery.of(context).size.width < 350 ? 12.0 : 25.0,
              bottom: 12,
            ),
            child: const Text(
              "Fixtures",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //*<--- For each date group --->
          ...controller.groupedFixtures.entries.map((entry) {
            final date = entry.key;
            final matches = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date header
                Container(
                  width: double.infinity,
                  color: Colors.grey[900],
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: MediaQuery.of(context).size.width < 350
                        ? 8.0
                        : 12.0,
                  ),
                  child: Row(
                    children: [
                      const Image(
                        height: 24,
                        width: 24,
                        image: AssetImage('assets/images/group_logo.png'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          date,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //* <--- MATCHES LIST Per Date -->
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: matches.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, matchIndex) {
                    final fix = matches[matchIndex];

                    // Even rows black, odd rows gray (index starts at 0)
                    final bool isEvenRow = matchIndex % 2 == 0;
                    final Color bgColor = isEvenRow
                        ? AppColors.primaryBackground
                        : AppColors.gray;

                    // team images (use first player's image if available)
                    final String team1Img = (fix.team1.players.isNotEmpty)
                        ? fix.team1.players.first.imageUrl
                        : '';
                    final String team2Img = (fix.team2.players.isNotEmpty)
                        ? fix.team2.players.first.imageUrl
                        : '';

                    return Container(
                      color: bgColor,
                      padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: MediaQuery.of(context).size.width < 350
                            ? 8.0
                            : 12.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //* Team 1 (logo + name)
                          Expanded(
                            flex: MediaQuery.of(context).size.width < 400
                                ? 3
                                : 4,
                            child: Row(
                              children: [
                                ClipOval(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width < 350
                                        ? 28
                                        : 36,
                                    height:
                                        MediaQuery.of(context).size.width < 350
                                        ? 28
                                        : 36,
                                    child: team1Img.isNotEmpty
                                        ? Image.network(
                                            team1Img,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(
                                                  Icons.sports,
                                                  color: Colors.white70,
                                                ),
                                          )
                                        : const Icon(
                                            Icons.sports,
                                            color: Colors.white70,
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width < 350
                                      ? 4
                                      : 8,
                                ),

                                // Team name — flexible to avoid overflow
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      fix.team1.teamName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width <
                                                350
                                            ? 12
                                            : 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            flex: MediaQuery.of(context).size.width < 400
                                ? 2
                                : 3,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    fix.time,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                              350
                                          ? 10
                                          : 12,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width < 350
                                      ? 2
                                      : 4,
                                ),
                                Text(
                                  "VS",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize:
                                        MediaQuery.of(context).size.width < 350
                                        ? 10
                                        : 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //* <--- Team 2 (name + logo) and star --->
                          Expanded(
                            flex: MediaQuery.of(context).size.width < 400
                                ? 4
                                : 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Team name aligned to right
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      fix.team2.teamName,
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width <
                                                350
                                            ? 12
                                            : 14,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width < 350
                                      ? 4
                                      : 10,
                                ),

                                ClipOval(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width < 350
                                        ? 28
                                        : 36,
                                    height:
                                        MediaQuery.of(context).size.width < 350
                                        ? 28
                                        : 36,
                                    child: team2Img.isNotEmpty
                                        ? Image.network(
                                            team2Img,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(
                                                  Icons.sports,
                                                  color: Colors.white70,
                                                ),
                                          )
                                        : const Icon(
                                            Icons.sports,
                                            color: Colors.white70,
                                          ),
                                  ),
                                ),

                                SizedBox(
                                  width: MediaQuery.of(context).size.width < 350
                                      ? 2
                                      : 4,
                                ),

                                //! Star Icon Here - made responsive
                                SizedBox(
                                  width: MediaQuery.of(context).size.width < 350
                                      ? 32
                                      : 40,
                                  height:
                                      MediaQuery.of(context).size.width < 350
                                      ? 32
                                      : 40,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Image(
                                      height:
                                          MediaQuery.of(context).size.width <
                                              350
                                          ? 14
                                          : 18,
                                      width:
                                          MediaQuery.of(context).size.width <
                                              350
                                          ? 14
                                          : 18,
                                      image: const AssetImage(
                                        "assets/images/star_icon_off.png",
                                      ),
                                    ),
                                    onPressed:
                                        () {}, //TODO: Add favorite logic here
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Get.to(() => const HomeFixturesScreen());
              },
              child: const Text(
                "See All",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
        ],
      );
    });
  }
}
