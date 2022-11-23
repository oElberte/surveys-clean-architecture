import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:surveys/domain/entities/entities.dart';
import 'package:surveys/domain/helpers/helpers.dart';
import 'package:surveys/data/usecases/usecases.dart';
import 'package:surveys/data/http/http.dart';

import '../../../infra/mocks/mocks.dart';
import '../../../main/mocks/mocks.dart';

void main() {
  late RemoteSaveSurveyResult sut;
  late MockHttpClient httpClient;
  late String url;
  late String answer;
  late Map surveyResult;

  PostExpectation mockRequest() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ));

  void mockHttpData(Map data) {
    surveyResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    answer = faker.lorem.sentence();
    url = faker.internet.httpUrl();
    httpClient = MockHttpClient();
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);
    mockHttpData(ApiFactory.makeSurveyResultJson());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.save(answer: answer);

    verify(httpClient.request(
      url: url,
      method: 'put',
      body: {'answer': answer},
    ));
  });

  test('Should return surveyResult on 200', () async {
    final result = await sut.save(answer: answer);

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

      final future = sut.save(answer: answer);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbbiden);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.accessDenied));
  });
}
