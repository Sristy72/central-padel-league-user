import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/skeleton_loader.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/league/presentation/widgets/custom_league_appbar.dart';
import 'package:karlfive/features/league/presentation/widgets/fixtures_tab.dart';
import 'package:karlfive/features/league/presentation/widgets/matches_tab.dart';
import 'package:karlfive/features/league/presentation/widgets/standing_tab.dart';

import '../../data/league_repository.dart';
import '../../models/league_model.dart';
import '../controllers/league_details_controller.dart';
import '../widgets/teams_tab.dart'; // Import the model class

class LeagueDetailsScreen extends StatefulWidget {
  final League league;

  const LeagueDetailsScreen({super.key, required this.league});

  @override
  State<LeagueDetailsScreen> createState() => _LeagueDetailsScreenState();
}

class _LeagueDetailsScreenState extends State<LeagueDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['Standing', 'Matches', 'Teams', 'Fixtures'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    // initialize controller for this league
    Get.put(
      LeagueDetailsController(
        repository: Get.find(),
        leagueId: widget.league.id,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.leagueBackgroundGrey,
      appBar: CustomLeagueAppbar(
        leagueName: widget.league.leagueName,
        leagueLogoPath: widget.league.leagueLogo.isNotEmpty
            ? widget.league.leagueLogo
            : 'assets/images/group_icon.png',
        backgroundImagePath: (widget.league.bannerImage?.isNotEmpty ?? false)
            ? widget.league.bannerImage!
            : 'assets/images/example_bg.jpg',
        tabController: _tabController,
        league: widget.league, // Pass league to check type
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Obx(() {
            final ctrl = Get.find<LeagueDetailsController>();
            if (ctrl.isLoadingStandings.value)
              return const LeagueDetailsSkeletonLoader();
            if (ctrl.standings.isEmpty) {
              final msg = ctrl.standingsError.value.isNotEmpty
                  ? ctrl.standingsError.value
                  : 'No standings available';
              return Center(
                child: Text(msg, style: const TextStyle(color: Colors.white)),
              );
            }
            return StandingTab(standingsData: ctrl.standings.toList());
          }),
          // Matches tab now driven by LeagueDetailsController
          Obx(() {
            final ctrl = Get.find<LeagueDetailsController>();
            if (ctrl.isLoadingMatches.value)
              return const LeagueDetailsSkeletonLoader();
            if (ctrl.matches.isEmpty) {
              final msg = ctrl.matchesError.value.isNotEmpty
                  ? ctrl.matchesError.value
                  : 'No matches available';
              return Center(
                child: Text(msg, style: const TextStyle(color: Colors.white)),
              );
            }
            return MatchesTab(
              matchesData: ctrl.matches.toList(),
              leagueType: widget.league.leagueType,
              repository: Get.find<LeagueRepository>(),
              onMatchUpdated: () {
                // Refresh matches after score update
                ctrl.fetchMatches();
              },
            );
          }),
          TeamsTab(teamsData: widget.league.addTeams),
          // Fixtures tab driven by controller.matches (already filtered by leagueId)
          Obx(() {
            final ctrl = Get.find<LeagueDetailsController>();
            if (ctrl.isLoadingMatches.value)
              return const LeagueDetailsSkeletonLoader();
            if (ctrl.matches.isEmpty) {
              final msg = ctrl.matchesError.value.isNotEmpty
                  ? ctrl.matchesError.value
                  : 'No fixtures available';
              return Center(
                child: Text(msg, style: const TextStyle(color: Colors.white)),
              );
            }
            return FixturesTab(matches: ctrl.matches.toList());
          }),
        ],
      ),
    );
  }
}
