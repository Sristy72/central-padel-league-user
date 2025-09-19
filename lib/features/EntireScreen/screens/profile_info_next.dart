import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/EntireScreen/controller/Profile_info_next_controller.dart';
import 'package:karlfive/features/EntireScreen/controller/progress_page_controller.dart';
import 'package:karlfive/features/EntireScreen/controller/user_info_controller.dart';
import 'package:karlfive/features/EntireScreen/domain/repo/user_info_repo.dart';
import 'package:karlfive/features/EntireScreen/screens/profile_photo_upload_screen.dart';
import 'package:karlfive/features/EntireScreen/widgets/custom_container_widget.dart';

class PeofileInfoNextScreen extends StatelessWidget {
  const PeofileInfoNextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileInfoNextController());
    final progressController = Get.put(ProgressPageController());
    // final userInfoController = Get.put(UserInfoController());
    final userInfoController = Get.put(
      UserInfoController(Get.find<UserInfoRepo>()),
    );

    // ✅ Ensure progress starts at 0.25 when entering this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      progressController.updateProgress(0.25);
      // if (progressController.currentPage.value < 0.25) {
      //   progressController.updateProgress(0.25);
      // }
    });

    return AppScaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 138),

            // Progress bar
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

            // Gender selection card
            CustomContainerWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Are you male or female?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(() {
                    return Column(
                      children: controller.gender.map((gender) {
                        final isSelected =
                            controller.selectedgenders.value == gender;

                        return GestureDetector(
                          onTap: () {
                            controller.selectedgenders.value = gender;
                            userInfoController.selectedgenders.value = gender;

                            // ✅ When gender is selected → update to 0.50
                            progressController.updateProgress(0.50);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primaryBackground,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Center(
                                          child: Icon(
                                            Icons.circle,
                                            size: 12,
                                            color: Colors.black,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  gender,
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),

            const Spacer(),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      // Go back to previous step → keep progress at 0.25
                      progressController.updateProgress(0.25);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryText,
                      foregroundColor: AppColors.textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Back"),
                  ),

                  // Next button
                  ElevatedButton(
                    onPressed: () {
                      if (controller.selectedgenders.value.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please select your gender",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      } else {
                        // ✅ stay at 0.50 here, next screen will move it to 0.75
                        Get.to(
                          () => PhotoUploadScreen(),
                          transition: Transition.rightToLeft,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryText,
                      foregroundColor: AppColors.textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Next"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
