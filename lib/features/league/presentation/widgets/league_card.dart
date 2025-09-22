// features/league/presentation/widgets/league_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/league/presentation/screens/league_details_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/league_model.dart';

class LeagueCard extends StatelessWidget {
  final League league;

  const LeagueCard({super.key, required this.league});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          width: screenWidth,
          height: 220,
          child: InkWell(
            onTap: () {
              Get.to(() => LeagueDetailsScreen(league: league));
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        // Safe null check: bannerImage may be null
                        (league.bannerImage?.isNotEmpty ?? false)
                            ? league.bannerImage!
                            : 'https://via.placeholder.com/400x200', // fallback
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.5),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            league.leagueName,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Image.network(
                          league.leagueLogo.isEmpty
                              ? 'https://via.placeholder.com/28'
                              : league.leagueLogo,
                          height: 28,
                          width: 28,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.error,
                              color: AppColors.white,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}
