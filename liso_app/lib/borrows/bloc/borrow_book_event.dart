part of 'borrow_book_bloc.dart';

// abstract class BorrowBookEvent extends Equatable {
//   const BorrowBookEvent();

//   @override
//   bool? get stringify => true;

//   @override
//   List<Object?> get props => [];
// }

abstract class BorrowBookEvent extends Equatable {
  const BorrowBookEvent();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

class BorrowBookNameChangedEvent extends BorrowBookEvent {
  final String name;

  BorrowBookNameChangedEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class BorrowBookEmailChangedEvent extends BorrowBookEvent {
  final String email;

  BorrowBookEmailChangedEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class BorrowBookSubmittedEvent extends BorrowBookEvent {
  final BorrowBook borrowBook;

  BorrowBookSubmittedEvent(this.borrowBook);

  @override
  List<Object?> get props => [borrowBook];
}