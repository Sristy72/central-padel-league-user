import 'package:flutter/material.dart';
import 'package:karlfive/features/league/presentation/widgets/custom_league_appbar.dart';
import 'package:karlfive/features/league/presentation/widgets/fixtures_tab.dart';
import 'package:karlfive/features/league/presentation/widgets/matches_tab.dart';
import 'package:karlfive/features/league/presentation/widgets/standing_tab.dart';
import 'package:get/get.dart';
import '../controllers/league_details_controller.dart';

import '../../models/league_model.dart';
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

  //! <--- Dynamic data using the "Match" model --->
  // final List<Match> _matchesData = [
  //   Match(
  //     team1LogoPath: 'assets/images/group_logo.png',
  //     team1Name: 'Smasher',
  //     team2LogoPath: 'assets/images/group_logo.png',
  //     team2Name: 'Dribblers',
  //     matchDate: '9th August 2025',
  //     matchTime: '18:30',
  //     leagueName: 'Premier League',
  //     arena: 'Allianz Arena',
  //     score: '6-4, 7-5',
  //     winner: 'Smasher',
  //   ),
  //   const Match(
  //     team1LogoPath: 'assets/images/group_logo.png',
  //     team1Name: 'Smasher',
  //     team2LogoPath: 'assets/images/group_logo.png',
  //     team2Name: 'Dribblers',
  //     matchDate: '10th August 2025',
  //     matchTime: '20:00',
  //     leagueName: 'Premier League',
  //     arena: 'Old Trafford',
  //     score: '3-2, 6-4',
  //     winner: 'Dribblers',
  //   ),
  //   const Match(
  //     team1LogoPath: 'assets/images/group_logo.png',
  //     team1Name: 'Smasher',
  //     team2LogoPath: 'assets/images/group_logo.png',
  //     team2Name: 'Dribblers',
  //     matchDate: '10th August 2025',
  //     matchTime: '20:00',
  //     leagueName: 'Premier League',
  //     arena: 'Old Trafford',
  //     score: '3-2, 6-4',
  //     winner: 'Dribblers',
  //   ),
  // ];

  //! <--- Dynamic data using the "Team" model --->
  // final List<Team> _teamsData = [
  //   const Team(
  //     teamLogoPath: 'assets/images/group_logo.png',
  //     teamName: 'Deathrader',
  //   ),
  //   const Team(
  //     teamLogoPath: 'assets/images/group_logo.png',
  //     teamName: 'Team B',
  //   ),
  //   const Team(
  //     teamLogoPath: 'assets/images/group_logo.png',
  //     teamName: 'Team C',
  //   ),
  //   const Team(
  //     teamLogoPath: 'assets/images/group_logo.png',
  //     teamName: 'Team D',
  //   ),
  //   const Team(
  //     teamLogoPath: 'assets/images/group_logo.png',
  //     teamName: 'Team E',
  //   ),
  //   const Team(
  //     teamLogoPath: 'assets/images/group_logo.png',
  //     teamName: 'Team F',
  //   ),
  // ];

  // Standings will be provided by LeagueDetailsController at runtime

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
      appBar: CustomLeagueAppbar(
        leagueName: widget.league.leagueName,
        leagueLogoPath: widget.league.leagueLogo.isNotEmpty
            ? widget.league.leagueLogo
            : 'assets/images/group_icon.png',
        backgroundImagePath: (widget.league.bannerImage?.isNotEmpty ?? false)
            ? widget.league.bannerImage!
            : 'assets/images/example_bg.jpg',
        tabController: _tabController,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Obx(() {
            final ctrl = Get.find<LeagueDetailsController>();
            if (ctrl.isLoadingStandings.value)
              return const Center(child: CircularProgressIndicator());
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
              return const Center(child: CircularProgressIndicator());
            if (ctrl.matches.isEmpty) {
              final msg = ctrl.matchesError.value.isNotEmpty
                  ? ctrl.matchesError.value
                  : 'No matches available';
              return Center(
                child: Text(msg, style: const TextStyle(color: Colors.white)),
              );
            }
            return MatchesTab(matchesData: ctrl.matches.toList());
          }),
          TeamsTab(teamsData: widget.league.addTeams),
          // Fixtures tab driven by controller.matches (already filtered by leagueId)
          Obx(() {
            final ctrl = Get.find<LeagueDetailsController>();
            if (ctrl.isLoadingMatches.value)
              return const Center(child: CircularProgressIndicator());
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
