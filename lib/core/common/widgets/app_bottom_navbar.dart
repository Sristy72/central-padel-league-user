import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/home/presentation/screens/home_screen.dart';
import 'package:karlfive/features/league/presentation/screens/leagues_screen.dart';
import 'package:karlfive/features/notification/presentation/screen/notification_dummy_screen.dart';

import 'package:karlfive/features/team_members_profile/presentation/screens/profile_info_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/team_members_profile/data/models/team_member_model.dart';

// Create a GetX controller for navigation
class BottomNavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller if not already initialized
    final BottomNavController controller = Get.put(BottomNavController());
    controller.currentIndex.value = currentIndex;

    Widget buildNavItem({
      required int index,
      required String icon,
      required String activeIcon,
      required String label,
    }) {
      return Obx(() {
        final bool isSelected = controller.currentIndex.value == index;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Green line indicator
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 4),

            // Icon
            Image.asset(isSelected ? activeIcon : icon, width: 24, height: 24),

            const SizedBox(height: 4),

            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected ? AppColors.primaryGreen : AppColors.gray,
              ),
            ),
          ],
        );
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0D1B2A),
        border: Border(
          top: BorderSide(color: Colors.grey.shade900, width: 0.5),
        ),
      ),
      child: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            // If the tab is already selected, do nothing
            if (controller.currentIndex.value == index) return;

            // Update the local index state
            controller.changeIndex(index);

            if (index == 0) {
              Get.offAll(
                () => const HomeScreen(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 100),
              );
            } else if (index == 1) {
              Get.offAll(
                () => const LeaguesScreen(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 100),
              );
            } else if (index == 2) {
              Get.offAll(
                () => NotificationScreen(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 100),
              );
            } else if (index == 3) {
              Get.offAll(
                () => ProfileInfoScreen(member: dummyMember),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 100),
              );
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,

          selectedFontSize: 0,
          unselectedFontSize: 0,
          selectedItemColor: Colors.transparent,
          unselectedItemColor: Colors.transparent,

          items: [
            BottomNavigationBarItem(
              icon: buildNavItem(
                index: 0,
                icon: "assets/images/nav_home_off.png",
                activeIcon: "assets/images/nav_home_on.png",
                label: "Home",
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: buildNavItem(
                index: 1,
                icon: "assets/images/nav_match_off.png",
                activeIcon: "assets/images/nav_match_on.png",
                label: "Matches",
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: buildNavItem(
                index: 2,
                icon: "assets/images/nav_noti_off.png",
                activeIcon: "assets/images/nav_noti_on.png",
                label: "Notification",
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: buildNavItem(
                index: 3,
                icon: "assets/images/nav_prof_off.png",
                activeIcon: "assets/images/nav_prof_on.png",
                label: "Profile",
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
