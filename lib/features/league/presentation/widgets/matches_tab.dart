import 'package:flutter/material.dart';
import '../../models/match_model.dart'; // Import the new model
import '../../../../core/theme/app_colors.dart'; // Assuming AppColors is defined here
import '../../../../core/theme/app_colors.dart';

class MatchesTab extends StatelessWidget {
  final List<Match> matchesData;

  const MatchesTab({super.key, required this.matchesData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: matchesData.length,
      itemBuilder: (context, index) {
        final match = matchesData[index];
        return _MatchCard(match: match);
      },
    );
  }
}

class _MatchCard extends StatelessWidget {
  final Match match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black, // Dark background for the card
      margin: const EdgeInsets.only(bottom: 20),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Match Header: Teams vs Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTeamDisplay(match.team1LogoPath, match.team1Name),
                Column(
                  children: [
                    const Text(
                      'Today',
                      style: TextStyle(color: AppColors.white, fontSize: 12),
                    ),
                    Text(
                      match.matchTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _buildTeamDisplay(match.team2LogoPath, match.team2Name),
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
              Icons.sports_soccer,
              'Premier League',
              match.leagueName,
            ),
            _buildDetailRow(
              Icons.calendar_month,
              'Date',
              '${match.matchDate} - ${match.matchTime}',
            ),
            _buildDetailRow(Icons.location_on, 'Arena', match.arena),
            _buildDetailRow(Icons.scoreboard, 'Score', match.score),
            _buildDetailRow(Icons.emoji_events, 'Winner', match.winner),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamDisplay(String logoPath, String name) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                AppColors.gray, // A light grey background for the team logo box
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(logoPath, width: 40, height: 40),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
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
