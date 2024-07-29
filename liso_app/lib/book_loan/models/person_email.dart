import 'package:formz/formz.dart';

enum PersonEmailValidationError { empty, incorrect }

class PersonEmail extends FormzInput<String, PersonEmailValidationError> {
  const PersonEmail.pure() : super.pure('');

  const PersonEmail.dirty([String value = '']) : super.dirty(value);

  @override
  PersonEmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return PersonEmailValidationError.empty;
    } else if (!value.contains('@')) {
      return PersonEmailValidationError.incorrect;
    }
    return null;
  }
}
