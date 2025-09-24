import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/network/api_client.dart';
import 'package:karlfive/features/league/data/league_repository_impl.dart';
import '../../data/models/standing_row_data.dart';
import '../widgets/standing_table_widget.dart';
import '../controllers/team_controller.dart';

class TeamDetailsScreen extends StatefulWidget {
  final String? teamId;
  const TeamDetailsScreen({super.key, this.teamId});

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  // All UI content below is driven by TeamController (API). No local dummy data.
  final _api = ApiClient();
  late final LeagueRepositoryImpl _leagueRepo = LeagueRepositoryImpl(
    apiClient: _api,
  );

  final RxList<StandingRowData> _standingRows = <StandingRowData>[].obs;
  final RxBool _isLoadingStandings = false.obs;
  final RxString _standingsError = ''.obs;

  @override
  Widget build(BuildContext context) {
    final teamCtrl = Get.find<TeamController>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final id = widget.teamId;
      if (id != null &&
          id.isNotEmpty &&
          teamCtrl.team.value == null &&
          !teamCtrl.isLoading.value) {
        await teamCtrl.fetchTeam(id);
      }

      // If team is already available (or after fetch), load standings for its league
      final leagueId = teamCtrl.team.value?.league?.id;
      if (leagueId != null && leagueId.isNotEmpty) {
        // fire and forget; UI reacts via Obx
        // ignore: unawaited_futures
        _fetchStandingsForLeague(leagueId);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(color: Colors.white12),
            child: Center(
              child: Image.asset(
                'assets/icons/X.png',
                width: 16,
                height: 16,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/teamDetails_appbar_background.jpg",
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(() {
              final team = Get.find<TeamController>().team.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    team?.teamName ?? "Team Details",
                    style: const TextStyle(
                      color: Color(0xFF2AAF08),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        (team?.logoPhotoUrl != null &&
                            team!.logoPhotoUrl.isNotEmpty)
                        ? NetworkImage(team.logoPhotoUrl)
                        : null,
                    child:
                        (team?.logoPhotoUrl == null ||
                            team!.logoPhotoUrl.isEmpty)
                        ? Image.asset(
                            "assets/icons/Layer_1.png",
                            width: 42,
                            height: 36,
                            color: const Color(0xFF0E7DB4),
                          )
                        : null,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final teamController = Get.find<TeamController>();
          if (teamController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          if (teamController.error.value != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${teamController.error.value}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.teamId != null)
                        teamController.fetchTeam(widget.teamId!);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final team = teamController.team.value;
          if (team == null) {
            return const Center(
              child: Text(
                'No team data available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Team Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Team Logo and Basic Info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[600],
                            backgroundImage: team.logoPhotoUrl.isNotEmpty
                                ? NetworkImage(team.logoPhotoUrl)
                                : null,
                            child: team.logoPhotoUrl.isEmpty
                                ? const Icon(
                                    Icons.groups,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  team.teamName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  team.league?.leagueName ?? 'No League',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      team.applicationStatus,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    team.applicationStatus.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Team Details
                      _buildDetailRow('Player Level', team.playerLevels),
                      _buildDetailRow('Email', team.email),
                      _buildDetailRow('Contact', team.contactNumber),
                      _buildDetailRow(
                        'Location',
                        team.league?.location ?? 'N/A',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Team Members
                const Divider(color: Colors.white24, thickness: 1, height: 5),
                const SizedBox(height: 10),
                const Text(
                  "Team Members",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMemberCard(
                      team.captainName,
                      'Captain',
                      team.logoPhotoUrl,
                    ),
                    const SizedBox(width: 13),
                    _buildMemberCard(
                      team.partnerName,
                      'Partner',
                      team.logoPhotoUrl,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Team Standing (API)
                const Divider(color: Colors.white24, thickness: 1, height: 5),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Team Standing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  if (_isLoadingStandings.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }
                  if (_standingsError.value.isNotEmpty) {
                    return Text(
                      _standingsError.value,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  if (_standingRows.isEmpty) {
                    return const Text(
                      'No standings available',
                      style: TextStyle(color: Colors.white70),
                    );
                  }
                  return buildStandingTable(_standingRows);
                }),
                const SizedBox(height: 8),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Removed local month/fixture helper; fixtures should be provided by API when available.

  Widget _buildMemberCard(String name, String role, String? imageUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.grey[600],
          backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
              ? NetworkImage(imageUrl)
              : null,
          child: (imageUrl == null || imageUrl.isEmpty)
              ? const Icon(Icons.person, color: Colors.white, size: 35)
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        const SizedBox(height: 2),
        Text(role, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _fetchStandingsForLeague(String leagueId) async {
    try {
      _isLoadingStandings.value = true;
      _standingsError.value = '';
      _standingRows.clear();

      final result = await _leagueRepo.getStandingsAll();
      result.fold(
        (failure) {
          _standingsError.value = failure.message;
        },
        (success) {
          final data = success.data;
          // Filter by the league and map into table rows
          final rows = data
              .where((s) => s.leagueId == leagueId)
              .map(
                (s) => StandingRowData(
                  pos: s.position.toString(),
                  team: s.teamName,
                  p: s.played.toString(),
                  w: s.won.toString(),
                  d: s.drawn.toString(),
                  l: s.lost.toString(),
                  gd: s.goalDifference.toString(),
                  pts: s.points.toString(),
                  teamIcon: s.teamLogoUrl,
                  highlight:
                      s.teamId == Get.find<TeamController>().team.value?.id,
                ),
              )
              .toList();
          _standingRows.assignAll(rows);
        },
      );
    } catch (e) {
      _standingsError.value = e.toString();
    } finally {
      _isLoadingStandings.value = false;
    }
  }
}
