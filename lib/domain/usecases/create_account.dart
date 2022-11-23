import 'package:equatable/equatable.dart';

import '../entities/entities.dart';

abstract class CreateAccount {
  Future<AccountEntity> create(CreateAccountParams params);
}

class CreateAccountParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  List<Object> get props => [name, email, password, passwordConfirmation];

  CreateAccountParams({
    required this.name,
    required this.passwordConfirmation,
    required this.email,
    required this.password,
  });
}
