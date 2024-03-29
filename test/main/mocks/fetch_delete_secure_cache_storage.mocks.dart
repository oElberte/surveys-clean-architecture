// Mocks generated by Mockito 5.2.0 from annotations
// in surveys/test/main/decorators/authorize_http_client_decorator_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:surveys/data/cache/delete_secure_cache_storage.dart' as _i4;
import 'package:surveys/data/cache/fetch_secure_cache_storage.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [FetchSecureCacheStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockFetchSecureCacheStorage extends _i1.Mock
    implements _i2.FetchSecureCacheStorage {
  MockFetchSecureCacheStorage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<String?> fetch(String? key) =>
      (super.noSuchMethod(Invocation.method(#fetch, [key]),
          returnValue: Future<String?>.value()) as _i3.Future<String?>);
}

/// A class which mocks [DeleteSecureCacheStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeleteSecureCacheStorage extends _i1.Mock
    implements _i4.DeleteSecureCacheStorage {
  MockDeleteSecureCacheStorage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> delete(String? key) =>
      (super.noSuchMethod(Invocation.method(#delete, [key]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
}
