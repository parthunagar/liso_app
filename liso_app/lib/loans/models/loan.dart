import 'package:equatable/equatable.dart';
import 'package:sharish/books/models/book.dart';

class Loan extends Equatable {
  const Loan({
    required this.id,
    required this.libraryId,
    required this.book,
    required this.user,
  });

  final int id;
  final int libraryId;
  final Book book;
  final SimpleUser user;

  @override
  List<Object> get props => [id, libraryId, book, user];
}

class SimpleUser extends Equatable {
  const SimpleUser({required this.id, required this.name});

  final int id;
  final String name;

  @override
  List<Object> get props => [id, name];

  static SimpleUser fromJson(dynamic json) {
    return SimpleUser(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
