import 'package:test/test.dart';

import 'package:polls/validation/validators/validators.dart';
import 'package:polls/main/factories/factories.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeSignUpValidations();

    expect(validations, [
      RequiredFieldValidation('name'),
      MinLengthValidation(field: 'name', length: 3),
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', length: 3),
      RequiredFieldValidation('passwordConfirmation'),
      CompareFieldsValidation(
        field: 'passwordConfirmation',
        fieldToCompare: 'password',
      )
    ]);
  });
}
