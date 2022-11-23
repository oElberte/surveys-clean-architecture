import 'package:mockito/mockito.dart';
import 'package:surveys/domain/entities/entities.dart';
import 'package:surveys/presentation/presenters/presenters.dart';
import 'package:test/test.dart';

import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxSplashPresenter sut;
  late MockLoadCurrentAccount loadCurrentAccount;

  PostExpectation mockLoadCurrentAccountCall() => when(loadCurrentAccount.load());

  void mockLoadCurrentAccount(AccountEntity account) =>
      mockLoadCurrentAccountCall().thenAnswer((_) async => account);

  void mockLoadCurrentAccountError() =>
      mockLoadCurrentAccountCall().thenThrow(Exception());

  setUp(() {
    loadCurrentAccount = MockLoadCurrentAccount();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(EntityFactory.makeAccount());
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.checkAccount();

    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream.listen(
      expectAsync1((page) => expect(page, '/surveys')),
    );

    await sut.checkAccount(durationInSeconds: 0);
  });

  test('Should go to login page on error', () async {
    mockLoadCurrentAccountError();

    sut.navigateToStream.listen(
      expectAsync1((page) => expect(page, '/login')),
    );

    await sut.checkAccount(durationInSeconds: 0);
  });
}
