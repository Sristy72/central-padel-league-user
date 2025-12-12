import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/home/presentation/screens/home_screen.dart';
import 'package:karlfive/features/league/presentation/screens/leagues_screen.dart';
import 'package:karlfive/features/league/presentation/screens/private_leagues_screen.dart';
import 'package:karlfive/features/notification/presentation/screen/notification_dummy_screen.dart';
import 'package:karlfive/features/team_members_profile/domain/repo/user_profile_repo.dart';
import 'package:karlfive/features/team_members_profile/presentation/controllers/profile_controller.dart';
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
  
  const AppBottomNavBar({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller if not already initialized
    final BottomNavController controller = Get.put(BottomNavController());
    
    // Update controller's index to match the current screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.currentIndex.value != currentIndex) {
        controller.currentIndex.value = currentIndex;
      }
    });

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
          onTap: (index) async {
            // If the tab is already selected, do nothing
            if (controller.currentIndex.value == index) return;

            // Update the local index state
            controller.changeIndex(index);

            if (index == 0) {
              // Home - Clear navigation stack and go to home
              Get.offAll(
                    () => const HomeScreen(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 50),
              );
            } else if (index == 1) {
              // Main league - show public leagues - Clear navigation stack
              Get.offAll(
                    () => const LeaguesScreen(
                      leagueType: 'public',
                      limit: 200,
                    ),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 50),
              );
            } else if (index == 2) {
              // Matches - show private leagues screen with filters - Clear navigation stack
              Get.offAll(
                    () => const PrivateLeaguesScreen(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 50),
              );
            } else if (index == 3) {
              // Notification - Clear navigation stack
              Get.offAll(
                    () => NotificationScreen(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 50),
              );
            } else if (index == 4) {
              // Profile: Navigate immediately - profile screen will load its own data
              try {
                // Ensure ProfileController and its repo are registered
                if (!Get.isRegistered<ProfileController>()) {
                  final repo = Get.find<UserProfileRepo>();
                  Get.put(ProfileController(repository: repo));
                }

                final profileController = Get.find<ProfileController>();

                // Use cached profile data if available (don't wait for API)
                final apiProfile = profileController.profile.value;
                final memberToShow = apiProfile != null
                    ? TeamMemberModel(
                        id: apiProfile.id ?? '',
                        name: apiProfile.name ?? '',
                        role: apiProfile.role ?? '',
                        imageUrl: apiProfile.profileImage ?? '',
                        matches: 0,
                        level: 0,
                        firstName: apiProfile.name?.split(' ').first ?? '',
                        lastName: apiProfile.name?.contains(' ') == true ? apiProfile.name!.split(' ').sublist(1).join(' ') : '',
                        email: apiProfile.email,
                        phone: apiProfile.phoneNumber ?? '',
                        birthday: apiProfile.createdAt?.toIso8601String() ?? '',
                        gender: apiProfile.gender ?? '',
                      )
                    : dummyMember;

                Get.offAll(
                      () => ProfileInfoScreen(member: memberToShow),
                  transition: Transition.fadeIn,
                  duration: const Duration(milliseconds: 50),
                );
              } catch (e) {
                // Fallback to dummy member if anything goes wrong
                Get.offAll(
                      () => ProfileInfoScreen(member: dummyMember),
                  transition: Transition.fadeIn,
                  duration: const Duration(milliseconds: 50),
                );
              }
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

            // 1 - Main league
            BottomNavigationBarItem(
              icon: buildNavItem(
                index: 1,
                icon: "assets/icons/mainleauge.png",
                activeIcon: "assets/icons/mainleauge.png",
                label: "Main league",
              ),
              label: '',
            ),

            // 2 - Matches
            BottomNavigationBarItem(
              icon: buildNavItem(
                index: 2,
                icon: "assets/images/nav_match_off.png",
                activeIcon: "assets/images/nav_match_on.png",
                label: "Matches",
              ),
              label: '',
            ),

            // 3 - Notification
            BottomNavigationBarItem(
              icon: buildNavItem(
                index: 3,
                icon: "assets/images/nav_noti_off.png",
                activeIcon: "assets/images/nav_noti_on.png",
                label: "Notification",
              ),
              label: '',
            ),

            // 4 - Profile
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
      ),
    );
  }
}
