import '../entities/episode.dart';

/// Интерфейс (контракт) репозитория для эпизодов.
/// Возвращает кортеж (список эпизодов, есть ли следующая страница).
abstract class EpisodeRepository {
  Future<(List<Episode>, bool)> getEpisodes(int page);
}
