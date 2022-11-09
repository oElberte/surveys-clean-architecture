import 'strings.dart';

class EnUs implements Translations {
  String get msgInvalidField => 'Invalid field.';
  String get msgEmailInUse => 'Email already in use.';
  String get msgInvalidCredentials => 'Invalid credentials.';
  String get msgRequiredField => 'Required field.';
  String get msgUnexpected => 'Something wrong happened. Try again later.';

  String get name => 'Name';
  String get createAccount => 'Create account';
  String get email => 'Email';
  String get login => 'Login';
  String get password => 'Password';
  String get confirmPassword => 'Confirm password';
  String get surveys => 'Surveys';
}
