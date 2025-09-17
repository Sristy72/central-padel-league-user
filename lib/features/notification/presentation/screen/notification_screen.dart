// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:karlfive/core/common/widgets/app_scaffold.dart';
// import 'package:karlfive/features/notification/presentation/controller/notification_controller.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   final NotificationController controller = Get.find<
//       NotificationController>(); // Assuming you're using GetX for state management
//   @override
// Widget build(BuildContext context) {
//     return AppScaffold(
//       appBar: AppBar(
//         title: const Text("Notification"),
//         actions: [
//           // TextButton(
//           //   onPressed: controller.markAllAsRead,
//           //   child: const Text(
//           //     "Mark As Read",
//           //     style: TextStyle(color: Colors.blue),
//           //   ),
//           // )
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator.adaptive());
//         }

//         if (controller.notifications.isEmpty) {
//           return const Center(
//             child: Text("No notifications yet"),
//           );
//         }

//         return ListView.separated(
//           padding: const EdgeInsets.all(12),
//           itemCount: controller.notifications.length,
//           itemBuilder: (context, index) {
//             final notification = controller.notifications[index];
//             return ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.grey[700],
//                 child: const Icon(Icons.notifications, color: Colors.white),
//               ),
//               title: Text(
//                 notification.title ?? "",
//                 style: TextStyle(
//                   fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
//                 ),
//               ),
//               subtitle: Text(notification.message ?? ""),
//               trailing: Text(
//                 notification.timeAgo ?? "",
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//             );
//           },
//           separatorBuilder: (context, index) => const Divider(),
//         );
//       }),
//     );
//   }
// }
