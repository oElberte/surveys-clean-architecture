import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:surveys/domain/helpers/helpers.dart';
import 'package:surveys/domain/entities/entities.dart';
import 'package:surveys/main/composites/composites.dart';

import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late MockRemoteLoadSurveys remote;
  late MockLocalLoadSurveys local;
  late List<SurveyEntity> remoteSurveys;
  late List<SurveyEntity> localSurveys;

  PostExpectation mockRemoteLoadCall() => when(remote.load());

  void mockRemoteLoad() {
    remoteSurveys = EntityFactory.makeSurveyList();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveys);
  }

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);

  PostExpectation mockLocalLoadCall() => when(local.load());

  void mockLocalLoad() {
    localSurveys = EntityFactory.makeSurveyList();
    mockLocalLoadCall().thenAnswer((_) async => localSurveys);
  }

  void mockLocalLoadError() =>
      mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    remote = MockRemoteLoadSurveys();
    local = MockLocalLoadSurveys();
    sut = RemoteLoadSurveysWithLocalFallback(
      remote: remote,
      local: local,
    );
    mockRemoteLoad();
    mockLocalLoad();
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();

    verify(local.save(remoteSurveys)).called(1);
  });

  test('Should return remote surveys', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);

    await sut.load();

    verify(local.validate()).called(1);
    verify(local.load()).called(1);
  });

  test('Should return local surveys', () async {
    mockRemoteLoadError(DomainError.unexpected);

    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });

  test('Should throw UnexpectedError if remote and local throws', () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
