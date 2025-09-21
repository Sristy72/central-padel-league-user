import 'package:get/get.dart';

import '../models/player_model.dart';
import '../models/team_model.dart';
import '../models/match_model.dart';
import '../data/home_repository.dart';
import '../../league/models/match_model.dart' as league_match;
// league models imported on demand where required

class HomeController extends GetxController {
  final HomeRepository repository;

  HomeController({HomeRepository? repository})
    : repository = repository ?? Get.find<HomeRepository>();

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
    // Try to load data from APIs. If any call fails, keep sample fallbacks.
    try {
      // Matches (for fixtures and next match)
      final matchesResult = await repository.getAllMatches();
      matchesResult.fold(
        (failure) {
          // keep existing sample data if available
        },
        (success) {
          final data = success.data;
          if (data.isNotEmpty) {
            // Map league.Match -> home Match model (lightweight)
            fixtures.assignAll(data.map(_mapLeagueMatchToHome).toList());

            // For next match, pick the earliest upcoming or the first one
            final upcoming = data
                .where((m) => m.matchDateTime.isAfter(DateTime.now()))
                .toList();
            final next = upcoming.isNotEmpty ? upcoming.first : data.first;
            _populateNextMatchFromLeague(next);
          }
        },
      );

      // Standings (quick stats)
      final standingsResult = await repository.getAllStandings();
      standingsResult.fold((failure) {}, (success) {
        final sdata = success.data;
        if (sdata.isNotEmpty) {
          // pick two recent standings
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

      // Leagues (for league update)
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
      // keep sample fallback data provided in original controller
    }

    // If after API calls fixtures still empty, populate sample data (keeps prior behavior)
    if (fixtures.isEmpty) {
      _populateSampleData();
    }
    if (quickStats.isEmpty) {
      quickStats.assignAll([
        {"name": "Ab Moses", "GP": 13, "W": 13, "L": 13, "Pts": 13, "+/-": 13},
        {"name": "John Doe", "GP": 11, "W": 8, "L": 3, "Pts": 24, "+/-": 10},
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

    team1Players.assignAll([
      Player(name: m.teamOne.teamName, imageUrl: m.teamOne.logoPhotoUrl),
    ]);
    team2Players.assignAll([
      Player(name: m.teamTwo.teamName, imageUrl: m.teamTwo.logoPhotoUrl),
    ]);
  }

  void _populateSampleData() {
    gameReminder.value =
        "Get ready for your padel game at Padel it on August 17th!";
    leagueName.value = "Padel Premier League 2025";
    seasonDates.value = "June 1  September 30, 2025";
    status.value = "Ongoing  Week 3";

    nextMatchDate.value = "17/02/2025";
    nextMatchTime.value = "01:00 PM";
    nextMatchCourt.value = "Court - 01";

    /// Example Team 1
    team1Players.assignAll([
      Player(
        name: "Alice",
        imageUrl: "https://randomuser.me/api/portraits/women/1.jpg",
      ),
      Player(
        name: "Bob",
        imageUrl: "https://randomuser.me/api/portraits/men/2.jpg",
      ),
    ]);

    /// Example Team 2
    team2Players.assignAll([
      Player(
        name: "Charlie",
        imageUrl: "https://randomuser.me/api/portraits/men/3.jpg",
      ),
      Player(
        name: "Daisy",
        imageUrl: "https://randomuser.me/api/portraits/women/4.jpg",
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
              name: "Alice",
              imageUrl: "https://randomuser.me/api/portraits/women/1.jpg",
            ),
            Player(
              name: "Bob",
              imageUrl: "https://randomuser.me/api/portraits/men/2.jpg",
            ),
          ],
        ),
        team2: MatchTeam(
          teamName: "Topspin Titans",
          players: [
            Player(
              name: "Charlie",
              imageUrl: "https://randomuser.me/api/portraits/men/3.jpg",
            ),
            Player(
              name: "Daisy",
              imageUrl: "https://randomuser.me/api/portraits/women/4.jpg",
            ),
          ],
        ),
      ),
      Match(
        date: "SAT 16 AUG 2025",
        time: "03:00",
        team1: MatchTeam(teamName: "Rally Kings", players: []),
        team2: MatchTeam(teamName: "Net Ninjas", players: []),
      ),
      Match(
        date: "SUN 17 AUG 2025",
        time: "05:00",
        team1: MatchTeam(teamName: "Smash Masters", players: []),
        team2: MatchTeam(teamName: "Spin Doctors", players: []),
      ),
    ]);
  }
}
