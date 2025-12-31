import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/notification/presentation/screen/notification_dummy_screen.dart';


import '../../../../core/theme/app_colors.dart';

class CreateLeagueAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CreateLeagueAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.leagueBackgroundGrey,
      elevation: 0,
      automaticallyImplyLeading: true,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Hello,",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Welcome to Create League",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: () {
              Get.to(() => NotificationScreen());
            },
            child: Image.asset(
              "assets/icons/notification.png",
              width: 28,
              height: 28,
            ),
          ),
        ),
      ],
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(50),
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Row(
      //         spacing: 8.0,
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         children: [
      //           // Create League Button
      //           SizedBox(
      //             width: 103,
      //             height: 29,
      //             child: ElevatedButton(
      //               onPressed: () {},
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: Colors.white,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(6),
      //                 ),
      //                 padding: EdgeInsets.zero,
      //               ),
      //               child: const Text(
      //                 "Create League +",
      //                 style: TextStyle(
      //                   color: Colors.black,
      //                   fontSize: 12,
      //                   fontWeight: FontWeight.w500,
      //                 ),
      //               ),
      //             ),
      //           ),
      //           // Update Score Button
      //           SizedBox(
      //             width: 90,
      //             height: 29,
      //             child: ElevatedButton(
      //               onPressed: () {},
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: Colors.white,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(6),
      //                 ),
      //                 padding: EdgeInsets.zero,
      //               ),
      //               child: const Text(
      //                 "Update score",
      //                 style: TextStyle(
      //                   color: Colors.black38,
      //                   fontSize: 12,
      //                   fontWeight: FontWeight.w400,
      //                 ),
      //               ),
      //             ),
      //           ),
      //           // Send Announcements Button
      //           Expanded(
      //             child: SizedBox(
      //               width: 133,
      //               height: 29,
      //               child: ElevatedButton(
      //                 onPressed: () {},
      //                 style: ElevatedButton.styleFrom(
      //                   backgroundColor: Colors.white,
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(6),
      //                   ),
      //                   padding: EdgeInsets.zero,
      //                 ),
      //                 child: const Text(
      //                   "Send announcements",
      //                   style: TextStyle(
      //                     color: Colors.black38,
      //                     fontSize: 12,
      //                     fontWeight: FontWeight.w400,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}