import 'package:faker/faker.dart';
import 'package:surveys/presentation/protocols/protocols.dart';
import 'package:surveys/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  late MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', length: 5);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate({'any_field': ''}), ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate({'any_field': null}), ValidationError.invalidField);
  });

  test('Should return error if value is less min length', () {
    expect(
      sut.validate({
        'any_field': faker.randomGenerator.string(4, min: 1),
      }),
      ValidationError.invalidField,
    );
  });

  test('Should return null if value is less equal than min length', () {
    expect(
      sut.validate(
        {'any_field': faker.randomGenerator.string(5, min: 5)},
      ),
      null,
    );
  });

  test('Should return null if value is greater than min length', () {
    expect(
      sut.validate({
        'any_field': faker.randomGenerator.string(10, min: 6),
      }),
      null,
    );
  });
}
