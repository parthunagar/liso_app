import 'package:formz/formz.dart';

enum PersonNameValidationError { empty }

class PersonName extends FormzInput<String, PersonNameValidationError> {
  const PersonName.pure() : super.pure('');

  const PersonName.dirty([String value = '']) : super.dirty(value);

  @override
  PersonNameValidationError? validator(String value) =>
      value.isEmpty ? PersonNameValidationError.empty : null;
}
