import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import '../../data/model/join_league_model.dart';
import '../controller/join_league_controller.dart';

class PlayerLevelDropdown extends StatelessWidget {
  const PlayerLevelDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JoinLeagueController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Player Levels".text14w500(color: AppColors.white),
        Gap.h8,
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: AppColors.gray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonFormField<PlayerLevel>(
              value: controller.selectedPlayerLevel.value,
              onChanged: controller.setPlayerLevel,
              items: controller.playerLevels.map((PlayerLevel level) {
                return DropdownMenuItem<PlayerLevel>(
                  value: level,
                  child: Text(
                    level.value,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              dropdownColor: AppColors.gray,
              style: TextStyle(color: Colors.white, fontSize: 14),
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade400),
            ),
          ),
        ),
      ],
    );
  }
}
