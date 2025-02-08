enum CharacterSpecies {
  human,
  alien,
}

enum CharacterStatus { alive, unknown, dead }

enum CharacterGender { male, female, unknown, genderless }

final characterSpeciesValues = {
  CharacterSpecies.alien: "Alien",
  CharacterSpecies.human: "Human",
};

final characterStatusValues = {
  CharacterStatus.alive: "Alive",
  CharacterStatus.dead: "Dead",
  CharacterStatus.unknown: "unknown",
};

final characterGenderValues = {
  CharacterGender.female: "Female",
  CharacterGender.male: "Male",
  CharacterGender.unknown: "unknown",
  CharacterGender.genderless: "genderless",
};
