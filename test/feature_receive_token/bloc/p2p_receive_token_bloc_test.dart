import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_receive_token/bloc/p2p_receive_token_bloc.dart';
import 'package:lykke_mobile_mavn/feature_receive_token/bloc/p2p_receive_token_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockCustomerRepository = MockCustomerRepository();
final _mockUserRepository = MockUserRepository();
BlocTester<P2pReceiveTokenBloc> _blocTester = BlocTester(
    P2pReceiveTokenBloc(_mockCustomerRepository, _mockUserRepository));

P2pReceiveTokenBloc _subject;

void main() {
  group('P2pReceiveTokenBlocTests', () {
    setUp(() {
      reset(_mockCustomerRepository);
      reset(_mockUserRepository);

      _expectedFullBlocOutput.clear();

      _subject =
          P2pReceiveTokenBloc(_mockCustomerRepository, _mockUserRepository);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(ReceiveTokenPageUninitializedState());
    });

    test('getCustomer success - loading from user repository', () async {
      when(_mockUserRepository.getCustomerEmail())
          .thenAnswer((_) => Future.value(TestConstants.stubEmail));

      await _subject.getCustomer();

      _expectedFullBlocOutput.addAll([
        ReceiveTokenPageUninitializedState(),
        ReceiveTokenPageLoadingState(),
        ReceiveTokenPageSuccess(TestConstants.stubEmail),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('getCustomer success - loading from customer repository', () async {
      when(_mockUserRepository.getCustomerEmail())
          .thenAnswer((_) => Future.value(null));

      when(_mockCustomerRepository.getCustomer())
          .thenAnswer((_) => Future.value(TestConstants.stubCustomer));
      await _subject.getCustomer();

      _expectedFullBlocOutput.addAll([
        ReceiveTokenPageUninitializedState(),
        ReceiveTokenPageLoadingState(),
        ReceiveTokenPageSuccess(TestConstants.stubCustomer.email),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('getCustomer connectivity error', () async {
      when(_mockUserRepository.getCustomerEmail())
          .thenAnswer((_) => Future.value(null));

      when(_mockCustomerRepository.getCustomer()).thenThrow(NetworkException());

      await _subject.getCustomer();

      _expectedFullBlocOutput.addAll([
        ReceiveTokenPageUninitializedState(),
        ReceiveTokenPageLoadingState(),
        ReceiveTokenPageErrorState(
            errorTitle: LazyLocalizedStrings.networkErrorTitle,
            errorSubtitle: LazyLocalizedStrings.networkError,
            iconAsset: SvgAssets.networkError),
      ]);
    });

    test('getCustomer generic error', () async {
      when(_mockUserRepository.getCustomerEmail())
          .thenAnswer((_) => Future.value(null));

      when(_mockCustomerRepository.getCustomer()).thenThrow(Exception());

      await _subject.getCustomer();

      _expectedFullBlocOutput.addAll([
        ReceiveTokenPageUninitializedState(),
        ReceiveTokenPageLoadingState(),
        ReceiveTokenPageErrorState(
            errorTitle: LazyLocalizedStrings.somethingIsNotRightError,
            errorSubtitle:
                LazyLocalizedStrings.receiveTokenPageGenericErrorSubtitle,
            iconAsset: SvgAssets.networkError),
      ]);
    });
  });
}
