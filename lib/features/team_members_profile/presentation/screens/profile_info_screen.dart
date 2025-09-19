import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:karlfive/core/common/widgets/app_bottom_navbar.dart';
import 'package:karlfive/features/privacy_policy/presentation/screens/privacy_pilicy_screen.dart';
import 'package:karlfive/features/team_members_profile/presentation/screens/edit_profile_info.dart';
import 'package:karlfive/features/team_members_profile/presentation/screens/profile_contactus_screen.dart';
import 'package:karlfive/features/team_members_profile/presentation/screens/profile_report_screen.dart';
import '../../../auth/presentation/controller/auth_controller.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../models/edit_profile_model.dart';
import '../../models/team_member_model.dart';

class ProfileInfoScreen extends StatelessWidget {
  final TeamMemberModel member;

  const ProfileInfoScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              final editModel = EditProfileModel(
                firstName: member.firstName,
                lastName: member.lastName,
                email: member.email,
                phone: member.phone,
                birthday: member.birthday,
                gender: member.gender,
                imageUrl: member.imageUrl,
              );

              Get.to(EditProfileInfoScreen(member: editModel));
            },
            icon: Image.asset(
              'assets/icons/profile_Edit.png',
              width: 16,
              height: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(member.imageUrl),
            ),
            const SizedBox(height: 14),
            Text(
              member.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 19),
            // My Team
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF060606),
                  ),
                  "My team",
                ),
              ),
            ),

            const SizedBox(height: 36),
            // Matches and Level
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatBox("${member.matches}", "Matches"),
                const SizedBox(width: 21),
                _buildStatBox("${member.level}", "Level"),
              ],
            ),

            const SizedBox(height: 33),
            Card(
              elevation: 4,
              shadowColor: Colors.grey,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/icons/profile_phone.png',
                            width: 11,
                            height: 11,
                          ),
                          const SizedBox(width: 14),
                          const Text(
                            "Phone number",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '01712451235',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/icons/profile_mail.png',
                            width: 12,
                            height: 12,
                          ),
                          const SizedBox(width: 14),
                          const Text(
                            "Email",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'asbd@gmail.com',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shadowColor: Colors.grey,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/icons/profile_language.png',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Language",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'English',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shadowColor: Colors.grey,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          // dummy data for contactUs
                          final editProfile = EditProfileModel(
                            firstName: member.name.split(" ").first,
                            lastName: member.name.contains(" ")
                                ? member.name.split(" ").last
                                : "",
                            email: "test@gmail.com",
                            phone: "01700000000",
                            birthday: "2000-01-01",
                            gender: "Male",
                            imageUrl: member.imageUrl,
                          );
                          Get.to(
                            () => ProfileContactUsScreen(member: editProfile),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/icons/profile_contactus.png',
                              width: 11,
                              height: 11,
                            ),
                            const SizedBox(width: 14),
                            const Text(
                              "Contact Us",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Get.to(() => const PrivacypolicyScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/icons/profile_privacy_policy.png',
                              width: 11,
                              height: 11,
                            ),
                            const SizedBox(width: 14),
                            const Text(
                              "Privacy policy",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Get.to(() => const ProfileReportScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/icons/profile_report.png',
                              width: 11,
                              height: 11,
                            ),
                            const SizedBox(width: 14),
                            const Text(
                              "Report",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 27),
            Card(
              elevation: 4,
              shadowColor: Colors.grey,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 50,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: InkWell(
                      onTap: () {
                        // Get.offAll(() => const LoginScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/icons/profile_Logout.png',
                            width: 15,
                            height: 15,
                          ),
                          const SizedBox(width: 9),
                          GestureDetector(
                            onTap: () => Get.find<AuthController>().logout(),
                            child: const Text(
                              "Log out",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 3),
    );
  }

  // Stat Box
  Widget _buildStatBox(String value, String label) {
    return Container(
      width: 96,
      height: 51,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF2AAF08),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
