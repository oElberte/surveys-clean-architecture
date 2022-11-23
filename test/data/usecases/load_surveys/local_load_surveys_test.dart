import 'package:mockito/mockito.dart';
import 'package:surveys/data/usecases/usecases.dart';
import 'package:surveys/domain/entities/entities.dart';
import 'package:surveys/domain/helpers/helpers.dart';
import 'package:test/test.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';

import '../../mocks/mocks.dart';

void main() {
  late LocalLoadSurveys sut;
  late MockCacheStorage cacheStorage;
  late List<Map> data;

  PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

  void mockFetch(List<Map> list) {
    data = list;
    mockFetchCall().thenAnswer((_) async => data);
  }

  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  setUp(() {
    cacheStorage = MockCacheStorage();
    sut = LocalLoadSurveys(
      cacheStorage: cacheStorage,
    );
    mockFetch(CacheFactory.makeSurveyList());
  });

  group('load', () {
    test('Should call CacheStorage with correct key', () async {
      await sut.load();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
          id: data[0]['id'],
          question: data[0]['question'],
          date: DateTime.utc(2022, 11, 14),
          didAnswer: false,
        ),
        SurveyEntity(
          id: data[1]['id'],
          question: data[1]['question'],
          date: DateTime.utc(2021, 02, 02),
          didAnswer: true,
        ),
      ]);
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch([]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch(CacheFactory.makeInvalidSurveyList());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(CacheFactory.makeIncompleteSurveyList());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      mockFetchError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('Should call cacheStorage with correct key', () async {
      await sut.validate();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if its invalid', () async {
      mockFetch(CacheFactory.makeInvalidSurveyList());

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if its incomplete', () async {
      mockFetch(CacheFactory.makeIncompleteSurveyList());

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if cacheStorage throws', () async {
      mockFetchError();

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    late List<SurveyEntity> surveys;

    PostExpectation mockSaveCall() => when(
        cacheStorage.save(key: anyNamed('key'), value: anyNamed('value')));

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      surveys = EntityFactory.makeSurveyList();
    });

    test('Should call cacheStorage with correct values', () async {
      final list = [
        {
          'id': surveys[0].id,
          'question': surveys[0].question,
          'date': '2022-02-02T00:00:00.000Z',
          'didAnswer': 'true',
        },
        {
          'id': surveys[1].id,
          'question': surveys[1].question,
          'date': '2020-12-20T00:00:00.000Z',
          'didAnswer': 'false',
        },
      ];

      await sut.save(surveys);

      verify(cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      mockSaveError();

      final future = sut.save(surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
