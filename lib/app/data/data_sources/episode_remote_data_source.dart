import 'package:dio/dio.dart';
import '../models/episode_model.dart';
import '../models/info_model.dart';

class PaginatedEpisodesResponse {
  final InfoModel info;
  final List<EpisodeModel> results;

  PaginatedEpisodesResponse({
    required this.info,
    required this.results,
  });
}

class EpisodeRemoteDataSource {
  final Dio dio;

  EpisodeRemoteDataSource(this.dio);

  Future<PaginatedEpisodesResponse> getEpisodes(int page) async {
    final queryParams = {
      'page': '$page',
    };

    final response = await dio.get(
      'https://rickandmortyapi.com/api/episode',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final infoMap = data['info'] as Map<String, dynamic>;
      final info = InfoModel.fromJson(infoMap);

      final resultsList = data['results'] as List;
      final episodeModels = resultsList.map((item) {
        return EpisodeModel.fromJson(item);
      }).toList();

      return PaginatedEpisodesResponse(
        info: info,
        results: episodeModels,
      );
    } else {
      throw Exception('Ошибка при загрузке эпизодов: ${response.statusCode}');
    }
  }
}
