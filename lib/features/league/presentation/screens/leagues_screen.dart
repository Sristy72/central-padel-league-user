import 'package:flutter/material.dart';
import 'package:karlfive/core/common/widgets/app_bottom_navbar.dart';
import 'package:karlfive/features/league/presentation/widgets/league_card.dart';

// features/league/presentation/pages/leagues_screen.dart
import '../../data/league_remote_data_source.dart';
import '../../data/league_repository.dart';
import '../../models/league_model.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  late Future<List<League>> futureLeagues;
  final LeagueRepository repository = LeagueRepositoryImpl(
    remoteDataSource: LeagueRemoteDataSourceImpl(),
  );

  @override
  void initState() {
    super.initState();
    futureLeagues = repository.getLeagues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<League>>(
        future: futureLeagues,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final leagues = snapshot.data!;
            return ListView.builder(
              itemCount: leagues.length,
              itemBuilder: (context, index) {
                return LeagueCard(league: leagues[index]);
              },
            );
          } else {
            return const Center(child: Text('No leagues available'));
          }
        },
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 1),
    );
  }
}
