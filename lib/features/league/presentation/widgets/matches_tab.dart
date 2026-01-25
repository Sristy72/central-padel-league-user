import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart'; // Assuming AppColors is defined here
import '../../data/league_repository.dart';
import '../../models/match_model.dart'; // Import the new model
import 'score_entry_dialog.dart';

class MatchesTab extends StatelessWidget {
  final List<Match> matchesData;
  final String leagueType;
  final LeagueRepository repository;
  final VoidCallback? onMatchUpdated;

  const MatchesTab({
    super.key,
    required this.matchesData,
    this.leagueType = 'public',
    required this.repository,
    this.onMatchUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: matchesData.length,
      itemBuilder: (context, index) {
        final match = matchesData[index];
        return _MatchCard(
          match: match,
          leagueType: leagueType,
          repository: repository,
          onMatchUpdated: onMatchUpdated,
        );
      },
    );
  }
}

class _MatchCard extends StatelessWidget {
  final Match match;
  final String leagueType;
  final LeagueRepository repository;
  final VoidCallback? onMatchUpdated;

  const _MatchCard({
    required this.match,
    this.leagueType = 'public',
    required this.repository,
    this.onMatchUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.leagueBackgroundGrey,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with match info and edit icon (for private leagues)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Match info
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTeamDisplay(
                        match.teamOne.logoPhotoUrl,
                        match.teamOne.teamName,
                      ), //* <--- Match API here
                      Column(
                        children: [
                          Text(
                            DateFormat.yMMMd().format(match.matchDateTime),
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            DateFormat.Hm().format(match.matchDateTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _buildTeamDisplay(
                        match.teamTwo.logoPhotoUrl,
                        match.teamTwo.teamName,
                      ),
                    ],
                  ),
                ),
                // Edit icon for private leagues
                if (leagueType.toLowerCase() == 'private')
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: GestureDetector(
                      onTap: () {
                        _showScoreEntryDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2AAF08).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Color(0xFF2AAF08),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            // Details Section
            const Text(
              'Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildDetailRow(
              "assets/images/group_logo.png", //! <--- Whill change after API
              'League',
              match.leagueName,
            ),
            _buildDetailRow(
              "assets/images/wistle_icon.png",
              'Date',
              '${DateFormat.yMMMd().format(match.matchDateTime)} - ${DateFormat.Hm().format(match.matchDateTime)}',
            ),
            // _buildDetailRow(
            //   "assets/images/group_icon.png",
            //   'Arena',
            //   match.venueName,
            // ),
            _buildDetailRow(
              "assets/images/score_icon.png",
              'Score',
              '${match.formattedScore()} (${match.setsBreakdown()})',
            ),
            _buildDetailRow(
              "assets/images/winner_icon.png",
              'Winner',
              match.winnerTeam?.teamName ?? 'TBD',
            ),
          ],
        ),
      ),
    );
  }

  void _showScoreEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ScoreEntryDialog(
        match: match,
        repository: repository,
        onScoreUpdated: onMatchUpdated,
      ),
    );
  }

  Widget _buildTeamDisplay(String logoPath, String name) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            // radial fade so the box dissolves to transparent on all sides
            gradient: RadialGradient(
              center: const Alignment(0, 0),
              radius: 1.2,
              colors: [
                AppColors.leagueFieldBackground.withValues(alpha: 1.0),
                AppColors.leagueBackgroundGrey.withValues(alpha: 0.0),
              ],
              stops: const [0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: (logoPath.startsWith('http') || logoPath.startsWith('https'))
              ? Image.network(
                  logoPath,
                  width: 40,
                  height: 40,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, color: Colors.white),
                )
              : null,
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildDetailRow(String images, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Column(
            children: [Image(height: 18, width: 18, image: AssetImage(images))],
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$label:', //* <--- Label here
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
