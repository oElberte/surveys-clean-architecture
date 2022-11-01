import 'package:meta/meta.dart';

import 'package:faker/faker.dart';
import 'package:polls/presentation/protocols/protocols.dart';
import 'package:polls/validation/protocols/protocols.dart';
import 'package:test/test.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int length;

  MinLengthValidation({@required this.field, @required this.length});

  ValidationError validate(String value) {
    return ValidationError.invalidField;
  }
}

void main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', length: 5);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationError.invalidField);
  });

  test('Should return error if value is less min length', () {
    expect(
      sut.validate(faker.randomGenerator.string(4, min: 1)),
      ValidationError.invalidField,
    );
  });
}