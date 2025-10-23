import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';

class CustomLeagueAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String leagueName;
  final String leagueLogoPath;
  final String backgroundImagePath;
  final TabController tabController;

  const CustomLeagueAppbar({
    super.key,
    required this.leagueName,
    required this.leagueLogoPath,
    required this.backgroundImagePath,
    required this.tabController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(200.0);

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ['Standing', 'Matches', 'Teams', 'Fixtures'];

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
                    IconButton(
                      icon: const Image(
                        height: 22,
                        width: 22,
                        image: AssetImage("assets/images/star_icon_off.png"),
                      ),
                      onPressed: () {}, // TODO: Add favorite logic here
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
                        maxLines: 2,
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
