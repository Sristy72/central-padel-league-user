import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../team_members_profile/data/models/team_member_model.dart';
import '../../../team_members_profile/presentation/screens/profile_info_screen.dart';
import '../../data/models/match_data.dart';
import '../../data/models/standing_row_data.dart';
import '../widgets/match_card_widget.dart';
import '../widgets/member_widget.dart';
import '../widgets/standing_table_widget.dart';
import '../controllers/team_controller.dart';

class TeamDetailsScreen extends StatefulWidget {
  final String? teamId;
  const TeamDetailsScreen({super.key, this.teamId});

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  List<StandingRowData> standingRows = [
    StandingRowData(
      pos: "9",
      team: "Deathradder",
      p: "0",
      w: "0",
      d: "0",
      l: "0",
      gd: "0",
      pts: "0",
      teamIcon: "assets/icons/team1.png",
    ),
    StandingRowData(
      pos: "10",
      team: "Deathradder",
      p: "0",
      w: "0",
      d: "0",
      l: "0",
      gd: "0",
      pts: "0",
      teamIcon: "assets/icons/team1.png",
    ),
    StandingRowData(
      pos: "11",
      team: "Smasher",
      p: "0",
      w: "0",
      d: "0",
      l: "0",
      gd: "0",
      pts: "0",
      teamIcon: "assets/icons/team2.png",
      highlight: true,
    ),
  ];

  List<MatchData> julyMatches = [
    MatchData(
      date: "12th July",
      team1: "Baseline Smashers",
      team2: "Topspin Titans",
    ),
    MatchData(
      date: "16th July",
      team1: "Baseline Smashers",
      team2: "Topspin Titans",
    ),
    MatchData(
      date: "22nd July",
      team1: "Baseline Smashers",
      team2: "Topspin Titans",
    ),
  ];

  List<MatchData> augustMatches = [
    MatchData(
      date: "12th Aug",
      team1: "Baseline Smashers",
      team2: "Topspin Titans",
    ),
    MatchData(
      date: "16th Aug",
      team1: "Baseline Smashers",
      team2: "Topspin Titans",
    ),
    MatchData(
      date: "22nd Aug",
      team1: "Baseline Smashers",
      team2: "Topspin Titans",
    ),
  ];

  void _loadMoreRows() {
    setState(() {
      standingRows.addAll([
        StandingRowData(
          pos: "12",
          team: "Deathradder",
          p: "0",
          w: "0",
          d: "0",
          l: "0",
          gd: "0",
          pts: "0",
          teamIcon: "assets/icons/team1.png",
        ),
        StandingRowData(
          pos: "13",
          team: "Deathradder",
          p: "0",
          w: "0",
          d: "0",
          l: "0",
          gd: "0",
          pts: "0",
          teamIcon: "assets/icons/team1.png",
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final teamCtrl = Get.find<TeamController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = widget.teamId;
      if (id != null && id.isNotEmpty && teamCtrl.team.value == null && !teamCtrl.isLoading.value) {
        teamCtrl.fetchTeam(id);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.to(ProfileInfoScreen(member: dummyMember));
          },
          icon: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(color: Colors.white12),
            child: Center(
              child: Image.asset(
                'assets/icons/X.png',
                width: 16,
                height: 16,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/teamDetails_appbar_background.jpg",
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Smasher",
                  style: TextStyle(
                    color: Color(0xFF2AAF08),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Image.asset(
                  "assets/icons/Layer_1.png",
                  width: 42,
                  height: 36,
                  color: Color(0xFF0E7DB4),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const Divider(color: Colors.white, thickness: 0, height: 1),

              // Team Members
              const Divider(color: Colors.white24, thickness: 1, height: 5),
              const SizedBox(height: 10),
              const Text(
                "Team Members",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildMember("assets/images/player1.png", "Henry Adam"),
                  const SizedBox(width: 13),
                  buildMember("assets/images/player2.png", "Mach David"),
                ],
              ),
              const SizedBox(height: 20),

              _buildMonthSection("July 2025"),
              const SizedBox(height: 17),
              for (var match in julyMatches)
                buildMatchCard(match, () {
                  setState(() {
                    match.isStarred = !match.isStarred;
                  });
                }),
              const SizedBox(height: 20),

              _buildMonthSection("August 2025"),
              const SizedBox(height: 17),
              for (var match in augustMatches)
                buildMatchCard(match, () {
                  setState(() {
                    match.isStarred = !match.isStarred;
                  });
                }),
              const SizedBox(height: 43),

              _buildMonthSection("Team Standing"),
              const SizedBox(height: 20),
              buildStandingTable(standingRows),
              const SizedBox(height: 20),

              Center(
                child: SizedBox(
                  width: 80,
                  height: 22,
                  child: ElevatedButton(
                    onPressed: _loadMoreRows,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF373737),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "More",
                        style: TextStyle(
                          color: Color(0xFF2AAF08),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSection(String month) {
    return Text(
      month,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
