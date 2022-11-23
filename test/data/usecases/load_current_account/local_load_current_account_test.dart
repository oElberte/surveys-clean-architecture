import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:surveys/domain/helpers/helpers.dart';
import 'package:surveys/domain/entities/entities.dart';

import 'package:surveys/data/usecases/usecases.dart';

import '../../../main/mocks/mocks.dart';

void main() {
  late LocalLoadCurrentAccount sut;
  late MockFetchSecureCacheStorage fetchSecureCacheStorage;
  late String token;

  PostExpectation mockFetchSecureCall() =>
      when(fetchSecureCacheStorage.fetch(any));

  void mockFetchSecure(String? data) =>
      mockFetchSecureCall().thenAnswer((_) async => data);

  void mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception);

  setUp(() {
    fetchSecureCacheStorage = MockFetchSecureCacheStorage();
    sut = LocalLoadCurrentAccount(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
    );
    token = faker.guid.guid();
    mockFetchSecure(token);
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetch('token'));
  });

  test('Should return an AccountEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token));
  });

  test('Should throw UnexpectedError if FetchSecureCacheStorage throws',
      () async {
    mockFetchSecureError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if FetchSecureCacheStorage returns null',
      () async {
    mockFetchSecure(null);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
