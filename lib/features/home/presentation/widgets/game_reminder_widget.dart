import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';

import '../../controller/home_controller.dart';

class GameReminderWidget extends StatelessWidget {
  const GameReminderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final controller = Get.find<HomeController>();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width < 400 ? 12.0 : 24.0,
        vertical: 8.0,
      ),
      child: Obx(
        () => Container(
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            children: [
              // Left colored panel that stretches full height of the parent container
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  height: double.infinity,
                  width: screenWidth / 4,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: AppColors.primaryBackground,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _weekdayAbbrev(controller.nextMatchDate.value),
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: MediaQuery.of(context).size.width < 350
                                ? 10
                                : 12,
                          ),
                        ),
                        Text(
                          controller.nextMatchTime.value.isNotEmpty
                              ? controller.nextMatchTime.value
                              : 'TBA',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: MediaQuery.of(context).size.width < 350
                                ? 10
                                : 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Small gap between left panel and content
              const SizedBox(width: 8),

              // Title area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
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
            ],
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
