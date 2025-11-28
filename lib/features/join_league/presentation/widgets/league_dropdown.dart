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
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            hint: const Text(
              'Select a public league to join',
              style: TextStyle(color: AppColors.textFieldTextiHint),
            ),
            initialValue: controller.selectedLeague.value.isEmpty
                ? null
                : controller.selectedLeague.value,
            items: controller.leagues
                .map(
                  (league) => DropdownMenuItem<String>(
                    value: league.id,
                    child: Text(
                      league.leagueName,
                      style: const TextStyle(color: AppColors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) {
                controller.updateSelectedLeague(v); // Use the proper method
              }
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
          
          const SizedBox(height: 12),
          
          // Join Private League Button
          Center(
            child: TextButton.icon(
              onPressed: () {
                controller.showPrivateLeagueOtpDialog();
              },
              icon: const Icon(Icons.lock, color: AppColors.primaryGreen, size: 18),
              label: const Text(
                'Join Private League',
                style: TextStyle(color: AppColors.primaryGreen, fontSize: 14),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AppColors.primaryGreen, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
