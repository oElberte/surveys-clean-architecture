import 'package:test/test.dart';

import 'package:polls/validation/protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  @override
  String validate(String value) {
    final regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);
    return isValid ? null : 'Invalid field';
  }
}

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any field');
  });

  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('contato@elberte.com'), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('contato'), 'Invalid field');
  });
}
