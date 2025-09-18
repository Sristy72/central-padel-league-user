import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/join_league_controller/join_league_controller.dart';

class PlayerLevelDropdown extends StatelessWidget {
  final  controller = Get.find<JoinLeagueController>();
   PlayerLevelDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<int>(
        initialValue: controller.selectedPlayerLevelId.value,
        items: controller.playerLevels.map((level) {
          final int id = level['id'] as int;
          final String label = level['label'] as String;
          final String? asset = level['asset'] as String?;
          return DropdownMenuItem<int>(
            value: id,
            child: Row(
              children: [
                if (asset != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.asset(asset, width: 20, height: 20),
                  )
                else
                  const SizedBox.shrink(),
                Text(label, style: const TextStyle(color: AppColors.white)),
              ],
            ),
          );
        }).toList(),
        onChanged: (v) => controller.selectedPlayerLevelId.value = v,
        decoration: context.primaryInputDecoration.copyWith(
          hintText: 'Player Levels',
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textFieldTextiHint,
          ),
        ),
        dropdownColor: AppColors.textFieldBackground,
        style: const TextStyle(color: AppColors.white),
        validator: (v) => v == null ? 'Please select player level' : null,
      ),
    );
  }
}
