// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:karlfive/core/common/widgets/app_scaffold.dart';
// // import 'package:karlfive/core/theme/app_colors.dart';
// // import 'package:karlfive/features/notification/presentation/controller/notification_controller.dart';

// // class NotificationScreen extends StatefulWidget {
// //   const NotificationScreen({super.key});

// //   @override
// //   State<NotificationScreen> createState() => _NotificationScreenState();
// // }

// // class _NotificationScreenState extends State<NotificationScreen>
// //     with SingleTickerProviderStateMixin {
// //   final NotificationController _notificationController =
// //       Get.find<NotificationController>();

// //   @override
// //   void initState() {
// //     super.initState();
// //     // 👇 Call API once screen opens
// //     _notificationController.getNotifications("userId", "", "");
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AppScaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           "Notifications",
// //           style: TextStyle(
// //             color: AppColors.white,
// //             fontWeight: FontWeight.w600,
// //             fontSize: 20,
// //           ),
// //         ),
// //         backgroundColor: AppColors.black,
// //         actions: [
// //           TextButton(
// //             onPressed: _notificationController.markAllAsRead,
// //             child: const Text(
// //               "Mark All Read",
// //               style: TextStyle(color: AppColors.primaryGreen),
// //             ),
// //           ),
// //         ],
// //       ),
// //       body: Obx(() {
// //         if (_notificationController.isLoading.value) {
// //           return const Center(child: CircularProgressIndicator.adaptive());
// //         }

// //         if (_notificationController.notifications.isEmpty) {
// //           return const Center(
// //             child: Text(
// //               "No notifications yet",
// //               style: TextStyle(color: AppColors.rememberMeColor, fontSize: 14),
// //             ),
// //           );
// //         }

// //         return ListView.separated(
// //           padding: const EdgeInsets.all(16),
// //           itemCount: _notificationController.notifications.length,
// //           separatorBuilder: (context, index) => const SizedBox(height: 12),
// //           itemBuilder: (context, index) {
// //             final n = _notificationController.notifications[index];
// //             return Container(
// //               padding: const EdgeInsets.all(12),
// //               decoration: BoxDecoration(
// //                 color: n.isRead
// //                     ? AppColors.blackLight
// //                     : AppColors.primaryGreen.withOpacity(0.08),
// //                 borderRadius: BorderRadius.circular(12),
// //                 border: n.isRead
// //                     ? null
// //                     : Border.all(color: AppColors.primaryGreen, width: 1.5),
// //               ),
// //               child: Row(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   CircleAvatar(
// //                     backgroundColor: AppColors.prefixIconColor,
// //                     radius: 22,
// //                     child: const Icon(Icons.notifications, color: Colors.white),
// //                   ),
// //                   const SizedBox(width: 12),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           n.title ?? "Notification",
// //                           style: TextStyle(
// //                             color: AppColors.white,
// //                             fontWeight:
// //                                 n.isRead ? FontWeight.normal : FontWeight.bold,
// //                             fontSize: 16,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 6),
// //                         Text(
// //                           n.message ?? "",
// //                           style: const TextStyle(
// //                             color: AppColors.rememberMeColor,
// //                             fontSize: 14,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 6),
// //                         Text(
// //                           n.timeAgo ?? "",
// //                           style: const TextStyle(
// //                             color: Colors.grey,
// //                             fontSize: 12,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //         );
// //       }),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:karlfive/core/common/widgets/app_scaffold.dart';
// import 'package:karlfive/core/theme/app_colors.dart';
// import 'package:karlfive/features/notification/data/model/notification_model.dart';
// import 'package:karlfive/features/notification/presentation/controller/notification_controller.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen>
//     with SingleTickerProviderStateMixin {
//   // final NotificationController _notificationController =
//   //     Get.find<NotificationController>();
//    final NotificationController _notificationController =
//       Get.put(NotificationController());

//   @override
//   void initState() {
//     super.initState();
//     // Demo notifications for marking as read
//     _notificationController.notifications.value = [
//       NotificationModel(
//         id: "1",
//         title: "Welcome!",
//         message: "Thanks for joining our platform.",
//         isRead: false,
//         timeAgo: "2 min ago",
//       ),
//       NotificationModel(
//         id: "2",
//         title: "New Update",
//         message: "Version 2.0 is now available.",
//         isRead: false,
//         timeAgo: "10 min ago",
//       ),
//       NotificationModel(
//         id: "3",
//         title: "Reminder",
//         message: "Complete your profile for better experience.",
//         isRead: true,
//         timeAgo: "1 hour ago",
//       ),
//     ];
//   }

//   /// Mark a single notification as read (demo)
//   void _markAsRead(int index) {
//     final n = _notificationController.notifications[index];
//     if (!n.isRead) {
//       _notificationController.notifications[index] = n.copyWith(isRead: true);
//     }
//   }

//   /// Mark all notifications as read (demo)
//   void _markAllAsRead() {
//     _notificationController.notifications.value = _notificationController
//         .notifications
//         .map((n) => n.copyWith(isRead: true))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Notifications",
//           style: TextStyle(
//             color: AppColors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//         backgroundColor: AppColors.textColor,
//         actions: [
//           TextButton(
//             onPressed: _markAllAsRead,
//             child: const Text(
//               "Mark All Read",
//               style: TextStyle(color: AppColors.primaryGreen),
//             ),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         final notifications = _notificationController.notifications;
//         if (notifications.isEmpty) {
//           return const Center(
//             child: Text(
//               "No notifications yet",
//               style: TextStyle(color: AppColors.textColor, fontSize: 14),
//             ),
//           );
//         }

//         return ListView.separated(
//           padding: const EdgeInsets.all(16),
//           itemCount: notifications.length,
//           separatorBuilder: (context, index) => const SizedBox(height: 12),
//           itemBuilder: (context, index) {
//             final n = notifications[index];
//             return GestureDetector(
//               onTap: () =>
//                   _markAsRead(index), // Mark single notification as read
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: n.isRead
//                       ? AppColors.textColor
//                       : AppColors.primaryGreen.withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(12),
//                   border: n.isRead
//                       ? null
//                       : Border.all(color: AppColors.primaryGreen, width: 1.5),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: AppColors.textBoxColor,
//                       radius: 22,
//                       child: const Icon(
//                         Icons.notifications,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             n.title ?? "Notification",
//                             style: TextStyle(
//                               color: AppColors.white,
//                               fontWeight: n.isRead
//                                   ? FontWeight.normal
//                                   : FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             n.message ?? "",
//                             style: const TextStyle(
//                               color: AppColors.textBoxColor,
//                               fontSize: 14,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             n.timeAgo ?? "",
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
