import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:surveys/domain/helpers/helpers.dart';
import 'package:surveys/domain/entities/entities.dart';
import 'package:surveys/data/usecases/usecases.dart';
import 'package:surveys/data/http/http.dart';

import '../../../infra/mocks/mocks.dart';
import '../../../main/mocks/mocks.dart';

void main() {
  late RemoteLoadSurveyResult sut;
  late MockHttpClient httpClient;
  late String url;
  late Map surveyResult;
  late String surveyId;

  PostExpectation mockRequest() => when(
        httpClient.request(url: anyNamed('url'), method: anyNamed('method')),
      );

  void mockHttpData(Map data) {
    surveyResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    surveyId = faker.guid.guid();
    url = faker.internet.httpUrl();
    httpClient = MockHttpClient();
    sut = RemoteLoadSurveyResult(url: url, httpClient: httpClient);
    mockHttpData(ApiFactory.makeSurveyResultJson());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveyResult on 200', () async {
    final result = await sut.loadBySurvey(surveyId: surveyId);

    expect(
      result,
      SurveyResultEntity(
        surveyId: surveyResult['surveyId'],
        question: surveyResult['question'],
        answers: [
          SurveyAnswerEntity(
            image: surveyResult['answers'][0]['image'],
            answer: surveyResult['answers'][0]['answer'],
            isCurrentAnswer: surveyResult['answers'][0]
                ['isCurrentAccountAnswer'],
            percent: surveyResult['answers'][0]['percent'],
          ),
          SurveyAnswerEntity(
            image: surveyResult['answers'][1]['image'],
            answer: surveyResult['answers'][1]['answer'],
            isCurrentAnswer: surveyResult['answers'][1]
                ['isCurrentAccountAnswer'],
            percent: surveyResult['answers'][1]['percent'],
          ),
        ],
      ),
    );
  });

  test(
    'Should throw UnexpectedError if HttpClient returns 200 with invalid data',
    () async {
      mockHttpData(ApiFactory.makeInvalidJson());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbbiden);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });
}
