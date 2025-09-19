import 'package:get/get.dart';

import '../models/player_model.dart';
import '../models/team_model.dart';
import '../models/match_model.dart';


class HomeController extends GetxController {
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

  void fetchHomeData() async {
    await Future.delayed(const Duration(seconds: 1));

    gameReminder.value =
        "Get ready for your padel game at Padel it on August 17th!";
    leagueName.value = "Padel Premier League 2025";
    seasonDates.value = "June 1 – September 30, 2025";
    status.value = "Ongoing – Week 3";

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

    quickStats.assignAll([
      {"name": "Ab Moses", "GP": 13, "W": 13, "L": 13, "Pts": 13, "+/-": 13},
      {"name": "John Doe", "GP": 11, "W": 8, "L": 3, "Pts": 24, "+/-": 10},
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
