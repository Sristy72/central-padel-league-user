import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';

import '../../controller/home_controller.dart';

class GameReminderWidget extends StatelessWidget {
  const GameReminderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(
      () => Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: AppColors.primaryBackground,
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                //! <-- Need to change this dynamically -->
                Text(
                  "Sun",
                  style: TextStyle(color: AppColors.white, fontSize: 12),
                ),
                Text(
                  "08:00 AM",
                  style: TextStyle(color: AppColors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          title: Text(
            controller
                .gameReminder
                .value, //! <-- Whill change after API integration -->
            style: const TextStyle(
              color: AppColors.buttonText,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
