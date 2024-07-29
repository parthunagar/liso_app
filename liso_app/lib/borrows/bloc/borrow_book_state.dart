part of 'borrow_book_bloc.dart';


class BorrowBookState extends Equatable {
  final FormzStatus status;
  // final BorrowBook borrowBook;
  final BorrowPersonName personName;
  final BorrowPersonEmail personEmail;

  const BorrowBookState({
    this.status = FormzStatus.pure,
    this.personName = const BorrowPersonName.pure(),
    this.personEmail = const BorrowPersonEmail.pure(),
    // this.borrowBook = const 
  });

  BorrowBookState copyWith({
    FormzStatus? status,
    BorrowPersonName? personName,
    BorrowPersonEmail? personEmail,
  }) =>
      BorrowBookState(
        personEmail: personEmail ?? this.personEmail,
        personName: personName ?? this.personName,
        status: (personEmail != null || personName != null)
            ? Formz.validate([
                personEmail ?? this.personEmail,
                personName ?? this.personName,
              ])
            : (status ?? this.status),
      );

  @override
  List<Object?> get props => [
        status,
        personName,
        personEmail,
      ];

  @override
  bool? get stringify => true;
}
