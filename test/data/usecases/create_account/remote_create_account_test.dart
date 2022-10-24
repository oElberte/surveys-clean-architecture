import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:polls/domain/usecases/usecases.dart';

import 'package:polls/data/http/http.dart';
import 'package:polls/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteCreateAccount sut;
  HttpClientSpy httpClient;
  String url;
  CreateAccountParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteCreateAccount(
      httpClient: httpClient,
      url: url,
    );
    params = CreateAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password(),
    );
  });

  test('Should call HttpClient with correct values', () async {
    await sut.create(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'name': params.name,
        'email': params.email,
        'password': params.password,
        'passwordConfirmation': params.passwordConfirmation
      },
    ));
  });
}
