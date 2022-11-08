import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';


CreateAccount makeRemoteCreateAccount() {
  return RemoteCreateAccount(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('signup'),
  );
}
