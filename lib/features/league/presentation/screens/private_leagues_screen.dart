import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_bottom_navbar.dart';
import 'package:karlfive/core/common/widgets/skeleton_loader.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/league/presentation/controllers/league_controller.dart';
import 'package:karlfive/features/league/presentation/widgets/league_card.dart';

/// Private Leagues Screen with two filters:
/// 1. My League - Shows leagues created by the user (using leagueType='my')
/// 2. Joined League - Shows private leagues the user has joined (using leagueType='private')
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
    print('🟡 PrivateLeaguesScreen: Loading My Leagues (leagueType=my)');
    controller.leagues.clear();
    controller.errorMessage.value = '';
    // Use 'my' filter which maps to 'me' in API
    controller.fetchLeagues(type: 'my', limit: 200);
  }

  void _loadJoinedLeagues() {
    print('🟡 PrivateLeaguesScreen: Loading Joined Leagues (leagueType=private)');
    controller.leagues.clear();
    controller.errorMessage.value = '';
    // Use 'private' filter for joined leagues
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

          // Content area
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: SkeletonListItem(),
                );
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_activeFilter.value == 'my') {
                            _loadMyLeagues();
                          } else {
                            _loadJoinedLeagues();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                        ),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (controller.leagues.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _activeFilter.value == 'my'
                            ? Icons.sports_volleyball
                            : Icons.group_add,
                        color: Colors.grey[600],
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _activeFilter.value == 'my'
                            ? 'Create your first league to see it here.'
                            : 'You haven\'t joined any private leagues yet.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      if (_activeFilter.value == 'my')
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Navigate to create league screen
                              Get.toNamed('/create-league');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2AAF08),
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('Create League'),
                          ),
                        ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.leagues.length,
                itemBuilder: (context, index) {
                  final league = controller.leagues[index];
                  return LeagueCard(league: league);
                },
              );
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF2AAF08)
              : Colors.grey[800],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
