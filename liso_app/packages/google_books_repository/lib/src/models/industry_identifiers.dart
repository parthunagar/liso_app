class IndustryIdentifiers {
  const IndustryIdentifiers({
    required this.type,
    required this.identifier,
  });

  final String type;
  final String identifier;

  static IndustryIdentifiers fromJson(dynamic json) {
    return IndustryIdentifiers(
      type: json['type'] as String,
      identifier: json['identifier'] as String,
    );
  }
}
