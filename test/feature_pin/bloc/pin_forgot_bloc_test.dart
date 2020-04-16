import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_keys.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_forgot_bloc.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';

PinForgotBloc _subject;
final _mockSecureStore = MockSecureStore();
final _mockSharedPreferencesManager = MockSharedPreferencesManager();

void main() {
  setUp(() {
    reset(_mockSecureStore);
    reset(_mockSharedPreferencesManager);
    _subject = PinForgotBloc(_mockSharedPreferencesManager);
  });

  test('resetPinPassCode', () async {
    await _subject.resetPinPassCode();

    verify(_mockSharedPreferencesManager.writeBool(
            key: SharedPreferencesKeys.forgottenPin, value: true))
        .called(1);
  });
}
