import 'package:dio/dio.dart';
import '../models/location_model.dart';
import '../models/info_model.dart';

class PaginatedLocationsResponse {
  final InfoModel info;
  final List<LocationModel> results;

  PaginatedLocationsResponse({
    required this.info,
    required this.results,
  });
}

class LocationRemoteDataSource {
  final Dio dio;

  LocationRemoteDataSource(this.dio);

  Future<PaginatedLocationsResponse> getLocations(int page) async {
    final queryParams = {
      'page': '$page',
    };

    final response = await dio.get(
      'https://rickandmortyapi.com/api/location',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;

      final infoJson = data['info'] as Map<String, dynamic>;
      final info = InfoModel.fromJson(infoJson);

      final resultsList = data['results'] as List;
      final locationModels = resultsList.map((item) {
        return LocationModel.fromJson(item);
      }).toList();

      return PaginatedLocationsResponse(
        info: info,
        results: locationModels,
      );
    } else {
      throw Exception('Ошибка при загрузке локаций: ${response.statusCode}');
    }
  }
}
