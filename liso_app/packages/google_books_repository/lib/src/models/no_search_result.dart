class NoSearchResult {
  const NoSearchResult({required this.kind, required this.totalItems});

  final String kind;
  final int totalItems;

  static NoSearchResult fromJson(dynamic json) {
    return NoSearchResult(
      kind: json['kind'] as String,
      totalItems: json['totalItems'] as int,
    );
  }
}
