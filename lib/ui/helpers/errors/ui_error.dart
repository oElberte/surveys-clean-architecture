enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return 'Required field.';
      case UIError.invalidField:
        return 'Invalid field.';
      case UIError.invalidCredentials:
        return 'Invalid credentials.';
      default:
        return 'Something wrong happened. Try again later.';
    }
  }
}
