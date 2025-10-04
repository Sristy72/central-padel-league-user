import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_bottom_navbar.dart';
import 'package:karlfive/features/home/presentation/widgets/custom_search_bar.dart';
import 'package:karlfive/features/home/presentation/widgets/search_results_widget.dart';
import 'package:karlfive/features/join_league/presentation/screens/form_screen/join_league_screen.dart';

import '../../../../core/theme/app_colors.dart';
import '../../controller/home_controller.dart';
import '../widgets/fixtures_widget.dart';
import '../widgets/game_reminder_widget.dart';
import '../widgets/league_update_widget.dart';
import '../widgets/next_match_widget.dart';
import '../widgets/quick_stats_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use cached controller from DI - prevents recreation and data reloading
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.leagueBackgroundGrey,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final name = controller.userName.value.isNotEmpty
                    ? controller.userName.value
                    : 'Guest';
                return Text(
                  'Hello $name,',
                  style: const TextStyle(color: AppColors.white, fontSize: 18),
                );
              }),
              const SizedBox(height: 4),
              const Text(
                "Welcome to Padel app",
                style: TextStyle(color: AppColors.white, fontSize: 14),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                backgroundColor: Colors.grey[850],
                child: IconButton(
                  onPressed: () {
                    // TODO: button logic here
                    Get.to(() => JoinLeagueScreen());
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Container(
        color: AppColors.leagueBackgroundGrey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const CustomSearchBar(),
                const SizedBox(height: 15),

                // Show search results when searching, otherwise show regular content
                Obx(() {
                  if (controller.isSearching.value) {
                    return const SearchResultsWidget();
                  }

                  // Show skeleton loader while data is loading (first frame)
                  if (controller.shouldShowLoading) {
                    return _buildSkeletonLoader();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          "Game Reminder",
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      GameReminderWidget(),
                      SizedBox(height: 20),
                      LeagueUpdateWidget(),
                      SizedBox(height: 20),
                      NextMatchWidget(),
                      SizedBox(height: 20),
                      QuickStatsWidget(),
                      SizedBox(height: 20),
                      FixturesWidget(),
                    ],
                  );
                }),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 0),
    );
  }

  // Skeleton loader for fast initial render
  Widget _buildSkeletonLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _skeletonBox(height: 24, width: 150),
          const SizedBox(height: 12),
          _skeletonBox(height: 90, width: double.infinity),
          const SizedBox(height: 20),
          _skeletonBox(height: 120, width: double.infinity),
          const SizedBox(height: 20),
          _skeletonBox(height: 200, width: double.infinity),
          const SizedBox(height: 20),
          _skeletonBox(height: 100, width: double.infinity),
          const SizedBox(height: 20),
          _skeletonBox(height: 150, width: double.infinity),
        ],
      ),
    );
  }

  Widget _skeletonBox({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
