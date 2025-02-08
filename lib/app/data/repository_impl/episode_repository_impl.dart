import 'package:rick_and_morty_app/app/data/mappers/episode_mapper.dart';

import '../../domain/entities/episode.dart';
import '../../domain/repositories/episode_repository.dart';
import '../data_sources/episode_remote_data_source.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final EpisodeRemoteDataSource remoteDataSource;

  EpisodeRepositoryImpl(this.remoteDataSource);

  @override
  Future<(List<Episode>, bool)> getEpisodes(int page) async {
    final response = await remoteDataSource.getEpisodes(page);
    final models = response.results;

    final episodeEntities = models.map((m) => m.toEntity()).toList();

    final hasNextPage = (response.info.next != null);

    return (episodeEntities, hasNextPage);
  }
}
