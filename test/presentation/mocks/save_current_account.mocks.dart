// Mocks generated by Mockito 5.2.0 from annotations
// in surveys/test/presentation/presenters/getx_login_presenter_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:surveys/domain/entities/entities.dart' as _i4;
import 'package:surveys/domain/usecases/save_current_account.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [SaveCurrentAccount].
///
/// See the documentation for Mockito's code generation for more information.
class MockSaveCurrentAccount extends _i1.Mock
    implements _i2.SaveCurrentAccount {
  MockSaveCurrentAccount() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> save(_i4.AccountEntity? account) =>
      (super.noSuchMethod(Invocation.method(#save, [account]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
}
