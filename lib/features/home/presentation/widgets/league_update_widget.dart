import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';

class LeagueUpdateWidget extends StatelessWidget {
  const LeagueUpdateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("League Update",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            Text("League Name: ${controller.leagueName.value}",
                style: const TextStyle(color: Colors.white)),
            Text("Season Dates: ${controller.seasonDates.value}",
                style: const TextStyle(color: Colors.white)),
            Text("Status: ${controller.status.value}",
                style: const TextStyle(color: Colors.white)),
          ],
        ));
  }
}
