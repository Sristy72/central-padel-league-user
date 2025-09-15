import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';

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
    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Hello Mosh,",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                "Welcome to Padel app",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 20),

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
    );
  }
}
