/// Info-модель для Rick & Morty API (с полями count, pages, next, prev)
class InfoModel {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  InfoModel({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      count: json["count"],
      pages: json["pages"],
      next: json["next"],
      prev: json["prev"],
    );
  }
}
