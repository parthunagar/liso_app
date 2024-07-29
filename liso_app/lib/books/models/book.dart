import 'package:equatable/equatable.dart';

class Book extends Equatable {
  const Book({
    required this.id,
    required this.title,
    required this.status,
  });

  final int id;
  final String title;
  final String status;

  @override
  List<Object> get props => [
        id,
        title,
        status,
      ];

  static Book fromJson(dynamic json) {
    return Book(
      id: json['id'] as int,
      title: json['title'] as String,
      status: json['status'] as String,
    );
  }
}
