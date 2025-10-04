import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../models/player_model.dart';
import '../models/team_model.dart';
import '../models/match_model.dart';
import '../data/home_repository.dart';
import '../../league/models/match_model.dart' as league_match;
import '../../league/models/standing_model.dart';
import '../../../core/services/get_user_profile_service.dart';

class HomeController extends GetxController {
  final HomeRepository repository;

  HomeController({HomeRepository? repository})
    : repository = repository ?? Get.find<HomeRepository>();

  GetUserProfileService? userProfileService;

  var userName = ''.obs;

  // Search functionality
  var searchQuery = ''.obs;
  var searchResults = <Map<String, dynamic>>[].obs;
  var isSearching = false.obs;

  var gameReminder = ''.obs;
  var leagueName = ''.obs;
  var seasonDates = ''.obs;
  var status = ''.obs;

  var nextMatchDate = ''.obs;
  var nextMatchTime = ''.obs;
  var nextMatchCourt = ''.obs;

  /// Teams for the next match
  var team1Players = <Player>[].obs;
  var team2Players = <Player>[].obs;

  var quickStats = [].obs;
  var fixtures = <Match>[].obs;
  // Keep the original league match objects so we can show full fixtures screen
  var leagueMatches = <league_match.Match>[].obs;

  // Full standings list from API (used by See All -> StandingTab)
  var standingsList = <Standing>[].obs;

  // Loading state
  var isLoading = true.obs;

  // Static cache state - shared across all controller instances to persist between navigation
  static bool _staticHasLoadedData = false;
  static DateTime _staticLastLoadTime = DateTime.now().subtract(
    Duration(hours: 1),
  ); // Force initial load
  static const cacheDuration = Duration(
    minutes: 5,
  ); // Data stays fresh for 5 minutes

  // Static cache for all data - persists across controller recreations
  static String _staticUserName = '';
  static String _staticGameReminder = '';
  static String _staticLeagueName = '';
  static String _staticSeasonDates = '';
  static String _staticStatus = '';
  static String _staticNextMatchDate = '';
  static String _staticNextMatchTime = '';
  static String _staticNextMatchCourt = '';
  static List<Player> _staticTeam1Players = [];
  static List<Player> _staticTeam2Players = [];
  static List<Map<String, dynamic>> _staticQuickStats = [];
  static List<Match> _staticFixtures = [];
  static List<league_match.Match> _staticLeagueMatches = [];
  static List<Standing> _staticStandingsList = [];

  // Cache grouped fixtures to avoid re-computing on every rebuild
  var _cachedGroupedFixtures = <String, List<Match>>{};
  var _fixturesCacheVersion = 0;
  var _lastFixturesCacheVersion = -1;

  /// Grouped fixtures (by date) - cached to avoid rebuilding
  Map<String, List<Match>> get groupedFixtures {
    // Only recompute if fixtures changed
    if (_lastFixturesCacheVersion != _fixturesCacheVersion) {
      _cachedGroupedFixtures = _computeGroupedFixtures(fixtures);
      _lastFixturesCacheVersion = _fixturesCacheVersion;
    }
    return _cachedGroupedFixtures;
  }

  // Helper to group fixtures (static so it could be moved to isolate if needed)
  static Map<String, List<Match>> _computeGroupedFixtures(List<Match> matches) {
    final Map<String, List<Match>> grouped = {};
    for (final match in matches) {
      grouped.putIfAbsent(match.date, () => []).add(match);
    }
    return grouped;
  }

