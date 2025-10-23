import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/EntireScreen/controller/playing_level_controller.dart';
import 'package:karlfive/features/EntireScreen/controller/progress_page_controller.dart';
import 'package:karlfive/features/EntireScreen/controller/user_info_controller.dart';
import 'package:karlfive/features/EntireScreen/domain/repo/user_info_repo.dart';

class PlayingLevelDropdown extends StatelessWidget {
  final controller = Get.put(PlayingLevelController());
  final progressController =
      Get.find<ProgressPageController>(); // 👈 get progress controller
  // final userInfoController = Get.put(UserInfoController());
  final userInfoController = Get.put(
    UserInfoController(Get.find<UserInfoRepo>()),
  );

  PlayingLevelDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButtonFormField<String>(
        initialValue: controller.selectedLevel.value.isEmpty
            ? null
            : controller.selectedLevel.value,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFD9D9D9),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
        ),
        hint: const Text(
          "Enter your playing level",
          style: TextStyle(color: AppColors.textColor, fontSize: 14),
        ),
        dropdownColor: const Color(0xFFD9D9D9),
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.textColor),
        style: const TextStyle(color: AppColors.textColor, fontSize: 14),
        items: controller.levels
            .map((level) => DropdownMenuItem(value: level, child: Text(level)))
            .toList(),
        onChanged: (value) {
          controller.selectedLevel.value = value ?? '';
          userInfoController.selectedLevel.value = value ?? '';

          if (controller.selectedLevel.value.isNotEmpty) {
            progressController.updateProgress(0.25); // 👈 update progress
          } else {
            progressController.updateProgress(0.0); // 👈 reset if empty
          }
        },
      );
    });
  }
}
