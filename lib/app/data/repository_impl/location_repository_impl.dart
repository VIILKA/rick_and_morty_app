import 'package:rick_and_morty_app/app/data/mappers/location_model_mapper.dart';

import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../data_sources/location_remote_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl(this.remoteDataSource);

  @override
  Future<(List<Location>, bool)> getLocations(int page) async {
    final response = await remoteDataSource.getLocations(page);

    final list = response.results.map((m) => m.toEntity()).toList();
    final hasNextPage = (response.info.next != null);

    return (list, hasNextPage);
  }
}
