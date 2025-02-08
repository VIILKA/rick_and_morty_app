import '../entities/location.dart';

/// Интерфейс репозитория для локаций.
/// Возвращает (список локаций, есть ли следующая страница)
abstract class LocationRepository {
  Future<(List<Location>, bool)> getLocations(int page);
}
