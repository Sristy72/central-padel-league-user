import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../controller/join_league_controller/join_league_controller.dart';

class LeagueDropdown extends StatelessWidget {
  final controller = Get.find<JoinLeagueController>();
  
  LeagueDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Read-only league display (non-expandable)
        Obx(() {
          final currentSelection = controller.selectedLeague.value;
          final displayLeagues = controller.displayLeagues;
          
          // Find selected league for display
          String displayText = 'Select league via OTP';
          if (currentSelection.isNotEmpty && displayLeagues.isNotEmpty) {
            try {
              final selectedLeague = displayLeagues.firstWhere(
                (league) => league.id == currentSelection,
                orElse: () => displayLeagues.first,
              );
              displayText = selectedLeague.leagueName;
            } catch (e) {
              DPrint.log('Error finding selected league: $e');
            }
          }
          
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.textFieldBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.textFieldTextiHint,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      color: currentSelection.isEmpty 
                          ? AppColors.textFieldTextiHint 
                          : AppColors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  currentSelection.isEmpty 
                      ? Icons.lock_open_rounded
                      : Icons.check_circle_rounded,
                  color: currentSelection.isEmpty 
                      ? AppColors.textFieldTextiHint
                      : AppColors.primaryGreen,
                ),
              ],
            ),
          );
        }),
        
        const SizedBox(height: 12),
        
        // Single Button for Unified OTP Join
        Center(
          child: TextButton.icon(
            onPressed: () {
              try {
                controller.showUnifiedLeagueOtpDialog();
              } catch (e) {
                DPrint.log('Error showing OTP dialog: $e');
              }
            },
            icon: const Icon(Icons.key, color: AppColors.primaryGreen, size: 18),
            label: const Text(
              'Join League by OTP',
              style: TextStyle(color: AppColors.primaryGreen, fontSize: 13),
            ),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: AppColors.primaryGreen, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
