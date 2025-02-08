import 'package:rick_and_morty_app/app/data/models/episode_model.dart';

import '../../domain/entities/episode.dart';

extension EpisodeModelMapper on EpisodeModel {
  Episode toEntity() {
    return Episode(
      id: id,
      name: name,
      airDate: airDate,
      episode: episode,
      characters: characters,
      url: url,
      created: created,
    );
  }
}
