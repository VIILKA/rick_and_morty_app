import 'package:rick_and_morty_app/app/data/models/location_model.dart';

import '../../domain/entities/location.dart';

extension LocationModelMapper on LocationModel {
  Location toEntity() {
    return Location(
      id: id,
      name: name,
      type: type,
      dimension: dimension,
      residents: residents,
      url: url,
      created: created,
    );
  }
}
