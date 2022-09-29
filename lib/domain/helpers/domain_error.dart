enum DomainError {
  unexpected,
  invalidCredentials,
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'Invalid credentials.';
      default:
        return 'Something wrong happened. Try again later.';
    }
  }
}
