import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/league/presentation/widgets/standing_tab.dart';
import '../../controller/home_controller.dart';

class HomeStandingsScreen extends StatelessWidget {
  const HomeStandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final standings = controller.standingsList;

    return Scaffold(
      appBar: AppBar(title: const Text('Standings')),
      body: StandingTab(standingsData: standings),
    );
  }
}
