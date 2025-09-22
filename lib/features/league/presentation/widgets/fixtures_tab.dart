import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import '../../models/match_model.dart';

class FixturesTab extends StatelessWidget {
  final List<Match> matches;

  const FixturesTab({super.key, required this.matches});

  //* Group matches by Date
  Map<String, List<Match>> _groupByDate(List<Match> input) {
    final map = <String, List<Match>>{};
    for (final m in input) {
      final key = DateFormat('yyyy-MM-dd').format(m.matchDateTime.toLocal());
      map.putIfAbsent(key, () => []).add(m);
    }
    //* Keep the map sorted by date ascending
    final sortedKeys = map.keys.toList()..sort();
    return {for (var k in sortedKeys) k: map[k]!};
  }

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return const Center(
        child: Text(
          'No fixtures available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final grouped = _groupByDate(matches);

    return MediaQuery.removePadding(
      context: context,
      removeLeft: true,
      removeRight: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 21,
              right: 21,
              top: 18,
              bottom: 12,
            ),
            child: Container(height: 2, color: AppColors.gray),
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
