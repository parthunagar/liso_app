part of 'book_loan_bloc.dart';

class BookLoanState extends Equatable {
  const BookLoanState({
    this.status = FormzStatus.pure,
    this.personName = const PersonName.pure(),
    this.personEmail = const PersonEmail.pure(),
  });
  final FormzStatus status;
  final PersonName personName;
  final PersonEmail personEmail;

  BookLoanState copyWith({
    FormzStatus? status,
    PersonName? personName,
    PersonEmail? personEmail,
  }) =>
      BookLoanState(
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
