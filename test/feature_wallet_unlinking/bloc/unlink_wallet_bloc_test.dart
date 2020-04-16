import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/feature_wallet_unlinking/bloc/unlink_wallet_bloc.dart';
import 'package:mockito/mockito.dart';

import '../../mock_classes.dart';

void main() {
  group('UnlinkWalletBloc tests', () {
    final mockWalletRepository = MockWalletRepository();
    final mockExceptionToMessageMapper = MockExceptionToMessageMapper();

    UnlinkWalletBloc subject;

    setUp(() {
      subject =
          UnlinkWalletBloc(mockWalletRepository, mockExceptionToMessageMapper);
    });

    test('unlink request started', () async {
      await subject.unlinkExternalWallet();

      verify(mockWalletRepository.unlinkExternalWallet()).called(1);
    });
  });
}
