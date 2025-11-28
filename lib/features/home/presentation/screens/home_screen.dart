import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_bottom_navbar.dart';
import 'package:karlfive/core/common/widgets/skeleton_loader.dart';
import 'package:karlfive/features/home/presentation/widgets/custom_search_bar.dart';
import 'package:karlfive/features/home/presentation/widgets/search_results_widget.dart';
import 'package:karlfive/features/join_league/presentation/screens/form_screen/join_league_screen.dart';

import '../../../../core/common/constants/app_images.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../create_league/presentation/screens/create_league_screen.dart';
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
          centerTitle: false,
          backgroundColor: AppColors.leagueBackgroundGrey,
          elevation: 0,
          title: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // LEFT: greeting text
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() {
                          final name = controller.userName.value.isNotEmpty
                              ? controller.userName.value
                              : 'Guest';
                          return Text(
                            'Hello $name,',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          );
                        }),
                        const SizedBox(height: 4),
                        const Text(
                          "Welcome to Padel app",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),


                  // CENTER: circular responsive logo
                  Align(
                    alignment: const Alignment(0.17, 0),
                    child: SizedBox(
                      height: kToolbarHeight * 0.85,
                      width: kToolbarHeight * 0.85,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(1),
                        child: ClipOval(
                          child: Image.asset(
                            AppImages.homelogo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF3B3B3B),
                child: IconButton(
                  onPressed: () {
                    showMenu(
                      context: context,
                      position: const RelativeRect.fromLTRB(1000, 80, 16, 0),
                      color: const Color(0xFFD9D9D9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      items: [
                        PopupMenuItem(
                          child: const Text(
                            "Join League",
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            Future.delayed(Duration.zero, () {
                              Get.to(() => JoinLeagueScreen());
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: const Text(
                            "Create Your League",
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            Future.delayed(Duration.zero, () {
                              Get.to(() => CreateLeagueScreen());
                            });
                          },
                        ),
                      ],
                    );
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
                    return const HomeSkeletonLoader();
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
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}
