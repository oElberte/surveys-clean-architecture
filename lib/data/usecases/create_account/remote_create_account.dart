import 'package:meta/meta.dart';

import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteCreateAccount {
  final HttpClient httpClient;
  final String url;

  RemoteCreateAccount({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> create(CreateAccountParams params) async {
    final body = RemoteCreateAccountParams.fromDomain(params).toJson();
    await httpClient.request(
      url: url,
      method: 'post',
      body: body,
    );
  }
}

class RemoteCreateAccountParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RemoteCreateAccountParams({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.passwordConfirmation,
  });

  factory RemoteCreateAccountParams.fromDomain(CreateAccountParams params) =>
      RemoteCreateAccountParams(
        name: params.name,
        email: params.email,
        password: params.password,
        passwordConfirmation: params.passwordConfirmation,
      );

  Map toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      };
}
