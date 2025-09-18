import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_bottom_navbar.dart';
import 'package:karlfive/features/home/presentation/widgets/custom_search_bar.dart';
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
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Hello Mosh,",
                style: TextStyle(color: AppColors.white, fontSize: 18),
              ),
              SizedBox(height: 4),
              Text(
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 20),
                CustomSearchBar(),

                SizedBox(height: 15),
                Text(
                  "Game Reminder",
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 0),
    );
  }
}
