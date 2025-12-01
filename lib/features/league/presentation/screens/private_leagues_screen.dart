import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_bottom_navbar.dart';
import 'package:karlfive/core/common/widgets/skeleton_loader.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/league/presentation/controllers/league_controller.dart';
import 'package:karlfive/features/league/presentation/widgets/league_card.dart';

/// Private Leagues Screen with two filters:
/// 1. My League - Shows leagues created by the user (using main league API)
/// 2. Joined League - Shows private leagues the user has joined
class PrivateLeaguesScreen extends StatefulWidget {
  const PrivateLeaguesScreen({super.key});

  @override
  State<PrivateLeaguesScreen> createState() => _PrivateLeaguesScreenState();
}

class _PrivateLeaguesScreenState extends State<PrivateLeaguesScreen> {
  late final LeagueController controller;
  
  // Track which filter is active: 'my' or 'joined'
  final RxString _activeFilter = 'my'.obs;

  @override
  void initState() {
    super.initState();
    controller = Get.find<LeagueController>();
    
    // Initial load: My Leagues (default to user's created leagues)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMyLeagues();
    });
  }

  void _loadMyLeagues() {
    print('🟡 PrivateLeaguesScreen: Loading My Leagues (main league API)');
    controller.leagues.clear();
    controller.errorMessage.value = '';
    // Use same API as main league but without type filter to get all user's leagues
    controller.fetchLeagues(limit: 200);
  }

  void _loadJoinedLeagues() {
    print('🟡 PrivateLeaguesScreen: Loading Joined Leagues (private type)');
    controller.leagues.clear();
    controller.errorMessage.value = '';
    // Use private league type filter
    controller.fetchLeagues(type: 'private', limit: 200);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.leagueBackgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Private Leagues',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Obx(() => Row(
              children: [
                Expanded(
                  child: _buildFilterButton(
                    label: 'My League',
                    isActive: _activeFilter.value == 'my',
                    onTap: () {
                      _activeFilter.value = 'my';
                      _loadMyLeagues();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFilterButton(
                    label: 'Joined League',
                    isActive: _activeFilter.value == 'joined',
                    onTap: () {
                      _activeFilter.value = 'joined';
                      _loadJoinedLeagues();
                    },
                  ),
                ),
              ],
            )),
          ),
          
          // League list content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const SkeletonListItem(itemCount: 6);
              } else if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error Loading Leagues',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (_activeFilter.value == 'my') {
                              _loadMyLeagues();
                            } else {
                              _loadJoinedLeagues();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.notificationColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (controller.leagues.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _activeFilter.value == 'my'
                              ? Icons.sports_soccer_outlined
                              : Icons.group_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _activeFilter.value == 'my'
                              ? 'No Leagues Created Yet'
                              : 'No Joined Leagues',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _activeFilter.value == 'my'
                              ? 'Create your first league to see it here.'
                              : 'Join a private league to see it here.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_activeFilter.value == 'my') ...[
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Navigate to create league screen
                              Get.toNamed('/create-league');
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Create League'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.notificationColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: controller.leagues.length,
                  itemBuilder: (context, index) {
                    return LeagueCard(league: controller.leagues[index]);
                  },
                );
              }
            }),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.notificationColor : Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? AppColors.notificationColor
                : Colors.grey[700]!,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.primaryGreen : Colors.grey[400],
              fontSize: 15,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
