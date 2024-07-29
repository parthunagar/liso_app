part of 'book_loan_bloc.dart';

abstract class BookLoanEvent extends Equatable {
  const BookLoanEvent();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

class BookLoanNameChangedEvent extends BookLoanEvent {

  const BookLoanNameChangedEvent(this.name);
  final String name;

  @override
  List<Object?> get props => [name];
}

class BookLoanEmailChangedEvent extends BookLoanEvent {

  const BookLoanEmailChangedEvent(this.email);
  final String email;

  @override
  List<Object?> get props => [email];
}

class BookLoanSubmittedEvent extends BookLoanEvent {}
