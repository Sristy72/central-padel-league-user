import 'package:get/get.dart';

import '../models/player_model.dart';
import '../models/team_model.dart';
import '../models/match_model.dart';
import '../data/home_repository.dart';
import '../../league/models/match_model.dart' as league_match;
import '../../league/models/standing_model.dart';
import '../../../core/services/get_user_profile_service.dart';
// league models imported on demand where required

class HomeController extends GetxController {
  final HomeRepository repository;

  HomeController({HomeRepository? repository})
    : repository = repository ?? Get.find<HomeRepository>();

  GetUserProfileService? userProfileService;

  var userName = ''.obs;

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

  /// Grouped fixtures (by date)
  Map<String, List<Match>> get groupedFixtures {
    final Map<String, List<Match>> grouped = {};
    for (final match in fixtures) {
      grouped.putIfAbsent(match.date, () => []).add(match);
    }
    return grouped;
  }

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    // Load user profile first so UI can greet the user. Only use the service
    // if it was registered during app startup to avoid Get.find exceptions.
    try {
      if (Get.isRegistered<GetUserProfileService>()) {
        userProfileService = Get.find<GetUserProfileService>();
        await userProfileService!.getUserProfile();
        userName.value = userProfileService!.userInfo?.name ?? '';
      }
    } catch (_) {
      // ignore errors; keep fallback name
    }
    //* Try to load data from APIs. If any call fails, keep sample fallbacks.
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
        //! <-- Dummy data population --->
        {"name": "N/A", "GP": 0, "W": 0, "L": 0, "Pts": 0, "+/-": 0},
        {"name": "N/A", "GP": 0, "W": 0, "L": 0, "Pts": 0, "+/-": 0},
      ]);
    }
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
