import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:surveys/data/usecases/usecases.dart';
import 'package:surveys/domain/helpers/helpers.dart';
import 'package:test/test.dart';

import 'package:surveys/domain/entities/entities.dart';

import 'package:surveys/data/http/http.dart';

import '../../../infra/mocks/mocks.dart';
import '../../../main/mocks/mocks.dart';

void main() {
  late RemoteLoadSurveys sut;
  late MockHttpClient httpClient;
  late String url;
  late List<Map> list;

  PostExpectation mockRequest() => when(
        httpClient.request(url: anyNamed('url'), method: anyNamed('method')),
      );

  void mockHttpData(List<Map> data) {
    list = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = MockHttpClient();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    mockHttpData(ApiFactory.makeSurveyList());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveys on 200', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
        id: list[0]['id'],
        question: list[0]['question'],
        date: DateTime.parse(list[0]['date']),
        didAnswer: list[0]['didAnswer'],
      ),
      SurveyEntity(
        id: list[1]['id'],
        question: list[1]['question'],
        date: DateTime.parse(list[1]['date']),
        didAnswer: list[1]['didAnswer'],
      )
    ]);
  });

  test(
    'Should throw UnexpectedError if HttpClient returns 200 with invalid data',
    () async {
      mockHttpData(ApiFactory.makeInvalidList());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbbiden);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
