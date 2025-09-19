import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import '../../models/team_model.dart';
import '../../../../core/theme/app_colors.dart';

class TeamsTab extends StatelessWidget {
  final List<Team> teamsData;

  const TeamsTab({super.key, required this.teamsData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Teams",
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: teamsData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final team = teamsData[index];
                    return _TeamGridItem(team: team);
                  },
                ),
                _buildSeeTableButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeeTableButton() {
    return OutlinedButton(
      onPressed: () {
        // Get.to(() => const YourNextScreen());
      },
      style: TextButton.styleFrom(
        backgroundColor: Color(0xFF353535), // Text color
        side: const BorderSide(width: 0), // Black border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text(
        'See Table >',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _TeamGridItem extends StatelessWidget {
  final Team team;

  const _TeamGridItem({required this.team});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.leagueFieldBackground,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(team.teamLogoPath),
            radius: 18.0,
          ),
          const SizedBox(height: 8),
          Text(
            team.teamName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
