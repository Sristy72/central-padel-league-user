import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/constants/app_images.dart';
import 'package:karlfive/features/team_members_profile/presentation/screens/profile_contactus_screen.dart';
import 'package:karlfive/features/team_members_profile/presentation/screens/profile_report_screen.dart';

import '../../../../core/common/widgets/app_bottom_navbar.dart';
import '../../../../core/common/widgets/shimmer_widgets.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../EntireScreen/data/repo/user_info_repo_impl.dart';
import '../../../EntireScreen/domain/repo/user_info_repo.dart';
import '../../../auth/presentation/controller/auth_controller.dart';
import '../../../privacy_policy/presentation/screens/privacy_pilicy_screen.dart';
import '../../../team_details/domain/repo/team_repo.dart';
import '../../../team_details/presentation/controllers/team_controller.dart';
import '../../data/models/edit_profile_model.dart';
import '../../data/models/team_member_model.dart';
import '../../data/repo/contact_us_repo_impl.dart';
import '../../data/repo/report_repo_impl.dart';
import '../../domain/repo/contact_us_repo.dart';
import '../../domain/repo/report_repo.dart';
import '../controllers/contact_us_controller.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/report_controller.dart';
import 'edit_profile_info.dart';

// Helper function to show delete account dialog
void _showDeleteAccountDialog(BuildContext context) {
  final TextEditingController confirmController = TextEditingController();
  final RxBool isConfirmValid = false.obs;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Delete Account',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            const Text(
              'Type "confirm" to delete your account:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'confirm',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                isConfirmValid.value = value.toLowerCase() == 'confirm';
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              confirmController.dispose();
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: isConfirmValid.value
                  ? () async {
                      Navigator.of(dialogContext).pop();
                      confirmController.dispose();

                      // Show loading dialog
                      Get.dialog(
                        const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                        barrierDismissible: false,
                      );

                      // Call delete account API
                      final editProfileController =
                          Get.find<EditProfileController>();
                      final success = await editProfileController
                          .deleteAccount();

                      // Close loading dialog
                      Get.back();

                      if (success) {
                        // Logout and navigate to login screen
                        final authController = Get.find<AuthController>();
                        await authController.logout();
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isConfirmValid.value
                    ? Colors.red
                    : Colors.grey,
                disabledBackgroundColor: Colors.grey,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class ProfileInfoScreen extends StatelessWidget {
  final TeamMemberModel member;

  const ProfileInfoScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    // Ensure a TeamController exists — when navigating back from edit screen
    // the app bottom nav initializers may not have run, so create it lazily here.
    late final TeamController teamCtrl;
    if (Get.isRegistered<TeamController>()) {
      teamCtrl = Get.find<TeamController>();
    } else {
      // TeamRepo should be registered by setupRepository; use that repo instance
      // to construct the TeamController lazily for this screen only.
      teamCtrl = Get.put(TeamController(repo: Get.find<TeamRepo>()));
    }

    // If profile has a linked team id, fetch team data so TeamDetailsScreen is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final teamId = controller.profile.value?.clubAffiliation;
      if (teamId != null &&
          teamId.isNotEmpty &&
          teamCtrl.team.value == null &&
          !teamCtrl.isLoading.value) {
        teamCtrl.fetchTeam(teamId);
      }
    });

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
              // Get actual profile data from controller
              final p = controller.profile.value;

              // Parse name into first and last name
              String firstName = '';
              String lastName = '';
              if (p?.name?.isNotEmpty == true) {
                final parts = p!.name!.split(' ');
                firstName = parts.first;
                if (parts.length > 1) {
                  lastName = parts.sublist(1).join(' ');
                }
              } else {
                firstName = member.firstName;
                lastName = member.lastName;
              }

              // Get birthday from profile - convert from ISO datetime to display format (DD/MM/YYYY)
              String birthday = '';
              if (p?.birthday?.isNotEmpty == true) {
                final bdayStr = p!.birthday!;
                // Handle full ISO datetime format (2001-12-12T00:00:00.000Z)
                String datePart = bdayStr;
                if (bdayStr.contains('T')) {
                  datePart = bdayStr.split('T').first;
                }
                if (datePart.contains('-') && datePart.split('-').length == 3) {
                  final parts = datePart.split('-');
                  birthday = '${parts[2]}/${parts[1]}/${parts[0]}';
                } else {
                  birthday = bdayStr;
                }
              } else {
                birthday = member.birthday;
              }

              final editModel = EditProfileModel(
                firstName: firstName,
                lastName: lastName,
                email: p?.email ?? member.email,
                phone: p?.phoneNumber ?? member.phone,
                birthday: birthday,
                gender: p?.gender ?? member.gender,
                imageUrl: p?.profileImage ?? member.imageUrl,
              );

              // Navigate to edit screen and refresh profile when returning
              final apiClient = Get.find<ApiClient>();
              if (!Get.isRegistered<UserInfoRepo>()) {
                Get.put<UserInfoRepo>(UserInfoRepoImpl(apiClient: apiClient));
              }
              if (!Get.isRegistered<EditProfileController>()) {
                Get.put(
                  EditProfileController(
                    Get.find<UserInfoRepo>(),
                    Get.find<AuthStorageService>(),
                  ),
                );
              }
              Get.to(() => EditProfileInfoScreen(member: editModel))?.then((
                _,
              ) async {
                await controller.fetchProfile();
              });
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

      body: Obx(() {
        // Show shimmer loader while profile is loading
        if (controller.isLoading.value) {
          return const ProfileInfoShimmer();
        }

        // Show actual profile content when loaded
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Profile Image (from API if available)
              Obx(() {
                final p = controller.profile.value;
                final displayImage = p?.profileImage ?? '';
                return CircleAvatar(
                  radius: 50,
                  backgroundImage: displayImage.isNotEmpty
                      ? (displayImage.startsWith('http')
                            ? NetworkImage(displayImage)
                            : AssetImage(displayImage) as ImageProvider)
                      : const AssetImage(AppImages.avatarImage),
                );
              }),
              const SizedBox(height: 14),
              Obx(() {
                final p = controller.profile.value;
                final displayName = (p?.name?.isNotEmpty == true)
                    ? p!.name!
                    : 'user name';
                return Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                );
              }),

              // const SizedBox(height: 19),
              // // My Team
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Color(0xFFD9D9D9),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     onPressed: () {
              //       final teamId = controller.profile.value?.clubAffiliation;
              //       if (teamId != null && teamId.isNotEmpty) {
              //         Get.to(() => TeamDetailsScreen(teamId: teamId));
              //       } else {
              //         Get.snackbar('No team', 'No team associated with this account');
              //       }
              //     },
              //     child: const Text(
              //       style: TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.w400,
              //         color: Color(0xFF060606),
              //       ),
              //       "My team",
              //     ),
              //   ),
              // ),

              // const SizedBox(height: 36),
              // // Matches and Level
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     _buildStatBox("${member.matches}", "Matches"),
              //     const SizedBox(width: 21),
              //     _buildStatBox("${member.level}", "Level"),
              //   ],
              // ),
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     // Image.asset(
                        //     //   'assets/icons/profile_phone.png',
                        //     //   width: 11,
                        //     //   height: 11,
                        //     // ),
                        //     // const SizedBox(width: 14),
                        //     // const Text(
                        //     //   "Phone number",
                        //     //   style: TextStyle(
                        //     //     color: Colors.white,
                        //     //     fontWeight: FontWeight.w400,
                        //     //     fontSize: 16,
                        //     //   ),
                        //     // ),
                        //     // const Spacer(),
                        //   //   Obx(() {
                        //   //     final p = controller.profile.value;
                        //   //     return Text(
                        //   //       p?.phoneNumber ?? member.phone,
                        //   //       style: const TextStyle(color: Colors.white),
                        //   //     );
                        //   //   }),
                        //   // ],
                        // ),
                        // const SizedBox(height: 24),
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
                            Obx(() {
                              final p = controller.profile.value;
                              return Text(
                                p?.email ?? member.email,
                                style: const TextStyle(color: Colors.white),
                              );
                            }),
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
                            final apiClient = Get.find<ApiClient>();
                            if (!Get.isRegistered<ContactUsRepo>()) {
                              Get.put<ContactUsRepo>(
                                ContactUsRepoImpl(apiClient: apiClient),
                              );
                            }
                            if (!Get.isRegistered<ContactUsController>()) {
                              Get.put(
                                ContactUsController(Get.find<ContactUsRepo>()),
                              );
                            }

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
                            final apiClient = Get.find<ApiClient>();
                            if (!Get.isRegistered<ReportRepo>()) {
                              Get.put<ReportRepo>(
                                ReportRepoImpl(apiClient: apiClient),
                              );
                            }
                            if (!Get.isRegistered<ReportController>()) {
                              Get.put(ReportController(Get.find<ReportRepo>()));
                            }

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

              // Delete Account Button
              Card(
                elevation: 4,
                shadowColor: Colors.grey,
                child: GestureDetector(
                  onTap: () => _showDeleteAccountDialog(context),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 9),
                          const Text(
                            "Delete Account",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Logout Button
              Card(
                elevation: 4,
                shadowColor: Colors.grey,
                child: GestureDetector(
                  onTap: () => Get.find<AuthController>().logout(),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/icons/profile_Logout.png',
                            width: 15,
                            height: 15,
                          ),
                          const SizedBox(width: 9),
                          const Text(
                            "Log out",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
    );
  }
}
