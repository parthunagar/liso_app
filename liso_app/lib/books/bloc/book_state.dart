part of 'book_bloc.dart';

enum BookStatus { initial, success, failure }

class BookState extends Equatable {
  const BookState({
    this.status = BookStatus.initial,
    this.books = const <Book>[],
    this.page = 1,
    this.hasReachedMax = false,
    this.libraryId = 0,
  });

  final BookStatus status;
  final List<Book> books;
  final int page;
  final bool hasReachedMax;
  final int libraryId;

  BookState copyWith({
    BookStatus? status,
    List<Book>? books,
    int? page,
    bool? hasReachedMax,
    int? libraryId,
  }) {
    return BookState(
      status: status ?? this.status,
      books: books ?? this.books,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      libraryId: libraryId ?? this.libraryId,
    );
  }

  @override
  String toString() {
    return '''BookState { status: $status, page: $page, libraryId: $libraryId, hasReachedMax: $hasReachedMax, books: ${books.length} }''';
  }

  @override
  List<Object> get props => [status, books, page, libraryId, hasReachedMax];
}
