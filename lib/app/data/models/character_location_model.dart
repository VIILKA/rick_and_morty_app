class CharacterLocationModel {
  final String name;
  final String url;

  CharacterLocationModel({
    required this.name,
    required this.url,
  });

  factory CharacterLocationModel.fromJson(Map<String, dynamic> json) {
    return CharacterLocationModel(
      name: json["name"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}