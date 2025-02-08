import '../entities/episode.dart';

abstract class EpisodeRepository {
  Future<(List<Episode>, bool)> getEpisodes(int page);
}
