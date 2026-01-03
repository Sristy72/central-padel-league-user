import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../models/league_model.dart';

class CustomLeagueAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String leagueName;
  final String leagueLogoPath;
  final String backgroundImagePath;
  final TabController tabController;
  final League? league; // Added to check league type

  const CustomLeagueAppbar({
    super.key,
    required this.leagueName,
    required this.leagueLogoPath,
    required this.backgroundImagePath,
    required this.tabController,
    this.league,
  });

  @override
  Size get preferredSize => const Size.fromHeight(200.0);

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ['Table', 'Matches', 'Teams', 'Fixtures'];

    return AppBar(
      elevation: 0.0,
      toolbarHeight: 200,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        children: [
          Positioned.fill(
            child:
                backgroundImagePath.startsWith('http') ||
                    backgroundImagePath.startsWith('https')
                ? Image.network(
                    backgroundImagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/example_bg.jpg',
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(backgroundImagePath, fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withValues(alpha: 0.5)),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 26,
                  right: 26,
                  bottom: 23,
                  top: 56,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.white.withValues(alpha: 0.3),
                        ),
                        child: const Image(
                          height: 22,
                          width: 22,
                          image: AssetImage("assets/images/cross_icon.png"),
                          color: AppColors.white,
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    //! Favorite icon
                    Row(
                      children: [
                        // Show favorite icon for all leagues (public, private, me)
                        IconButton(
                          icon: const Image(
                            height: 22,
                            width: 22,
                            image: AssetImage("assets/images/star_icon_off.png"),
                          ),
                          onPressed: () {}, // TODO: Add favorite logic here
                        ),
                        // Only show share icon for private or "me" leagues
                        if (league != null && (league!.leagueType == 'private' || league!.leagueType == 'me'))
                          IconButton(
                            icon: const Image(
                              height: 22,
                              width: 22,
                              image: AssetImage("assets/icons/share.png"),
                            ),
                            onPressed: () {
                              if (league?.leagueCode != null) {
                                Get.dialog(
                                  Dialog(
                                    backgroundColor: Colors.black.withValues(alpha: 0.9),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Share League Code",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => Get.back(),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  league!.leagueCode!,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Clipboard.setData(
                                                      ClipboardData(
                                                          text: league!.leagueCode!),
                                                    );
                                                    Get.back();
                                                    Get.snackbar(
                                                      "Success",
                                                      "League code copied to clipboard",
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      backgroundColor:
                                                          AppColors.primaryGreen,
                                                      colorText: Colors.white,
                                                      margin: const EdgeInsets.all(10),
                                                    );
                                                  },
                                                  child: const Icon(
                                                    Icons.copy,
                                                    color: AppColors.primaryGreen,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        leagueName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 16.0,
                      backgroundImage:
                          leagueLogoPath.startsWith('http') ||
                              leagueLogoPath.startsWith('https')
                          ? NetworkImage(leagueLogoPath)
                          : AssetImage(leagueLogoPath) as ImageProvider,
                      onBackgroundImageError: (_, __) {},
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                color: Colors.transparent,
                child: TabBar(
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.primaryGreen,
                        width: 2.0,
                      ),
                    ),
                  ),
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.white.withValues(alpha: 0.5),
                  tabs: tabs.map((tabName) {
                    return Tab(
                      child: Text(
                        tabName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
