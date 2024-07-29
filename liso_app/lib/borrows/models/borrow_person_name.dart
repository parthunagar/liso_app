import 'package:formz/formz.dart';

enum BorrowPersonNameValidationError { empty }

class BorrowPersonName extends FormzInput<String, BorrowPersonNameValidationError> {
  const BorrowPersonName.pure() : super.pure('');

  const BorrowPersonName.dirty([String value = '']) : super.dirty(value);

  @override
  BorrowPersonNameValidationError? validator(String value) =>
      value.isEmpty ? BorrowPersonNameValidationError.empty : null;
}
