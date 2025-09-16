import 'package:flutter/material.dart';
import 'package:karlfive/features/league/presentation/widgets/custom_league_appbar.dart';
import 'package:karlfive/features/league/presentation/widgets/standing_tab.dart';

import '../../models/standing_model.dart'; // Import the model class

class LeagueDetailsScreen extends StatefulWidget {
  const LeagueDetailsScreen({super.key});

  @override
  State<LeagueDetailsScreen> createState() => _LeagueDetailsScreenState();
}

class _LeagueDetailsScreenState extends State<LeagueDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['Standing', 'Matches', 'Teams', 'Fixtures'];

  // Example dynamic data using the Standing model
  final List<Standing> _standingsData = [
    const Standing(
      pos: 1,
      teamLogoPath: 'assets/images/group_icon.png',
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
      teamLogoPath: 'assets/images/group_icon.png',
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
      teamLogoPath: 'assets/images/group_icon.png',
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
      teamLogoPath: 'assets/images/group_icon.png',
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
      teamLogoPath: 'assets/images/group_icon.png',
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
      teamLogoPath: 'assets/images/group_icon.png',
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
      teamLogoPath: 'assets/images/group_icon.png',
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
      teamLogoPath: 'assets/images/group_icon.png',
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
      teamLogoPath: 'assets/images/group_icon.png',
      teamName: 'Team C',
      p: 0,
      w: 0,
      d: 0,
      l: 0,
      plusMinus: 0,
      pts: 0,
    ),
  ];

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
          const Center(child: Text('Matches Tab Content')),
          const Center(child: Text('Teams Tab Content')),
          const Center(child: Text('Fixtures Tab Content')),
        ],
      ),
    );
  }
}
