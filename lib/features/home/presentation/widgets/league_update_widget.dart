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
              "Season Dates: ${_formatSeasonDates(controller.seasonDates.value)}",
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

  String _formatSeasonDates(String raw) {
    if (raw.isEmpty) return 'N/A';
    final parts = raw.split('-');

    if (parts.length >= 6) {
      try {
        final regex = RegExp(r"\d{4}-\d{2}-\d{2}");
        final matches = regex
            .allMatches(raw)
            .map((m) => m.group(0))
            .whereType<String>()
            .toList();
        if (matches.length >= 2) {
          return '${matches[0]} - ${matches[1]}';
        }
      } catch (_) {
        return raw;
      }
    }

    final regex = RegExp(r"\d{4}-\d{2}-\d{2}");
    final matches = regex
        .allMatches(raw)
        .map((m) => m.group(0))
        .whereType<String>()
        .toList();
    if (matches.isEmpty) return raw;
    if (matches.length == 1) return matches[0];
    return '${matches[0]} - ${matches[1]}';
  }
}
