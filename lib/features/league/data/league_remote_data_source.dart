import '../models/league_model.dart';

abstract class LeagueRemoteDataSource {
  Future<List<League>> getLeagues();
}

class LeagueRemoteDataSourceImpl implements LeagueRemoteDataSource {
  @override
  Future<List<League>> getLeagues() async {
    return [
      League(
        //! <--Need to change after API-->
        id: '1',
        name: 'Premier League',
        backgroundImageUrl: 'assets/images/example_bg.jpg',
        logoImageUrl: 'assets/images/group_logo.png',
        description: 'Top English football league',
        memberCount: 4,
      ),
      League(
        id: '2',
        name: 'La Liga',
        backgroundImageUrl: 'assets/images/example_bg.jpg',
        logoImageUrl: 'assets/images/group_logo.png',
        description: 'Top Spanish football league',
        memberCount: 4,
      ),
      League(
        id: '3',
        name: 'Soikot Liga',
        backgroundImageUrl: 'assets/images/example_bg.jpg',
        logoImageUrl: 'assets/images/group_logo.png',
        description: 'Top Spanish football league',
        memberCount: 4,
      ),
      League(
        id: '4',
        name: 'Iftikhar Liga',
        backgroundImageUrl: 'assets/images/example_bg.jpg',
        logoImageUrl: 'assets/images/group_logo.png',
        description: 'Top Spanish football league',
        memberCount: 4,
      ),
      League(
        id: '5',
        name: 'Zafor Liga',
        backgroundImageUrl: 'assets/images/example_bg.jpg',
        logoImageUrl: 'assets/images/group_logo.png',
        description: 'Top Spanish football league',
        memberCount: 4,
      ),
      // Add more leagues as needed
    ];
  }
}
