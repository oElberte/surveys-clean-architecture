import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:surveys/data/usecases/save_current_account/save_current_account.dart';
import 'package:surveys/domain/helpers/helpers.dart';
import 'package:test/test.dart';

import 'package:surveys/domain/entities/entities.dart';

import '../../mocks/mocks.dart';

void main() {
  late LocalSaveCurrentAccount sut;
  late MockSaveSecureCacheStorage saveSecureCacheStorage;
  late AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = MockSaveSecureCacheStorage();
    sut = LocalSaveCurrentAccount(
      saveSecureCacheStorage: saveSecureCacheStorage,
    );
    account = AccountEntity(faker.guid.guid());
  });

  void mockError() => when(
        saveSecureCacheStorage.save(
          key: anyNamed('key'),
          value: anyNamed('value'),
        ),
      ).thenThrow(Exception());

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(saveSecureCacheStorage.save(key: 'token', value: account.token));
  });

  test('Should throw UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    mockError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
