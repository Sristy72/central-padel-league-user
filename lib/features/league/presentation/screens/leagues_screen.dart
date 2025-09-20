import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_bottom_navbar.dart';
import 'package:karlfive/features/league/presentation/widgets/league_card.dart';

import '../../presentation/controllers/league_controller.dart';

class LeaguesScreen extends StatelessWidget {
  const LeaguesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LeagueController controller = Get.find<LeagueController>();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text('Error: ${controller.errorMessage}'));
        } else if (controller.leagues.isEmpty) {
          return const Center(child: Text('No leagues available'));
        } else {
          return ListView.builder(
            itemCount: controller.leagues.length,
            itemBuilder: (context, index) {
              return LeagueCard(league: controller.leagues[index]);
            },
          );
        }
      }),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 1),
    );
  }
}
