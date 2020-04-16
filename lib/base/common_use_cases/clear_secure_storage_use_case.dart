import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store.dart';

class ClearSecureStorageUseCase {
  ClearSecureStorageUseCase(this._secureStore);

  final SecureStore _secureStore;

  Future<void> execute() async => _secureStore.deleteAll();
}
