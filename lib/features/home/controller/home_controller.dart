import 'package:get/get.dart';

/// Player model
class Player {
  final String name;
  final String imageUrl;

  Player({required this.name, required this.imageUrl});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(name: json["name"] ?? "", imageUrl: json["imageUrl"] ?? "");
  }
}

/// Team model
class MatchTeam {
  final String teamName;
  final List<Player> players;

  MatchTeam({required this.teamName, required this.players});

  factory MatchTeam.fromJson(Map<String, dynamic> json) {
    return MatchTeam(
      teamName: json["teamName"] ?? "",
      players: (json["players"] as List<dynamic>? ?? [])
          .map((e) => Player.fromJson(e))
          .toList(),
    );
  }
}

/// Match model
class Match {
  final String date;
  final String time;
  final MatchTeam team1;
  final MatchTeam team2;

  Match({
    required this.date,
    required this.time,
    required this.team1,
    required this.team2,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      date: json["date"] ?? "",
      time: json["time"] ?? "",
      team1: MatchTeam.fromJson(json["team1"] ?? {}),
      team2: MatchTeam.fromJson(json["team2"] ?? {}),
    );
  }
}

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
