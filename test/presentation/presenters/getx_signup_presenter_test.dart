import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:surveys/domain/entities/entities.dart';
import 'package:surveys/domain/helpers/helpers.dart';
import 'package:surveys/domain/usecases/usecases.dart';
import 'package:test/test.dart';

import 'package:surveys/ui/helpers/errors/errors.dart';

import 'package:surveys/presentation/presenters/presenters.dart';
import 'package:surveys/presentation/protocols/protocols.dart';

import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxSignUpPresenter sut;
  late MockValidation validation;
  late MockCreateAccount createAccount;
  late MockSaveCurrentAccount saveCurrentAccount;
  late String email;
  late String password;
  late String passwordConfirmation;
  late String name;
  late AccountEntity account;

  PostExpectation mockValidationCall(String? field) => when(validation.validate(
        field: field == null ? anyNamed('field') : field,
        input: anyNamed('input'),
      ));

  void mockValidation({String? field, ValidationError? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockCreateAccountCall() => when(createAccount.create(any));

  void mockCreateAccount(AccountEntity data) {
    account = data;
    mockCreateAccountCall().thenAnswer((_) async => data);
  }

  void mockCreateAccountError(DomainError error) {
    mockCreateAccountCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccountCall() =>
      when(saveCurrentAccount.save(any));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = MockValidation();
    createAccount = MockCreateAccount();
    saveCurrentAccount = MockSaveCurrentAccount();
    sut = GetxSignUpPresenter(
      validation: validation,
      createAccount: createAccount,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    name = faker.person.name();
    mockValidation();
    mockCreateAccount(EntityFactory.makeAccount());
  });

  test('Should call Validation with correct email', () {
    final formData = {
      'name': null,
      'email': email,
      'password': null,
      'passwordConfirmation': null,
    };

    sut.validateEmail(email);

    verify(validation.validate(field: 'email', input: formData)).called(1);
  });

  test('Should emit invalid field error if email is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    //Uses the value inside ".listen" and calls "expectAsyn1" with this value directly
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit required field error if email is empty', () {
    mockValidation(value: ValidationError.requiredField);

    //Uses the value inside ".listen" and calls "expectAsyn1" with this value directly
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if email validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct name', () {
    final formData = {
      'name': name,
      'email': null,
      'password': null,
      'passwordConfirmation': null,
    };

    sut.validateName(name);

    verify(validation.validate(field: 'name', input: formData)).called(1);
  });

  test('Should emit invalid field error if name is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    //Uses the value inside ".listen" and calls "expectAsyn1" with this value directly
    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit required field error if name is empty', () {
    mockValidation(value: ValidationError.requiredField);

    //Uses the value inside ".listen" and calls "expectAsyn1" with this value directly
    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null if name validation succeeds', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call Validation with correct password', () {
    final formData = {
      'name': null,
      'email': null,
      'password': password,
      'passwordConfirmation': null,
    };

    sut.validatePassword(password);

    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should emit invalid field error if password is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    //Uses the value inside ".listen" and calls "expectAsyn1" with this value directly
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit required field error if password is empty', () {
    mockValidation(value: ValidationError.requiredField);

    //Uses the value inside ".listen" and calls "expectAsyn1" with this value directly
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if password validation succeeds', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should call Validation with correct passwordConfirmation', () {
    final formData = {
      'name': null,
      'email': null,
      'password': null,
      'passwordConfirmation': passwordConfirmation,
    };

    sut.validatePasswordConfirmation(passwordConfirmation);

    verify(validation.validate(field: 'passwordConfirmation', input: formData))
        .called(1);
  });

  test('Should emit invalid field error if passwordConfirmation is invalid',
      () {
    mockValidation(value: ValidationError.invalidField);

    //Uses the value inside ".listen" and calls "expectAsyn1" with this value directly
    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit required field error if passwordConfirmation is empty', () {
    mockValidation(value: ValidationError.requiredField);

    //Uses the value inside ".listen" and calls "expectAsyn1" with this value directly
    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit null if passwordConfirmation validation succeeds', () {
    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
    await Future.delayed(Duration.zero);
  });

  test('Should call CreateAccount with correct values', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(createAccount.create(
      CreateAccountParams(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    )).called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(saveCurrentAccount.save(account)).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.signUp();
  });

  test('Should emit correct events on CreateAccount success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.signUp();
  });

  test('Should emit correct events on EmailInUseError', () async {
    mockCreateAccountError(DomainError.emailInUse);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.emailInUse]));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.signUp();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockCreateAccountError(DomainError.unexpected);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.signUp();
  });

  test('Should change page on success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    sut.navigateToStream.listen(
      expectAsync1((page) => expect(page, '/surveys')),
    );

    await sut.signUp();
  });

  test('Should go to LoginPage on link click', () async {
    sut.navigateToStream.listen(
      expectAsync1((page) => expect(page, '/login')),
    );

    sut.goToLogin();
  });
}
