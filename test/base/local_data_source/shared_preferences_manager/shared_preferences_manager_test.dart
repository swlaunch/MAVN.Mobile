import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_manager.dart';
import 'package:mockito/mockito.dart';

import '../../../mock_classes.dart';

void main() {
  group('SharedPreferencesManager tests', () {
    final mockSharedPreferences = MockSharedPreferences();
    const stubKey = 'stubKey';
    const stubValue = '123';

    test('read', () async {
      when(mockSharedPreferences.getString('stubKey')).thenReturn(stubValue);

      final subject = SharedPreferencesManager(mockSharedPreferences);

      final readResult = subject.read(key: stubKey);

      expect(readResult, stubValue);
      expect(verify(mockSharedPreferences.getString(stubKey)).callCount, 1);
    });

    test('write', () async {
      final subject = SharedPreferencesManager(mockSharedPreferences);

      await subject.write(key: stubKey, value: stubValue);

      expect(
          verify(mockSharedPreferences.setString(stubKey, stubValue)).callCount,
          1);
    });
  });
}
