import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';
import '../../../team_details/presentation/screens/team_details_screens.dart';
import '../../../team_details/presentation/controllers/team_controller.dart';
import '../../../league/presentation/screens/league_details_screen.dart';
import '../../../league/models/league_model.dart';

class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (!controller.isSearching.value) {
        return const SizedBox.shrink();
      }

      if (controller.searchResults.isEmpty) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width < 400 ? 12.0 : 24.0,
          ),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'No results found',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        );
      }

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width < 400 ? 12.0 : 24.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Search Results (${controller.searchResults.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            ...controller.searchResults.map((result) {
              return _buildResultItem(result);
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildResultItem(Map<String, dynamic> result) {
    final type = result['type'] as String;
    final name = result['name'] as String;
    final imageUrl = result['imageUrl'] as String;
    final subtitle = result['subtitle'] as String;

    return InkWell(
      onTap: () => _handleItemTap(result),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Row(
          children: [
            // Icon/Avatar based on type
            CircleAvatar(
              radius: 20,
              backgroundColor: _getTypeColor(type),
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl.isEmpty
                  ? Icon(_getTypeIcon(type), color: Colors.white, size: 20)
                  : null,
            ),
            const SizedBox(width: 12),

            // Name and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Type badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getTypeColor(type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                type,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: _getTypeColor(type),
                ),
              ),
            ),

            // Navigation arrow
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _handleItemTap(Map<String, dynamic> result) {
    final type = result['type'] as String;
    
    try {
      switch (type) {
        case 'Team':
          _navigateToTeamDetails(result);
          break;
        case 'League':
          _navigateToLeagueDetails(result);
          break;
        case 'Player':
          _navigateToPlayerTeamDetails(result);
          break;
      }
    } catch (e) {
      // Show error snackbar if navigation fails
      Get.snackbar(
        'Navigation Error',
        'Unable to open details for this item',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  void _navigateToTeamDetails(Map<String, dynamic> result) {
    final teamId = result['teamId'] as String?;
    
    if (teamId != null && teamId.isNotEmpty) {
      // Initialize TeamController if not already registered
      if (!Get.isRegistered<TeamController>()) {
        Get.put(TeamController(repo: Get.find()));
      }
      
      Get.to(() => TeamDetailsScreen(teamId: teamId));
    } else {
      Get.snackbar(
        'Error',
        'Team information not available',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _navigateToLeagueDetails(Map<String, dynamic> result) {
    final leagueId = result['leagueId'] as String?;
    final leagueName = result['name'] as String;
    
    if (leagueId != null && leagueId.isNotEmpty) {
      // Create a minimal League object for navigation
      final league = League(
        id: leagueId,
        leagueName: leagueName,
        description: '',
        leagueLogo: '',
        startDate: DateTime.now(),
        location: '',
        type: '',
        matchFormat: '',
        tiebreakOption: '',
        allowSubstitutes: false,
      );
      
      Get.to(() => LeagueDetailsScreen(league: league));
    } else {
      Get.snackbar(
        'Error',
        'League information not available',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _navigateToPlayerTeamDetails(Map<String, dynamic> result) {
    final teamId = result['teamId'] as String?;
    
    if (teamId != null && teamId.isNotEmpty) {
      // Initialize TeamController if not already registered
      if (!Get.isRegistered<TeamController>()) {
        Get.put(TeamController(repo: Get.find()));
      }
      
      Get.to(() => TeamDetailsScreen(teamId: teamId));
    } else {
      Get.snackbar(
        'Error',
        'Player team information not available',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Team':
        return Colors.blue;
      case 'League':
        return Colors.green;
      case 'Player':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Team':
        return Icons.groups;
      case 'League':
        return Icons.sports_tennis;
      case 'Player':
        return Icons.person;
      default:
        return Icons.search;
    }
  }
}
