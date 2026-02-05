import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/skeleton_loader.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/pre_home/controllers/guest_league_controller.dart';
import 'package:karlfive/features/pre_home/widgets/guest_app_bottom_navbar.dart';
import 'package:karlfive/features/pre_home/widgets/guest_league_card.dart';

/// Public leagues screen for guest users (no authentication required)
/// Uses the /league/hh/all-league endpoint which doesn't require auth
class GuestLeaguesScreen extends StatelessWidget {
  GuestLeaguesScreen({super.key});

  final GuestLeagueController controller = Get.put(GuestLeagueController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.leagueBackgroundGrey,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Public Leagues',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Explore and join exciting padel leagues',
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 12,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshLeagues(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const SkeletonListItem(itemCount: 6);
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.gray,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading leagues',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.errorMessage.value,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => controller.refreshLeagues(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (controller.publicLeagues.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.public_outlined,
                      size: 64,
                      color: AppColors.gray,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Public Leagues Available',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back later for new public leagues',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.publicLeagues.length,
            itemBuilder: (context, index) {
              return GuestLeagueCard(
                league: controller.publicLeagues[index],
              );
            },
          );
        }),
      ),
      bottomNavigationBar: const GuestAppBottomNavBar(currentIndex: 1),
    );
  }
}
