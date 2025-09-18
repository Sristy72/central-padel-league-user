import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/join_league_controller/join_league_controller.dart';

class LeagueDropdown extends StatelessWidget {
  final JoinLeagueController controller;
  const LeagueDropdown({required this.controller});

  @override
  Widget build(BuildContext context) {
    final leagues = <String>['Premier', 'Challenger', 'Amateur'];
    return Obx(
      () => DropdownButtonFormField<String>(
        initialValue: controller.selectedLeague.value.isEmpty
            ? null
            : controller.selectedLeague.value,
        items: leagues
            .map(
              (e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e, style: const TextStyle(color: AppColors.white)),
              ),
            )
            .toList(),
        onChanged: (v) => controller.selectedLeague.value = v ?? '',
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
