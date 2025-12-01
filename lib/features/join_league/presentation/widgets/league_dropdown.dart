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
        // Custom dropdown replacement with GestureDetector + Modal
        Obx(() {
          final availableLeagues = controller.displayLeagues;
          final currentSelection = controller.selectedLeague.value;
          
          // Find selected league for display
          String displayText = 'Select a public league to join';
          if (currentSelection.isNotEmpty && availableLeagues.isNotEmpty) {
            try {
              final selectedLeague = availableLeagues.firstWhere(
                (league) => league.id == currentSelection,
                orElse: () => availableLeagues.first,
              );
              displayText = selectedLeague.leagueName;
            } catch (e) {
              DPrint.log('Error finding selected league: $e');
            }
          }
          
          return GestureDetector(
            onTap: () => _showLeagueSelectionModal(context, availableLeagues),
            child: Container(
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
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textFieldTextiHint,
                  ),
                ],
              ),
            ),
          );
        }),
        
        const SizedBox(height: 12),
        
        // Join Private League Button
        Center(
          child: TextButton.icon(
            onPressed: () {
              try {
                controller.showPrivateLeagueOtpDialog();
              } catch (e) {
                DPrint.log('Error showing OTP dialog: $e');
              }
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
    );
  }

  void _showLeagueSelectionModal(BuildContext context, List<dynamic> leagues) {
    if (leagues.isEmpty) {
      Get.snackbar(
        'No Leagues Available',
        'No public leagues are currently available for joining.',
        backgroundColor: AppColors.textFieldBackground,
        colorText: AppColors.white,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.textFieldBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.textFieldTextiHint.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Select League',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              
              // League List
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: leagues.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final league = leagues[index];
                    final isSelected = controller.selectedLeague.value == league.id;
                    final leagueType = league.leagueType.toLowerCase();
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.primaryGreen.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected 
                              ? AppColors.primaryGreen
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          try {
                            controller.updateSelectedLeague(league.id);
                            Navigator.pop(context);
                          } catch (e) {
                            DPrint.log('Error selecting league: $e');
                          }
                        },
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                league.leagueName,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (leagueType == 'private')
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'PRIVATE',
                                  style: TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: AppColors.primaryGreen,
                                size: 20,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