  @override
  void onInit() {
    super.onInit();

    print('📱 HomeController onInit() called');

    // Check if we have cached data that's still fresh
    if (_staticHasLoadedData && _isCacheValid()) {
      // Data is cached and fresh, just load it into this controller instance
      _loadFromStaticCache();
      isLoading.value = false;
      print('✅ Using cached home data - no API calls needed');
      print(
        '🕐 Cache age: ${DateTime.now().difference(_staticLastLoadTime).inSeconds} seconds',
      );
      return;
    }

    // Either no cache or cache is stale, fetch fresh data
    if (_staticHasLoadedData) {
      print(
        '⏰ Cache expired (${DateTime.now().difference(_staticLastLoadTime).inMinutes} minutes old)',
      );
    } else {
      print('🆕 No cache available');
    }
    print('🔄 Fetching fresh home data...');

    // Defer heavy data fetch after first frame so UI renders immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHomeData();
    });
  }

  /// Check if cached data is still valid (within cache duration)
  bool _isCacheValid() {
    return DateTime.now().difference(_staticLastLoadTime) < cacheDuration;
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;

    // Load user profile first (non-blocking quick call)
    try {
      if (Get.isRegistered<GetUserProfileService>()) {
        userProfileService = Get.find<GetUserProfileService>();
        await userProfileService!.getUserProfile();
        userName.value = userProfileService!.userInfo?.name ?? '';
      }
    } catch (_) {
      // ignore errors; keep fallback name
    }

    //* Load API data - sequential is fine since they depend on each other
    try {
      //* Matches (for fixtures and next match)
      final matchesResult = await repository.getAllMatches();
      matchesResult.fold((failure) {}, (success) {
        final data = success.data;
        if (data.isNotEmpty) {
          // store original league match objects
          leagueMatches.assignAll(data);

          //* Map league.Match -> home Match model (lightweight)
          fixtures.assignAll(data.map(_mapLeagueMatchToHome).toList());
          _fixturesCacheVersion++; // Invalidate cache

          //* For next match, pick the earliest upcoming or the first one
          final upcoming = data
              .where((m) => m.matchDateTime.isAfter(DateTime.now()))
              .toList();
          final next = upcoming.isNotEmpty ? upcoming.first : data.first;
          _populateNextMatchFromLeague(next);
        }
      });

      //* Standings (quick stats)
      final standingsResult = await repository.getAllStandings();
      standingsResult.fold((failure) {}, (success) {
        final sdata = success.data;
        if (sdata.isNotEmpty) {
          // keep full standings for See All
          standingsList.assignAll(sdata);

          //* pick two recent standings for quick view
          final two = sdata
              .take(2)
              .map(
                (s) => {
                  'name': s.teamName,
                  'GP': s.played,
                  'W': s.won,
                  'L': s.lost,
                  'Pts': s.points,
                  '+/-': s.goalDifference,
                },
              )
              .toList();
          quickStats.assignAll(two);
        }
      });

      //* League Update
      final leaguesResult = await repository.getAllLeagues();
      leaguesResult.fold((failure) {}, (success) {
        final ldata = success.data;
        if (ldata.isNotEmpty) {
          final latest = ldata.first;
          leagueName.value = latest.leagueName;
          seasonDates.value = '${latest.startDate} - ${latest.endDate}';
          status.value = 'Ongoing';
        }
      });
    } catch (e) {
      print('Error fetching home data: $e'); //! <-- Remove when in production
    }

    //! <-- Dummy data population --->
    if (fixtures.isEmpty) {
      _populateSampleData();
    }
    if (quickStats.isEmpty) {
      quickStats.assignAll([
        {"name": "N/A", "GP": 0, "W": 0, "L": 0, "Pts": 0, "+/-": 0},
        {"name": "N/A", "GP": 0, "W": 0, "L": 0, "Pts": 0, "+/-": 0},
      ]);
    }

    isLoading.value = false;
    _saveToStaticCache();
    _staticHasLoadedData = true;
    _staticLastLoadTime = DateTime.now();
    print('✅ Home data cached successfully');
  }

  /// Force refresh - bypasses cache and fetches fresh data
  Future<void> forceRefresh() async {
    print('🔄 Force refreshing home data...');
    _staticHasLoadedData = false; // Reset cache
    await fetchHomeData();
  }

  /// Check if we should show loading state
  bool get shouldShowLoading {
    return isLoading.value || (!_staticHasLoadedData && fixtures.isEmpty);
  }

  /// Load data from static cache into this controller instance
  void _loadFromStaticCache() {
    userName.value = _staticUserName;
    gameReminder.value = _staticGameReminder;
    leagueName.value = _staticLeagueName;
    seasonDates.value = _staticSeasonDates;
    status.value = _staticStatus;
    nextMatchDate.value = _staticNextMatchDate;
    nextMatchTime.value = _staticNextMatchTime;
    nextMatchCourt.value = _staticNextMatchCourt;
    team1Players.assignAll(_staticTeam1Players);
    team2Players.assignAll(_staticTeam2Players);
    quickStats.assignAll(_staticQuickStats);
    fixtures.assignAll(_staticFixtures);
    leagueMatches.assignAll(_staticLeagueMatches);
    standingsList.assignAll(_staticStandingsList);
    _fixturesCacheVersion++; // Invalidate fixture cache to trigger recalculation
  }

  /// Save current data to static cache for persistence across navigation
  void _saveToStaticCache() {
    _staticUserName = userName.value;
    _staticGameReminder = gameReminder.value;
    _staticLeagueName = leagueName.value;
    _staticSeasonDates = seasonDates.value;
    _staticStatus = status.value;
    _staticNextMatchDate = nextMatchDate.value;
    _staticNextMatchTime = nextMatchTime.value;
    _staticNextMatchCourt = nextMatchCourt.value;
    _staticTeam1Players = List.from(team1Players);
    _staticTeam2Players = List.from(team2Players);
    _staticQuickStats = List.from(quickStats);
    _staticFixtures = List.from(fixtures);
    _staticLeagueMatches = List.from(leagueMatches);
    _staticStandingsList = List.from(standingsList);
  }

  /// Map API league match model to lightweight home Match model
  Match _mapLeagueMatchToHome(league_match.Match m) {
    final dateStr = m.matchDateTime.toLocal().toIso8601String();
    final date = dateStr.split('T').first; // yyyy-mm-dd
    return Match(
      date: date,
      time:
          '${m.matchDateTime.toLocal().hour.toString().padLeft(2, '0')}:${m.matchDateTime.toLocal().minute.toString().padLeft(2, '0')}',
      team1: MatchTeam(
        teamName: m.teamOne.teamName,
        players: [
          Player(name: m.teamOne.captainName, imageUrl: m.teamOne.logoPhotoUrl),
        ],
      ),
      team2: MatchTeam(
        teamName: m.teamTwo.teamName,
        players: [
          Player(name: m.teamTwo.captainName, imageUrl: m.teamTwo.logoPhotoUrl),
        ],
      ),
    );
  }

  void _populateNextMatchFromLeague(league_match.Match m) {
    nextMatchDate.value = m.matchDateTime
        .toLocal()
        .toIso8601String()
        .split('T')
        .first;
    nextMatchTime.value =
        '${m.matchDateTime.toLocal().hour}:${m.matchDateTime.toLocal().minute.toString().padLeft(2, '0')}';
    nextMatchCourt.value = m.venueName;

    // Set a human-readable game reminder title
    final t1 = m.teamOne.teamName;
    final t2 = m.teamTwo.teamName;
    gameReminder.value =
        '$t1 vs $t2 on ${nextMatchDate.value} at ${nextMatchTime.value}';

    team1Players.assignAll([
      Player(name: m.teamOne.teamName, imageUrl: m.teamOne.logoPhotoUrl),
    ]);
    team2Players.assignAll([
      Player(name: m.teamTwo.teamName, imageUrl: m.teamTwo.logoPhotoUrl),
    ]);
  }

  //* <--- Search functionality --->
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    _performSearch();
  }

  void _performSearch() {
    if (searchQuery.value.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    final query = searchQuery.value.toLowerCase();
    final results = <Map<String, dynamic>>[];

    // Search teams
    for (final match in leagueMatches) {
      // Team 1
      if (match.teamOne.teamName.toLowerCase().contains(query)) {
        results.add({
          'type': 'Team',
          'name': match.teamOne.teamName,
          'imageUrl': match.teamOne.logoPhotoUrl,
          'subtitle': 'Team',
          'teamId': match.teamOne.id,
          'leagueId': match.leagueId,
        });
      }
      // Team 2
      if (match.teamTwo.teamName.toLowerCase().contains(query)) {
        results.add({
          'type': 'Team',
          'name': match.teamTwo.teamName,
          'imageUrl': match.teamTwo.logoPhotoUrl,
          'subtitle': 'Team',
          'teamId': match.teamTwo.id,
          'leagueId': match.leagueId,
        });
      }
    }

    // Search leagues
    if (leagueName.value.isNotEmpty &&
        leagueName.value != "N/A" &&
        leagueName.value.toLowerCase().contains(query)) {
      results.add({
        'type': 'League',
        'name': leagueName.value,
        'imageUrl': '',
        'subtitle': 'League • ${status.value}',
        'leagueId': '',
      });
    }

    // Also search in any available league data from matches
    final leagueData = <String, String>{}; // name -> id mapping
    for (final match in leagueMatches) {
      if (match.leagueName.isNotEmpty) {
        leagueData[match.leagueName] = match.leagueId;
      }
    }

    for (final entry in leagueData.entries) {
      if (entry.key.toLowerCase().contains(query)) {
        results.add({
          'type': 'League',
          'name': entry.key,
          'imageUrl': '',
          'subtitle': 'League',
          'leagueId': entry.value,
        });
      }
    }

    // Fallback: add some sample leagues if no real data
    if (leagueMatches.isEmpty || leagueName.value == "N/A") {
      final sampleLeagues = [
        'Premier League',
        'Champions Cup',
        'Summer Tournament',
      ];
      for (final league in sampleLeagues) {
        if (league.toLowerCase().contains(query)) {
          results.add({
            'type': 'League',
            'name': league,
            'imageUrl': '',
            'subtitle': 'League • Sample',
          });
        }
      }
    }

    // Search players
    for (final match in leagueMatches) {
      // Team 1 players
      if (match.teamOne.captainName.toLowerCase().contains(query)) {
        results.add({
          'type': 'Player',
          'name': match.teamOne.captainName,
          'imageUrl': match.teamOne.logoPhotoUrl,
          'subtitle': 'Player • ${match.teamOne.teamName}',
          'teamId': match.teamOne.id,
          'teamName': match.teamOne.teamName,
        });
      }
      if (match.teamOne.partnerName.toLowerCase().contains(query)) {
        results.add({
          'type': 'Player',
          'name': match.teamOne.partnerName,
          'imageUrl': match.teamOne.logoPhotoUrl,
          'subtitle': 'Player • ${match.teamOne.teamName}',
          'teamId': match.teamOne.id,
          'teamName': match.teamOne.teamName,
        });
      }
      // Team 2 players
      if (match.teamTwo.captainName.toLowerCase().contains(query)) {
        results.add({
          'type': 'Player',
          'name': match.teamTwo.captainName,
          'imageUrl': match.teamTwo.logoPhotoUrl,
          'subtitle': 'Player • ${match.teamTwo.teamName}',
          'teamId': match.teamTwo.id,
          'teamName': match.teamTwo.teamName,
        });
      }
      if (match.teamTwo.partnerName.toLowerCase().contains(query)) {
        results.add({
          'type': 'Player',
          'name': match.teamTwo.partnerName,
          'imageUrl': match.teamTwo.logoPhotoUrl,
          'subtitle': 'Player • ${match.teamTwo.teamName}',
          'teamId': match.teamTwo.id,
          'teamName': match.teamTwo.teamName,
        });
      }
    }

    // Remove duplicates
    final uniqueResults = <Map<String, dynamic>>[];
    final seen = <String>{};
    for (final result in results) {
      final key = '${result['type']}_${result['name']}';
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueResults.add(result);
      }
    }

    searchResults.assignAll(uniqueResults);
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
    isSearching.value = false;
  }

  //! <-- Dummy data population function --->
  void _populateSampleData() {
    gameReminder.value = "N/A";
    leagueName.value = "N/A";
    seasonDates.value = "None";
    status.value = "Not Started";

    nextMatchDate.value = "00/00/0000";
    nextMatchTime.value = "00:00 PM";
    nextMatchCourt.value = "Court - 00";

    /// Example Team 1
    team1Players.assignAll([
      Player(
        name: "N/A",
        imageUrl:
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F49917726%2Fretrieving-default-image-all-url-profile-picture-from-facebook-graph-api&psig=AOvVaw3NHjSypnn9PiQGGYvy14QX&ust=1758529667866000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJjlhtm36Y8DFQAAAAAdAAAAABAE",
      ),
      Player(
        name: "N/A",
        imageUrl:
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F49917726%2Fretrieving-default-image-all-url-profile-picture-from-facebook-graph-api&psig=AOvVaw3NHjSypnn9PiQGGYvy14QX&ust=1758529667866000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJjlhtm36Y8DFQAAAAAdAAAAABAE",
      ),
    ]);

    /// Example Team 2
    team2Players.assignAll([
      Player(
        name: "N/A",
        imageUrl:
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F49917726%2Fretrieving-default-image-all-url-profile-picture-from-facebook-graph-api&psig=AOvVaw3NHjSypnn9PiQGGYvy14QX&ust=1758529667866000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJjlhtm36Y8DFQAAAAAdAAAAABAE",
      ),
      Player(
        name: "N/A",
        imageUrl:
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F49917726%2Fretrieving-default-image-all-url-profile-picture-from-facebook-graph-api&psig=AOvVaw3NHjSypnn9PiQGGYvy14QX&ust=1758529667866000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJjlhtm36Y8DFQAAAAAdAAAAABAE",
      ),
    ]);

    fixtures.assignAll([
      Match(
        date: "SAT 16 AUG 2025",
        time: "01:00",
        team1: MatchTeam(
          teamName: "Baseline Smashers",
          players: [
            Player(
              name: "N/A",
              imageUrl:
                  "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F49917726%2Fretrieving-default-image-all-url-profile-picture-from-facebook-graph-api&psig=AOvVaw3NHjSypnn9PiQGGYvy14QX&ust=1758529667866000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJjlhtm36Y8DFQAAAAAdAAAAABAE",
            ),
            Player(
              name: "N/A",
              imageUrl:
                  "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F49917726%2Fretrieving-default-image-all-url-profile-picture-from-facebook-graph-api&psig=AOvVaw3NHjSypnn9PiQGGYvy14QX&ust=1758529667866000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJjlhtm36Y8DFQAAAAAdAAAAABAE",
            ),
          ],
        ),
        team2: MatchTeam(
          teamName: "N/A",
          players: [
            Player(
              name: "N/A",
              imageUrl:
                  "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F49917726%2Fretrieving-default-image-all-url-profile-picture-from-facebook-graph-api&psig=AOvVaw3NHjSypnn9PiQGGYvy14QX&ust=1758529667866000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJjlhtm36Y8DFQAAAAAdAAAAABAE",
            ),
            Player(
              name: "N/A",
              imageUrl:
                  "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F49917726%2Fretrieving-default-image-all-url-profile-picture-from-facebook-graph-api&psig=AOvVaw3NHjSypnn9PiQGGYvy14QX&ust=1758529667866000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJjlhtm36Y8DFQAAAAAdAAAAABAE",
            ),
          ],
        ),
      ),
      Match(
        date: "N/A",
        time: "00:00",
        team1: MatchTeam(teamName: "N/A", players: []),
        team2: MatchTeam(teamName: "N/A", players: []),
      ),
      Match(
        date: "N/A",
        time: "00:00",
        team1: MatchTeam(teamName: "N/A", players: []),
        team2: MatchTeam(teamName: "N/A", players: []),
      ),
    ]);
  }
}
