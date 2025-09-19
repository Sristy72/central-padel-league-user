// features/league/presentation/widgets/league_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:karlfive/features/league/presentation/screens/league_details_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/league_model.dart'; // or your model path

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
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  Get.to(LeagueDetailsScreen());
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        //! <-- Need to change to NetworkImage after API -->
                        league.backgroundImageUrl,
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.5),
                        BlendMode.darken,
                      ),
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
                          league.name,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Image.asset(
                        //! <-- Need to change to NetworkImage after API -->
                        league.logoImageUrl,
                        height: 28,
                        width: 28,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, color: AppColors.white);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 28),
      ],
    );
  }
}
