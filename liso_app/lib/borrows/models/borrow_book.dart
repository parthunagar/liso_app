import 'package:equatable/equatable.dart';

class BorrowBook extends Equatable {
  const BorrowBook({
    required this.title,
    required this.authors,
    required this.isbn13,
    required this.name,
    required this.email,
  });

  final String title;
  final List authors;
  final String isbn13;
  final String name, email;

  @override
  List<Object> get props => [title, authors, isbn13, name, email];
}
