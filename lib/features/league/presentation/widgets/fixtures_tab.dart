import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:karlfive/core/theme/app_colors.dart';

import '../../../../core/network/services/auth_storage_service.dart';
import '../../../chat/data/chat_repository.dart';
import '../../../chat/presentation/screens/chat_message_screen.dart';
import '../../data/league_repository.dart';
import '../../models/match_model.dart';

class FixturesTab extends StatefulWidget {
  final List<Match> matches;
  final LeagueRepository? repository;
  final VoidCallback? onDataUpdated;

  const FixturesTab({
    super.key, 
    required this.matches,
    this.repository,
    this.onDataUpdated,
  });

  @override
  State<FixturesTab> createState() => _FixturesTabState();
}

class _FixturesTabState extends State<FixturesTab> {
  final ChatRepository _chatRepository = ChatRepository();
  final AuthStorageService _authStorageService = AuthStorageService();
  bool _isCreatingChat = false;

  //* Group matches by Date
  Map<String, List<Match>> _groupByDate(List<Match> input) {
    final map = <String, List<Match>>{};
    for (final m in input) {
      final key = DateFormat('yyyy-MM-dd').format(m.matchDateTime);
      map.putIfAbsent(key, () => []).add(m);
    }
    //* Keep the map sorted by date ascending
    final sortedKeys = map.keys.toList()..sort();
    return {for (var k in sortedKeys) k: map[k]!};
  }

  Future<void> _handleCreateChat(Match match) async {
    if (_isCreatingChat) return;

    setState(() => _isCreatingChat = true);

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Call API to create chat
      final result = await _chatRepository.createChat(
        sellerId: match.teamOne.id,
        userId: match.teamTwo.id,
      );

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      result.fold(
        (failure) {
          // Show error
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to create chat: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (chatModel) async {
          // Get current user ID from storage
          final currentUserId = await _authStorageService.getUserId();
          
          // Navigate to chat screen with created chat data
          if (mounted) {
            Get.to(
              () => ChatMessageScreen(
                participantName: match.teamTwo.teamName,
                participantImage: match.teamTwo.logoPhotoUrl,
                chatModel: chatModel,
                currentUserId: currentUserId ?? match.teamOne.id,
              ),
            );
          }
        },
      );
    } catch (e) {
      // Close loading dialog if still open
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreatingChat = false);
    }
  }

  void _showMatchEndedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This match is already ended. You cannot update the date anymore.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _showDatePickerDialog(Match match) async {
    final now = DateTime.now();
    final matchDate = match.matchDateTime;
    
    // Use the earlier date between now and matchDateTime as initialDate
    // This ensures initialDate is always within the valid range
    final initialDate = matchDate.isBefore(now) ? now : matchDate;
    
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020), // Allow selecting past dates for rescheduling
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)), // Allow up to 2 years ahead
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
      helpText: 'Select date you want to play on',
    );

    if (pickedDate != null) {
      // After date is selected, show time picker
      await _showTimePickerDialog(match, pickedDate);
    }
  }

  Future<void> _showTimePickerDialog(Match match, DateTime selectedDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(match.matchDateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      // Combine selected date and time
      final combinedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      
      // Now call the API with combined date and time
      await _handleUpdateMatchDate(match, combinedDateTime);
    }
  }

  Future<void> _handleUpdateMatchDate(Match match, DateTime newDate) async {
    if (widget.repository == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Repository not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Format date as ISO string
      final formattedDate = newDate.toIso8601String();

      // Call API to update match date
      final result = await widget.repository!.updateMatchDateTime(
        matchId: match.id,
        matchDateTime: formattedDate,
      );

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      result.fold(
        (failure) {
          // Show error
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update match date: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (updatedMatch) {
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Match date updated successfully'),
                backgroundColor: AppColors.primaryGreen,
              ),
            );

            // Trigger refresh if callback provided
            widget.onDataUpdated?.call();
          }
        },
      );
    } catch (e) {
      // Close loading dialog if still open
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.matches.isEmpty) {
      return const Center(
        child: Text(
          'No fixtures available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final grouped = _groupByDate(widget.matches);

    return MediaQuery.removePadding(
      context: context,
      removeLeft: true,
      removeRight: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 17,
              bottom: 11,
            ),
            child: Divider(color: AppColors.gray, height: 2, thickness: 2),
          ),

          const Text(
            'Fixtures',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListView.separated(
              itemCount: grouped.keys.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final dateKey = grouped.keys.elementAt(index);
                final items = grouped[dateKey]!;
                final displayDate = DateFormat(
                  'EEE, d MMM yyyy',
                ).format(DateTime.parse(dateKey));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Text(
                        displayDate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...List.generate(items.length, (i) {
                      final m = items[i];
                      return Container(
                        color: i.isEven ? Colors.black : Colors.grey.shade900,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: Row(
                          children: [
                            //* <--- Home team --->
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage:
                                        m.teamOne.logoPhotoUrl.startsWith(
                                          'http',
                                        )
                                        ? NetworkImage(m.teamOne.logoPhotoUrl)
                                        : const AssetImage(
                                                'assets/images/group_logo.png',
                                              )
                                              as ImageProvider,
                                    backgroundColor: Colors.transparent,
                                    onBackgroundImageError: (exception, stackTrace) {
                                      // Silently handle image loading errors
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      m.teamOne.teamName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Time and score
                            Column(
                              children: [
                                Text(
                                  DateFormat(
                                    'HH:mm',
                                  ).format(m.matchDateTime),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _isCreatingChat
                                      ? null
                                      : () => _handleCreateChat(m),
                                  icon: Icon(
                                    Icons.message,
                                    color: AppColors.notificationColor,
                                  ),
                                ),
                                if (widget.repository != null)

                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: m.sets.isNotEmpty
                                            ? () => _showMatchEndedSnackbar()
                                            : () => _showDatePickerDialog(m),
                                        icon: const Icon(
                                          Icons.edit_calendar,
                                          color: AppColors.primaryGreen,
                                        ),
                                        tooltip: m.sets.isNotEmpty
                                            ? 'Match already ended'
                                            : 'Edit match date',
                                      ),
                                      // IconButton(
                                      //   onPressed: () => _showDatePickerDialog(m),
                                      //   icon: const Icon(
                                      //     Icons.edit_calendar,
                                      //     color: AppColors.primaryGreen,
                                      //   ),
                                      //   tooltip: 'Edit match date',
                                      // ),
                                    ],
                                  ),
                                Text(
                                  m.formattedScore(),
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),

                            const SizedBox(width: 12),

                            //* <--- Away team --->
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      m.teamTwo.teamName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage:
                                        m.teamTwo.logoPhotoUrl.startsWith(
                                          'http',
                                        )
                                        ? NetworkImage(m.teamTwo.logoPhotoUrl)
                                        : const AssetImage(
                                                'assets/images/group_logo.png',
                                              )
                                              as ImageProvider,
                                    backgroundColor: Colors.transparent,
                                    onBackgroundImageError: (exception, stackTrace) {
                                      // Silently handle image loading errors
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
