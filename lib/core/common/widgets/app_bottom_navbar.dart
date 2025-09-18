import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/home/presentation/screens/home_screen.dart';
import 'package:karlfive/features/league/presentation/screens/leagues_screen.dart';
import '../../../core/theme/app_colors.dart';

class AppBottomNavBar extends StatefulWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  Widget _buildNavItem({
    required int index,
    required String icon,
    required String activeIcon,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0D1B2A),
        border: Border(
          top: BorderSide(color: Colors.grey.shade900, width: 0.5),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            Get.to(() => const HomeScreen());
          } else if (index == 1) {
            Get.to(() => const LeaguesScreen());
          } else if (index == 2) {
            Get.to(
              () => const Scaffold(body: Center(child: Text("Notification"))),
            );
          } else if (index == 3) {
            Get.to(() => const Scaffold(body: Center(child: Text("Profile"))));
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,

        // hide default label & color handling
        selectedFontSize: 0,
        unselectedFontSize: 0,
        selectedItemColor: Colors.transparent,
        unselectedItemColor: Colors.transparent,

        items: [
          BottomNavigationBarItem(
            icon: _buildNavItem(
              index: 0,
              icon: "assets/images/nav_home_off.png",
              activeIcon: "assets/images/nav_home_on.png",
              label: "Home",
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(
              index: 1,
              icon: "assets/images/nav_match_off.png",
              activeIcon: "assets/images/nav_match_on.png",
              label: "Matches",
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(
              index: 2,
              icon: "assets/images/nav_noti_off.png",
              activeIcon: "assets/images/nav_noti_on.png",
              label: "Notification",
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(
              index: 3,
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
