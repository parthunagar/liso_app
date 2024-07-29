import 'package:formz/formz.dart';

enum BorrowPersonEmailValidationError { empty, incorrect }

class BorrowPersonEmail extends FormzInput<String, BorrowPersonEmailValidationError> {
  const BorrowPersonEmail.pure() : super.pure('');

  const BorrowPersonEmail.dirty([String value = '']) : super.dirty(value);

  @override
  BorrowPersonEmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return BorrowPersonEmailValidationError.empty;
    } else if (!value.contains('@')) {
      return BorrowPersonEmailValidationError.incorrect;
    }
    return null;
  }
}
