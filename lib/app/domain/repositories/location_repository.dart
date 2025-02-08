import '../entities/location.dart';

abstract class LocationRepository {
  Future<(List<Location>, bool)> getLocations(int page);
}
