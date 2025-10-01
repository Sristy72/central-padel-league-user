import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/league/models/match_model.dart';

class TeamFixturesWidget extends StatelessWidget {
  final List<Match> matches;
  final String? currentTeamId;

  const TeamFixturesWidget({
    super.key,
    required this.matches,
    this.currentTeamId,
  });

  Map<String, List<Match>> _groupByDate(List<Match> input) {
    final map = <String, List<Match>>{};
    for (final m in input) {
      final key = DateFormat('yyyy-MM-dd').format(m.matchDateTime.toLocal());
      map.putIfAbsent(key, () => []).add(m);
    }
    final sortedKeys = map.keys.toList()..sort();
    return {for (var k in sortedKeys) k: map[k]!};
  }

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return const Center(
        child: Text(
          'No fixtures available',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final grouped = _groupByDate(matches);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: grouped.keys.map((dateKey) {
        final items = grouped[dateKey]!;
        final monthYear = DateFormat(
          'MMMM yyyy',
        ).format(DateTime.parse(dateKey));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Month, Year heading (centered) - same background as screen
            Container(
              color: AppColors.leagueBackgroundGrey,
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Text(
                  monthYear,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // Each match under this month
            ...items.map((m) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.teamDetailsCardBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat(
                              'd MMM',
                            ).format(m.matchDateTime.toLocal()),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),

                        // League name center
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              m.leagueName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        // Star icon
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.star_border,
                              color: Colors.white70,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Match row: team1 (left), time/score (center), team2 (right)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.teamDetailsCardBackground,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    child: Row(
                      children: [
                        //* <--- Team 1 --->
                        Expanded(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage:
                                    m.teamOne.logoPhotoUrl.startsWith('http')
                                    ? NetworkImage(m.teamOne.logoPhotoUrl)
                                    : const AssetImage(
                                            'assets/images/group_logo.png',
                                          )
                                          as ImageProvider,
                                backgroundColor: Colors.transparent,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  m.teamOne.teamName,
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //* <--- time or score --->
                        SizedBox(
                          width: 90,
                          child: Column(
                            children: [
                              Text(
                                DateFormat(
                                  'hh:mm a',
                                ).format(m.matchDateTime.toLocal()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                m.formattedScore(),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),

                        //* <--- Team 2 --->
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  m.teamTwo.teamName,
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              const SizedBox(width: 8),
                              CircleAvatar(
                                radius: 16,
                                backgroundImage:
                                    m.teamTwo.logoPhotoUrl.startsWith('http')
                                    ? NetworkImage(m.teamTwo.logoPhotoUrl)
                                    : const AssetImage(
                                            'assets/images/group_logo.png',
                                          )
                                          as ImageProvider,
                                backgroundColor: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        );
      }).toList(),
    );
  }
}
