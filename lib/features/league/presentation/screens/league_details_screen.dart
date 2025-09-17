import 'package:flutter/material.dart';
import 'package:karlfive/features/league/presentation/widgets/custom_league_appbar.dart';
import 'package:karlfive/features/league/presentation/widgets/fixtures_tab.dart';
import 'package:karlfive/features/league/presentation/widgets/matches_tab.dart';
import 'package:karlfive/features/league/presentation/widgets/standing_tab.dart';

import '../../models/standing_model.dart';
import '../../models/team_model.dart';
import '../../models/match_model.dart';
import '../widgets/teams_tab.dart'; // Import the model class

class LeagueDetailsScreen extends StatefulWidget {
  const LeagueDetailsScreen({super.key});

  @override
  State<LeagueDetailsScreen> createState() => _LeagueDetailsScreenState();
}

class _LeagueDetailsScreenState extends State<LeagueDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['Standing', 'Matches', 'Teams', 'Fixtures'];

  //! <--- Dynamic data using the "Match" model --->
  final List<Match> _matchesData = [
    Match(
      team1LogoPath: 'assets/images/group_logo.png',
      team1Name: 'Smasher',
      team2LogoPath: 'assets/images/group_logo.png',
      team2Name: 'Dribblers',
      matchDate: '9th August 2025',
      matchTime: '18:30',
      leagueName: 'Premier League',
      arena: 'Allianz Arena',
      score: '6-4, 7-5',
      winner: 'Smasher',
    ),
    const Match(
      team1LogoPath: 'assets/images/group_logo.png',
      team1Name: 'Smasher',
      team2LogoPath: 'assets/images/group_logo.png',
      team2Name: 'Dribblers',
      matchDate: '10th August 2025',
      matchTime: '20:00',
      leagueName: 'Premier League',
      arena: 'Old Trafford',
      score: '3-2, 6-4',
      winner: 'Dribblers',
    ),
    const Match(
      team1LogoPath: 'assets/images/group_logo.png',
      team1Name: 'Smasher',
      team2LogoPath: 'assets/images/group_logo.png',
      team2Name: 'Dribblers',
      matchDate: '10th August 2025',
      matchTime: '20:00',
      leagueName: 'Premier League',
      arena: 'Old Trafford',
      score: '3-2, 6-4',
      winner: 'Dribblers',
    ),
  ];

  //! <--- Dynamic data using the "Team" model --->
  final List<Team> _teamsData = [
    const Team(
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Deathrader',
    ),
    const Team(
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Team B',
    ),
    const Team(
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Team C',
    ),
    const Team(
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Team D',
    ),
    const Team(
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Team E',
    ),
    const Team(
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Team F',
    ),
  ];

  //! <--- Dynamic data using the "Standing" model --->
  final List<Standing> _standingsData = [
    const Standing(
      pos: 1,
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Deathrader',
      p: 0,
      w: 0,
      d: 0,
      l: 0,
      plusMinus: 0,
      pts: 0,
    ),
    const Standing(
      pos: 2,
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Team B',
      p: 0,
      w: 0,
      d: 0,
      l: 0,
      plusMinus: 0,
      pts: 0,
    ),
    const Standing(
      pos: 3,
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Team C',
      p: 0,
      w: 0,
      d: 0,
      l: 0,
      plusMinus: 0,
      pts: 0,
    ),
    const Standing(
      pos: 1,
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Deathrader',
      p: 0,
      w: 0,
      d: 0,
      l: 0,
      plusMinus: 0,
      pts: 0,
    ),
    const Standing(
      pos: 2,
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Team B',
      p: 0,
      w: 0,
      d: 0,
      l: 0,
      plusMinus: 0,
      pts: 0,
    ),
    const Standing(
      pos: 3,
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Team C',
      p: 0,
      w: 0,
      d: 0,
      l: 0,
      plusMinus: 0,
      pts: 0,
    ),

    const Standing(
      pos: 1,
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Deathrader',
      p: 0,
      w: 0,
      d: 0,
      l: 0,
      plusMinus: 0,
      pts: 0,
    ),
    const Standing(
      pos: 2,
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Team B',
      p: 0,
      w: 0,
      d: 0,
      l: 0,
      plusMinus: 0,
      pts: 0,
    ),
    const Standing(
      pos: 3,
      teamLogoPath: 'assets/images/group_logo.png',
      teamName: 'Team C',
      p: 0,
      w: 0,
      d: 0,
      l: 0,
      plusMinus: 0,
      pts: 0,
    ),
  ];
  //! <-------- END -------->

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
        leagueName: 'Premier League',
        leagueLogoPath: 'assets/images/group_icon.png',
        backgroundImagePath: 'assets/images/example_bg.jpg',
        tabController: _tabController,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StandingTab(standingsData: _standingsData),
          MatchesTab(matchesData: _matchesData),
          TeamsTab(teamsData: _teamsData),
          FixturesTab(),
        ],
      ),
    );
  }
}
