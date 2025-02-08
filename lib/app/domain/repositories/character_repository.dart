import 'package:rick_and_morty_app/app/domain/entities/character.dart';
import 'package:rick_and_morty_app/app/domain/entities/filters/character_filter.dart';

abstract class CharacterRepository {
  /// Загрузка списка персонажей (постранично) с фильтром
  Future<(List<Character>, bool)> getCharacters(int page,
      {CharacterFilter? filter});
}
