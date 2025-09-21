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
              children: [
                // Day abbreviation
                Text(
                  _weekdayAbbrev(controller.nextMatchDate.value),
                  style: const TextStyle(color: AppColors.white, fontSize: 12),
                ),
                Text(
                  controller.nextMatchTime.value.isNotEmpty
                      ? controller.nextMatchTime.value
                      : 'TBD',
                  style: const TextStyle(color: AppColors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          title: Text(
            controller.gameReminder.value.isNotEmpty
                ? controller.gameReminder.value
                : '${controller.leagueName.value} - ${controller.status.value}',
            style: const TextStyle(
              color: AppColors.buttonText,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  String _weekdayAbbrev(String isoDate) {
    try {
      if (isoDate.isEmpty) return 'N/A';
      final d = DateTime.parse(isoDate);
      const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return names[d.weekday - 1];
    } catch (_) {
      return 'N/A';
    }
  }
}
