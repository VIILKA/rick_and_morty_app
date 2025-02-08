import 'package:dio/dio.dart';

import '../models/character_model.dart';
import '../models/info_model.dart';
import '../../domain/entities/filters/character_filter.dart';
import '../../domain/entities/character_enums.dart'
    show characterStatusValues, characterGenderValues, characterSpeciesValues;

class PaginatedCharactersResponse {
  final InfoModel info;
  final List<CharacterModel> results;

  PaginatedCharactersResponse({
    required this.info,
    required this.results,
  });
}

class CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSource(this.dio);

  Future<PaginatedCharactersResponse> getCharacters(int page,
      {CharacterFilter? filter}) async {
    final queryParameters = <String, String>{
      'page': '$page',
    };

    if (filter != null) {
      if (filter.name != null && filter.name!.isNotEmpty) {
        queryParameters['name'] = filter.name!;
      }
      if (filter.status != null) {
        queryParameters['status'] = characterStatusValues[filter.status]!;
      }
      if (filter.species != null) {
        queryParameters['species'] = characterSpeciesValues[filter.species]!;
      }
      if (filter.type != null && filter.type!.isNotEmpty) {
        queryParameters['type'] = filter.type!;
      }
      if (filter.gender != null) {
        queryParameters['gender'] = characterGenderValues[filter.gender]!;
      }
    }

    try {
      final response = await dio.get(
        'https://rickandmortyapi.com/api/character',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final infoMap = data['info'] as Map<String, dynamic>;
        final info = InfoModel.fromJson(infoMap);

        final resultsList = data['results'] as List;
        final characterModels = resultsList.map((item) {
          return CharacterModel.fromJson(item);
        }).toList();

        return PaginatedCharactersResponse(
            info: info, results: characterModels);
      } else {
        final data = response.data;
        if (response.statusCode == 404 &&
            data is Map &&
            data["error"] == "There is nothing here") {
          final emptyInfo = InfoModel(
            count: 0,
            pages: 1,
            next: null,
            prev: null,
          );
          final emptyResults = <CharacterModel>[];
          return PaginatedCharactersResponse(
              info: emptyInfo, results: emptyResults);
        } else {
          throw Exception(
              'Ошибка при загрузке персонажей: ${response.statusCode}');
        }
      }
    } on DioException catch (dioError) {
      throw Exception('Сетевая ошибка: ${dioError.message}');
    }
  }
}
