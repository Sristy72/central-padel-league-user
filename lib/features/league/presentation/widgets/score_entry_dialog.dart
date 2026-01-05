import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:karlfive/core/theme/app_colors.dart';

import '../../data/league_repository.dart';
import '../../models/match_model.dart';

class ScoreEntryDialog extends StatefulWidget {
  final Match match;
  final LeagueRepository repository;
  final VoidCallback? onScoreUpdated;

  const ScoreEntryDialog({
    super.key,
    required this.match,
    required this.repository,
    this.onScoreUpdated,
  });

  @override
  State<ScoreEntryDialog> createState() => _ScoreEntryDialogState();
}

class _ScoreEntryDialogState extends State<ScoreEntryDialog> {
  late List<TextEditingController> teamOneControllers;
  late List<TextEditingController> teamTwoControllers;
  bool isMatchComplete = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each set (assuming max 5 sets for volleyball)
    teamOneControllers = List.generate(5, (index) {
      final initialValue = widget.match.sets.length > index
          ? widget.match.sets[index].teamOneGames.toString()
          : '';
      return TextEditingController(text: initialValue);
    });

    teamTwoControllers = List.generate(5, (index) {
      final initialValue = widget.match.sets.length > index
          ? widget.match.sets[index].teamTwoGames.toString()
          : '';
      return TextEditingController(text: initialValue);
    });
    
    // Check if match is already completed
    isMatchComplete = widget.match.matchStatus.toLowerCase() == 'completed';
  }

  @override
  void dispose() {
    for (var controller in teamOneControllers) {
      controller.dispose();
    }
    for (var controller in teamTwoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a1a),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!, width: 1),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with match info
                Text(
                  'Enter Match Score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Match date/time
                Text(
                  '${DateFormat.yMMMd().format(widget.match.matchDateTime)} - ${DateFormat.Hm().format(widget.match.matchDateTime)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),

                // Teams header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildTeamHeader(
                        widget.match.teamOne.logoPhotoUrl,
                        widget.match.teamOne.teamName,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildTeamHeader(
                        widget.match.teamTwo.logoPhotoUrl,
                        widget.match.teamTwo.teamName,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Score input fields
                ...List.generate(5, (setIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildSetScoreInput(
                      setIndex,
                      teamOneControllers[setIndex],
                      teamTwoControllers[setIndex],
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Match Complete Checkbox
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800]?.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey[700]!,
                      width: 1,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: isMatchComplete,
                    onChanged: (bool? value) {
                      setState(() {
                        isMatchComplete = value ?? false;
                      });
                    },
                    title: const Text(
                      'Is Match Complete?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    checkColor: Colors.white,
                    activeColor: const Color(0xFF2AAF08),
                    side: const BorderSide(color: Colors.grey, width: 1.5),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),

                const SizedBox(height: 24),

                // Confirm and Cancel buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _submitScore();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2AAF08),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamHeader(String logoPath, String teamName) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.leagueFieldBackground.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: (logoPath.startsWith('http') || logoPath.startsWith('https'))
              ? Image.network(
                  logoPath,
                  width: 50,
                  height: 50,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, color: Colors.white),
                )
              : Image.asset(logoPath, width: 50, height: 50),
        ),
        const SizedBox(height: 8),
        Text(
          teamName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSetScoreInput(
    int setIndex,
    TextEditingController teamOneCtrl,
    TextEditingController teamTwoCtrl,
  ) {
    return Row(
      children: [
        // Set label
        SizedBox(
          width: 50,
          child: Text(
            'Set ${setIndex + 1}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Team One score input
        Expanded(
          child: TextField(
            controller: teamOneCtrl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
              hintText: '0',
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            inputFormatters: [
              // Allow only numbers 0-25
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            maxLength: 2,
          ),
        ),
        const SizedBox(width: 12),
        // vs text
        const Text(
          'vs',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 12),
        // Team Two score input
        Expanded(
          child: TextField(
            controller: teamTwoCtrl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
              hintText: '0',
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            inputFormatters: [
              // Allow only numbers 0-25
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            maxLength: 2,
          ),
        ),
      ],
    );
  }

  void _submitScore() async {
    // Validate and collect scores
    List<SetScore> scores = [];
    for (int i = 0; i < 5; i++) {
      final teamOneScore = int.tryParse(teamOneControllers[i].text) ?? 0;
      final teamTwoScore = int.tryParse(teamTwoControllers[i].text) ?? 0;

      // Only add set if at least one team has a score
      if (teamOneScore > 0 || teamTwoScore > 0) {
        scores.add(SetScore(
          teamOneGames: teamOneScore,
          teamTwoGames: teamTwoScore,
        ));
      }
    }

    if (scores.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least one set score'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Prepare score data for API
      final scoreData = {
        'matchScore': {
          'sets': scores.map((s) => {
            'teamOneGames': s.teamOneGames,
            'teamTwoGames': s.teamTwoGames,
          }).toList(),
        },
        'matchStatus': isMatchComplete ? 'completed' : 'live',
        'matchDateTime': widget.match.matchDateTime.toIso8601String(),
      };

      // Call API to update match score
      final result = await widget.repository.updateMatchScore(
        matchId: widget.match.id,
        scoreData: scoreData,
      );

      // Store mounted state before async gap
      final mounted = context.mounted;

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (!mounted) return;

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update score: ${failure.message}'),
              backgroundColor: Colors.red,
            ),
          );
        },
        (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Match score updated successfully!'),
              backgroundColor: Color(0xFF2AAF08),
            ),
          );

          // Close the dialog and return the updated match
          Navigator.of(context).pop(success.data);

          // Call callback to refresh data if provided
          widget.onScoreUpdated?.call();
        },
      );
    } catch (e) {
      // Store mounted state before async gap
      final mounted = context.mounted;

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
