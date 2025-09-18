import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import '../../controller/home_controller.dart';

class NextMatchWidget extends StatelessWidget {
  const NextMatchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Next Match Summary",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Card(
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 21,
                vertical: 16,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// TEAM 1
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              "Team 1",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: controller.team1Players.map((player) {
                                //! <-- Change after API -->
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        player.imageUrl,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      player.name,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  //* Need to add image
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  controller
                                      .nextMatchDate
                                      .value, //! <-- Change after API -->
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// MIDDLE INFO
                      Expanded(
                        child: Column(
                          children: [
                            const Image(
                              //* Need to add image
                              image: AssetImage("assets/images/bat.png"),
                              width: 32,
                              color: Colors.black87,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller
                                  .nextMatchCourt
                                  .value, //! <-- Change after API -->
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// TEAM 2
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              "Team 2",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: controller.team2Players.map((player) {
                                //! <-- Change after API -->
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        player.imageUrl,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      player.name,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  //* Need to add image
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  controller
                                      .nextMatchTime
                                      .value, //! <-- Change after API -->
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      //! Navigate or show details
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.leagueFixtureBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "View Match Details",
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
