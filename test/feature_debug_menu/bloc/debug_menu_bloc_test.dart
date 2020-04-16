import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store_keys.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_manager.dart';
import 'package:lykke_mobile_mavn/feature_debug_menu/bloc/debug_menu_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';

const stubProxyUrl = 'stubProxyUrl';
const stubNewProxyUrl = 'stubNewProxyUrl';

SharedPreferencesManager _mockSharedPreferencesManager;
SecureStore _mockSecureStore;

List<BlocOutput> _expectedFullBlocOutput = [];

BlocTester<DebugMenuBloc> _blocTester;
DebugMenuBloc _subject;

void main() {
  group('DebugMenuBloc tests', () {
    setUpAll(() {
      _mockSharedPreferencesManager = MockSharedPreferencesManager();
      when(_mockSharedPreferencesManager.read(key: anyNamed('key')))
          .thenReturn(stubProxyUrl);

      _mockSecureStore = MockSecureStore();
    });

    setUp(() {
      _expectedFullBlocOutput.clear();

      _subject = DebugMenuBloc(_mockSharedPreferencesManager, _mockSecureStore);
      _blocTester = BlocTester(_subject);
    });

    test('initialState', () {
      _blocTester.assertCurrentState(DebugMenuState(proxyUrl: stubProxyUrl));
    });

    test('saveProxyUrl', () async {
      await _subject.saveProxyUrl(stubNewProxyUrl);

      _expectedFullBlocOutput.addAll([
        DebugMenuState(proxyUrl: stubProxyUrl),
        DebugMenuState(proxyUrl: stubNewProxyUrl)
      ]);

      verify(_mockSharedPreferencesManager.write(
              key: 'proxyUrl', value: stubNewProxyUrl))
          .called(1);
    });

    test('clearProxyUrl', () async {
      await _subject.clearProxyUrl();

      _expectedFullBlocOutput.addAll([
        DebugMenuState(proxyUrl: stubProxyUrl),
        DebugMenuState(proxyUrl: '')
      ]);

      verify(_mockSharedPreferencesManager.write(key: 'proxyUrl', value: ''))
          .called(1);
    });

    test('expireSession', () async {
      await _subject.expireSession();

      verify(_mockSecureStore.write(
              key: SecureStoreKeys.loginToken, value: 'invalidToken'))
          .called(1);
    });
  });
}
