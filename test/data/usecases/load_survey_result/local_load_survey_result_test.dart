import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:surveys/data/usecases/usecases.dart';
import 'package:surveys/domain/entities/entities.dart';
import 'package:surveys/domain/helpers/helpers.dart';
import 'package:test/test.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';

import '../../mocks/mocks.dart';

void main() {
  late LocalLoadSurveyResult sut;
  late MockCacheStorage cacheStorage;
  late Map data;
  late String surveyId;

  PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

  void mockFetch(Map json) {
    data = json;
    mockFetchCall().thenAnswer((_) async => data);
  }

  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  setUp(() {
      surveyId = faker.guid.guid();
      cacheStorage = MockCacheStorage();
      sut = LocalLoadSurveyResult(
        cacheStorage: cacheStorage,
      );
      mockFetch(CacheFactory.makeSurveyResult());
    });

  group('loadBySurvey', () {
    test('Should call CacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should return surveyResult on success', () async {
      final surveyResult = await sut.loadBySurvey(surveyId: surveyId);

      expect(
        surveyResult,
        SurveyResultEntity(
          surveyId: data['surveyId'],
          question: data['question'],
          answers: [
            SurveyAnswerEntity(
              image: data['answers'][0]['image'],
              answer: data['answers'][0]['answer'],
              isCurrentAnswer: true,
              percent: 40,
            ),
            SurveyAnswerEntity(
              answer: data['answers'][1]['answer'],
              isCurrentAnswer: false,
              percent: 60,
            ),
          ],
        ),
      );
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch({});

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch(CacheFactory.makeInvalidSurveyResult());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(CacheFactory.makeIncompleteSurveyResult());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('Should call cacheStorage with correct key', () async {
      await sut.validate(surveyId);

      verify(cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if its invalid', () async {
      mockFetch(CacheFactory.makeInvalidSurveyResult());

      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if its incomplete', () async {
      mockFetch(CacheFactory.makeIncompleteSurveyResult());

      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if cacheStorage throws', () async {
      mockFetchError();

      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
    late SurveyResultEntity surveyResult;

    PostExpectation mockSaveCall() => when(cacheStorage.save(
          key: anyNamed('key'),
          value: anyNamed('value'),
        ));

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      surveyResult = EntityFactory.makeSurveyResult();
    });

    test('Should call cacheStorage with correct values', () async {
      Map json = {
        'surveyId': surveyResult.surveyId,
        'question': surveyResult.question,
        'answers': [
          {
            'image': surveyResult.answers[0].image,
            'answer': surveyResult.answers[0].answer,
            'percent': '40',
            'isCurrentAnswer': 'true',
          },
          {
            'image': null,
            'answer': surveyResult.answers[1].answer,
            'percent': '60',
            'isCurrentAnswer': 'false',
          },
        ],
      };

      await sut.save(surveyResult);

      verify(cacheStorage.save(
          key: 'survey_result/${surveyResult.surveyId}',
          value: json)).called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      mockSaveError();

      final future = sut.save(surveyResult);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
