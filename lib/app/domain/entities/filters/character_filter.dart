import '../character_enums.dart';

class CharacterFilter {
  final String? name;
  final CharacterStatus? status;
  final CharacterSpecies? species;
  final String? type;
  final CharacterGender? gender;

  const CharacterFilter({
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
  });
}
