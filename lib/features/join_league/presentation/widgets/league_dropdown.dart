import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/join_league_controller/join_league_controller.dart';

class LeagueDropdown extends StatelessWidget {
  final  controller = Get.find<JoinLeagueController>();
LeagueDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedLeague.value.isEmpty
            ? null
            : controller.selectedLeague.value,
        items: controller.leagues
            .map(
              (league) => DropdownMenuItem<String>(
                value: league.id,
                child: Text(
                  league.leagueName,
                  style: const TextStyle(color: AppColors.white),
                ),
              ),
            )
            .toList(),
        onChanged: (v) {
          controller.selectedLeague.value = v ?? ''; // save id
        },
        decoration: context.primaryInputDecoration.copyWith(
          hintText: 'Select League',
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textFieldTextiHint,
          ),
        ),
        dropdownColor: AppColors.textFieldBackground,
        style: const TextStyle(color: AppColors.white),
      ),
    );
  }
}
