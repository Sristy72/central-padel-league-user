import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/notification/presentation/controller/notifi_dummy_controller.dart';

import '../../../../core/common/widgets/app_bottom_navbar.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Notification",
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(() {
                        int unreadCount = controller.notifications
                            .where((n) => n.isUnread)
                            .length;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.notificationColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: const TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => controller.markAllAsRead(),
                    child: const Text(
                      "Mark As Read",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            // Notification List
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 8),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: notification.isUnread
                            ? Colors.white
                            : Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade800,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey[400],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (notification.title.isNotEmpty)
                                  Text(
                                    notification.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: notification.isUnread
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                Text(
                                  notification.message,
                                  style: TextStyle(
                                    color: notification.isUnread
                                        ? Colors.black87
                                        : Colors.grey[400],
                                  ),
                                  softWrap: true, // allow multi-line
                                ),
                                Text(
                                  notification.timeAgo,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 2),
    );
  }
}
