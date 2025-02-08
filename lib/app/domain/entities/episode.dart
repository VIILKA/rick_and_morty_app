class Episode {
  final int id;
  final String name;
  final String airDate; // e.g. "December 2, 2013"
  final String episode; // e.g. "S01E01"
  final List<String> characters; // список URL на персонажей
  final String url;
  final DateTime created;

  const Episode({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.characters,
    required this.url,
    required this.created,
  });
}
