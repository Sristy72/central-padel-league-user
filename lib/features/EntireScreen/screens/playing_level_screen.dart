import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/features/EntireScreen/controller/playing_level_controller.dart';

import 'package:karlfive/features/EntireScreen/controller/progress_page_controller.dart';
import 'package:karlfive/features/EntireScreen/controller/user_info_controller.dart';
import 'package:karlfive/features/EntireScreen/domain/repo/user_info_repo.dart';
import 'package:karlfive/features/EntireScreen/screens/profile_info_next.dart';

import 'package:karlfive/features/EntireScreen/widgets/custom_container_widget.dart';
import 'package:karlfive/features/EntireScreen/widgets/drop_down_widget.dart';

class PlayingLevelScreen extends StatelessWidget {
  const PlayingLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlayingLevelController());
    final progressController = Get.put(ProgressPageController());
    // final userInfoController = Get.put(UserInfoController());
    final userInfoController = Get.put(
      UserInfoController(Get.find<UserInfoRepo>()),
    );

    return AppScaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 138),
            // Progress bar inside a container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Obx(() {
                return Container(
                  height: 7,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(46),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(46),
                    child: LinearProgressIndicator(
                      value: progressController.currentPage.value,
                      color: Colors.green,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),

            // Card with dropdown
            CustomContainerWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your playing level",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PlayingLevelDropdown(),
                ],
              ),
            ),

            const Spacer(),

            // Next button
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.selectedLevel.value.isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Please select your playing level",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else {
                    // update progress to 0.50 when moving to next screen
                    progressController.updateProgress(0.50);

                    // navigate to next step
                    Get.to(
                      () => PeofileInfoNextScreen(),
                      transition: Transition.rightToLeft,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Next"),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
