import 'package:rick_and_morty_app/app/data/models/character_location_model.dart';
import 'package:rick_and_morty_app/app/data/models/character_model.dart';
import 'package:rick_and_morty_app/app/domain/entities/character.dart';
import 'package:rick_and_morty_app/app/domain/entities/character_location.dart';

extension CharacterLocationModelMapper on CharacterLocationModel {
  CharacterLocation toEntity() {
    return CharacterLocation(
      name: name,
      url: url,
    );
  }
}

extension CharacterModelMapper on CharacterModel {
  Character toEntity() {
    return Character(
      id: id,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      origin: origin.toEntity(),
      location: location.toEntity(),
      image: image,
      episode: episode,
      url: url,
      created: created,
    );
  }
}
