import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_bottom_navbar.dart';
import 'package:karlfive/core/common/widgets/skeleton_loader.dart';
import 'package:karlfive/features/league/presentation/widgets/league_card.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../create_league/presentation/screens/create_league_screen.dart';
import '../../presentation/controllers/league_controller.dart';

class LeaguesScreen extends StatefulWidget {
  final String? leagueType; // 'public' or 'private'
  final int limit; // default 200

  const LeaguesScreen({
    super.key,
    this.leagueType,
    this.limit = 200,
  });

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  late final LeagueController controller;

  @override
  void initState() {
    super.initState();
    print('🟡 LeaguesScreen: initState called with leagueType=${widget.leagueType}, limit=${widget.limit}');
    controller = Get.find<LeagueController>();
    
    // Schedule fetch after the current frame completes to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🟡 LeaguesScreen: Post-frame callback - fetching data...');
      // Clear previous data to avoid showing stale data
      controller.leagues.clear();
      controller.errorMessage.value = '';
      // Fetch new data with the specified league type
      controller.fetchLeagues(type: widget.leagueType, limit: widget.limit);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('🟡 LeaguesScreen: build called with leagueType=${widget.leagueType}, leagues count=${controller.leagues.length}');

    return Scaffold(
      backgroundColor: AppColors.leagueBackgroundGrey,

      body: Obx(() {
        print('🟡 LeaguesScreen: Obx rebuild - isLoading=${controller.isLoading.value}, leagues=${controller.leagues.length}, error=${controller.errorMessage.value}');
        
        if (controller.isLoading.value) {
          return const SkeletonListItem(itemCount: 6);
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${controller.errorMessage}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.fetchLeagues(type: widget.leagueType, limit: widget.limit);
                  },
                  child: const Text('Retry'),
                ),
              ],
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
                    widget.leagueType == 'private' ? Icons.lock_outline : Icons.public_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.leagueType == 'private' 
                        ? 'No Private Leagues Yet'
                        : 'No Public Leagues Available',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.leagueType == 'private' 
                        ? 'Create your own private league or get invited to one to see them here.'
                        : 'No public leagues are currently available.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.leagueType == 'private') ...[
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to create league screen
                        Get.to(()=> const CreateLeagueScreen());
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create Private League'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: controller.leagues.length,
            itemBuilder: (context, index) {
              return LeagueCard(league: controller.leagues[index]);
            },
          );
        }
      }),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: widget.leagueType == 'public' ? 1 : 2,
      ),
    );
  }
}
