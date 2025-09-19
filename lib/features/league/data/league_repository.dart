// features/league/data/repositories/league_repository.dart
import '../models/league_model.dart';
import 'league_remote_data_source.dart';

abstract class LeagueRepository {
  Future<List<League>> getLeagues();
}

class LeagueRepositoryImpl implements LeagueRepository {
  final LeagueRemoteDataSource remoteDataSource;

  LeagueRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<League>> getLeagues() async {
    return await remoteDataSource.getLeagues();
  }
}
