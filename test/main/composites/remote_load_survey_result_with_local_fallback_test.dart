import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:surveys/domain/entities/entities.dart';
import 'package:surveys/domain/helpers/helpers.dart';
import 'package:surveys/main/composites/composites.dart';

import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late MockRemoteLoadSurveyResult remote;
  late MockLocalLoadSurveyResult local;
  late String surveyId;
  late SurveyResultEntity remoteResult;
  late SurveyResultEntity localResult;

  PostExpectation mockRemoteLoadCall() =>
      when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockRemoteLoad() {
    remoteResult = EntityFactory.makeSurveyResult();
    when(mockRemoteLoadCall().thenAnswer((_) async => remoteResult));
  }

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);

  PostExpectation mockLocalLoadCall() =>
      when(local.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLocalLoad() {
    localResult = EntityFactory.makeSurveyResult();
    when(mockLocalLoadCall().thenAnswer((_) async => localResult));
  }

  void mockLocalLoadError() =>
      mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    surveyId = faker.guid.guid();
    remote = MockRemoteLoadSurveyResult();
    local = MockLocalLoadSurveyResult();
    sut = RemoteLoadSurveyResultWithLocalFallback(
      remote: remote,
      local: local,
    );
    mockRemoteLoad();
    mockLocalLoad();
  });

  test('Should call remote load', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(remoteResult)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteResult);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local load if remote load throws', () async {
    mockRemoteLoadError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.validate(surveyId)).called(1);
    verify(local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should return local data', () async {
    mockRemoteLoadError(DomainError.unexpected);

    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localResult);
  });

  test('Should throw UnexpectedError if local load fails', () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}
