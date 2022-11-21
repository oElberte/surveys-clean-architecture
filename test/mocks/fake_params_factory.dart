import 'package:faker/faker.dart';

import 'package:surveys/domain/usecases/usecases.dart';

class FakeParamsFactory {
  static CreateAccountParams makeCreateAccount() => CreateAccountParams(
        name: faker.person.name(),
        email: faker.internet.email(),
        password: faker.internet.password(),
        passwordConfirmation: faker.internet.password(),
      );

  static AuthenticationParams makeAuthentication() => AuthenticationParams(
        email: faker.internet.email(),
        password: faker.internet.password(),
      );
}
