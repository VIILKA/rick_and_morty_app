import 'package:rick_and_morty_app/app/data/mappers/character_mapper.dart';
import 'package:rick_and_morty_app/app/domain/entities/filters/character_filter.dart';
import 'package:rick_and_morty_app/app/domain/entities/character.dart';
import 'package:rick_and_morty_app/app/domain/repositories/character_repository.dart';

import '../data_sources/character_remote_data_source.dart';

/// Реализация репозитория: ходит в remote_data_source, мапит DTO -> Entity.
/// Содержит методы для постраничной загрузки (getCharacters(page, filter)).
class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;

  CharacterRepositoryImpl(this.remoteDataSource);

  @override
  Future<(List<Character>, bool)> getCharacters(int page,
      {CharacterFilter? filter}) async {
    final response = await remoteDataSource.getCharacters(page, filter: filter);
    final list = response.results.map((m) => m.toEntity()).toList();
    final hasNext = response.info.next != null;
    return (list, hasNext);
  }
}
