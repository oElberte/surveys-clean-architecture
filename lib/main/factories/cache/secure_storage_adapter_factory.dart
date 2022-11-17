import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../infra/cache/secure_storage_adapter.dart';

SecureStorageAdapter makeSecureStorageAdapter() {
  return SecureStorageAdapter(secureStorage: FlutterSecureStorage());
}
