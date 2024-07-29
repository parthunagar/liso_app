import 'package:google_books_repository/google_books_repository.dart';
class VolumeInfo {
  const VolumeInfo({
    required this.title,
    required this.authors,
    required this.industryIdentifiers,
  });

  final String title;
  final List authors;
  final List<IndustryIdentifiers> industryIdentifiers;

  static VolumeInfo fromJson(dynamic json) {
    var industryIdentifiersJson = json['industryIdentifiers'] as List;
    return VolumeInfo(
      title: json['title'] as String,
      authors: List<String>.from(json["authors"].map((x) => x)),//json['authors'] as List,
      industryIdentifiers: industryIdentifiersJson.map((identifiers) => IndustryIdentifiers.fromJson(identifiers)).toList(),
    );
  }
}
