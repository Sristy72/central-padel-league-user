import '../league/models/league_model.dart';

abstract class LeagueRemoteDataSource {
  Future<List<League>> getLeagues();
}

class LeagueRemoteDataSourceImpl implements LeagueRemoteDataSource {
  @override
  Future<List<League>> getLeagues() async {
    await Future.delayed(const Duration(seconds: 2)); 

    return [
      League(//! <--Not needed after API-->
        id: '1',
        name: 'Premier League',
        backgroundImageUrl: 'assets/images/example_bg.jpg',
        logoImageUrl: 'assets/images/group_icon.png',
        description: 'Top English football league',
        memberCount: 20,
      ),
      League(
        id: '2',
        name: 'La Liga',
        backgroundImageUrl: 'assets/images/example_bg.jpg',
        logoImageUrl: 'assets/images/group_icon.png',
        description: 'Top Spanish football league',
        memberCount: 20,
      ),
      League(
        id: '3',
        name: 'Joshin Liga',
        backgroundImageUrl: 'assets/images/example_bg.jpg',
        logoImageUrl: 'assets/images/group_icon.png',
        description: 'Top Spanish football league',
        memberCount: 20,
      ),
      League(
        id: '4',
        name: 'Korim Liga',
        backgroundImageUrl: 'assets/images/example_bg.jpg',
        logoImageUrl: 'assets/images/group_icon.png',
        description: 'Top Spanish football league',
        memberCount: 20,
      ),
      League(
        id: '5',
        name: 'Zafor Liga',
        backgroundImageUrl: 'assets/images/example_bg.jpg',
        logoImageUrl: 'assets/images/group_icon.png',
        description: 'Top Spanish football league',
        memberCount: 20,
      ),
      // Add more leagues as needed
    ];
  }
}
