import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/league/presentation/widgets/fixtures_tab.dart';
import '../../controller/home_controller.dart';

class HomeFixturesScreen extends StatelessWidget {
  const HomeFixturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    //*<--- Use the stored leagueMatches --->
    final matches = controller.leagueMatches;

    return Scaffold(
      appBar: AppBar(title: const Text('Fixtures')),
      body: FixturesTab(matches: matches),
    );
  }
}
