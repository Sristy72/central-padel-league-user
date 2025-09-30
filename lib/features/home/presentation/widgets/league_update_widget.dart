import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';

class LeagueUpdateWidget extends StatelessWidget {
  const LeagueUpdateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width < 400 ? 12 : 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "League Update",
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width < 350 ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width < 350 ? 8 : 12),
            Text(
              "League Name: ${controller.leagueName.value}",
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width < 350 ? 12 : 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Season Dates: ${controller.seasonDates.value}",
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width < 350 ? 12 : 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Status: ${controller.status.value}",
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width < 350 ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
