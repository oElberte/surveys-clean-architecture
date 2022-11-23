import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:surveys/domain/helpers/helpers.dart';
import 'package:surveys/domain/usecases/usecases.dart';
import 'package:surveys/data/http/http.dart';
import 'package:surveys/data/usecases/usecases.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../../main/mocks/mocks.dart';

void main() {
  late RemoteCreateAccount sut;
  late MockHttpClient httpClient;
  late String url;
  late CreateAccountParams params;
  late Map apiResult;

  PostExpectation mockRequest() {
    return when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    );
  }

  void mockHttpData(Map data) {
    apiResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteCreateAccount(
      httpClient: httpClient,
      url: url,
    );
    params = ParamsFactory.makeCreateAccount();
    mockHttpData(ApiFactory.makeAccountJson());
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

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.create(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.create(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.create(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 403',
      () async {
    mockHttpError(HttpError.forbbiden);

    final future = sut.create(params);

    expect(future, throwsA(DomainError.emailInUse));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final account = await sut.create(params);

    expect(account.token, apiResult['accessToken']);
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.create(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
