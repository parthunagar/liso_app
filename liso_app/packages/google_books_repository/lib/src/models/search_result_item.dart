import 'package:google_books_repository/google_books_repository.dart';

class SearchResultItem {
  const SearchResultItem({
    required this.kind,
    required this.id,
    required this.etag,
    required this.volumeInfo,
  });

  final String kind;
  final String id;
  final String etag;
  final VolumeInfo volumeInfo;

  static SearchResultItem fromJson(dynamic json) {
    return SearchResultItem(
      kind: json['kind'] as String,
      id: json['id'] as String,
      etag: json['etag'] as String,
      volumeInfo: VolumeInfo.fromJson(json['volumeInfo']),
    );
  }
}
