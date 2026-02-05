import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/pre_home/screens/guest_leagues_screen.dart';
import 'package:karlfive/features/pre_home/screens/pre_home_screen.dart';
import 'package:karlfive/features/pre_home/widgets/guest_login_prompt_dialog.dart';

/// Bottom navigation bar for guest users
/// Shows login prompt when trying to access restricted features
class GuestAppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const GuestAppBottomNavBar({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    Widget buildNavItem({
      required int index,
      required String icon,
      required String activeIcon,
      required String label,
    }) {
      final bool isSelected = currentIndex == index;

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
          Image.asset(
            isSelected ? activeIcon : icon,
            width: 24,
            height: 24,
            color: isSelected ? AppColors.primaryGreen : Colors.white,
          ),

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
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0D1B2A),
        border: Border(
          top: BorderSide(color: Colors.grey.shade900, width: 0.5),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) async {
          // If the tab is already selected, do nothing
          if (currentIndex == index) return;

          if (index == 0) {
            // Home - allowed for guests
            Get.offAll(
              () => PreHomeScreen(),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 50),
            );
          } else if (index == 1) {
            // Main league (Public leagues) - allowed for guests
            Get.offAll(
              () => GuestLeaguesScreen(),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 50),
            );
          } else {
            // All other tabs require login
            GuestLoginPromptDialog.show(
              title: 'Login Required',
              message: 'Before see farther login',
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
          // 0 - Home
          BottomNavigationBarItem(
            icon: buildNavItem(
              index: 0,
              icon: "assets/images/nav_home_off.png",
              activeIcon: "assets/images/nav_home_on.png",
              label: "Home",
            ),
            label: '',
          ),

          // 1 - Main league (Public leagues - accessible to guests)
          BottomNavigationBarItem(
            icon: buildNavItem(
              index: 1,
              icon: "assets/icons/mainleauge.png",
              activeIcon: "assets/icons/mainleauge.png",
              label: "Public League",
            ),
            label: '',
          ),

          // 2 - Matches (requires login)
          BottomNavigationBarItem(
            icon: buildNavItem(
              index: 2,
              icon: "assets/images/nav_match_off.png",
              activeIcon: "assets/images/nav_match_on.png",
              label: "Matches",
            ),
            label: '',
          ),

          // 3 - Notification (requires login)
          BottomNavigationBarItem(
            icon: buildNavItem(
              index: 3,
              icon: "assets/images/nav_noti_off.png",
              activeIcon: "assets/images/nav_noti_on.png",
              label: "Notification",
            ),
            label: '',
          ),

          // 4 - Profile (requires login)
          BottomNavigationBarItem(
            icon: buildNavItem(
              index: 4,
              icon: "assets/images/nav_prof_off.png",
              activeIcon: "assets/images/nav_prof_on.png",
              label: "Profile",
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
