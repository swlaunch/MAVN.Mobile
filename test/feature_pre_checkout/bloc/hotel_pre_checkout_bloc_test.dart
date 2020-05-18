import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_hotel_pre_checkout/bloc/hotel_pre_checkout_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockPartnerRepository = MockPartnerRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

BlocTester<HotelPreCheckoutBloc> _blocTester = BlocTester(HotelPreCheckoutBloc(
    _mockPartnerRepository, _mockExceptionToMessageMapper));

HotelPreCheckoutBloc _subject;

void main() {
  group('HotelPreCheckoutBlocTests', () {
    setUp(() {
      reset(_mockPartnerRepository);
      _expectedFullBlocOutput.clear();

      _subject = HotelPreCheckoutBloc(
          _mockPartnerRepository, _mockExceptionToMessageMapper);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(HotelPreCheckoutUninitializedState());
    });

    test('getPaymentRequest success', () async {
      when(_mockPartnerRepository.getPaymentRequestDetails(
        TestConstants.stubPaymentRequestId,
      )).thenAnswer((_) => Future.value(TestConstants.stubPaymentRequest));

      await _subject.getHotelPreCheckoutDetails(
        TestConstants.stubPaymentRequestId,
      );

      expect(
        verify(_mockPartnerRepository.getPaymentRequestDetails(
          TestConstants.stubPaymentRequestId,
        )).callCount,
        1,
      );

      _expectedFullBlocOutput.addAll([
        HotelPreCheckoutUninitializedState(),
        HotelPreCheckoutLoadingState(),
        HotelPreCheckoutLoadedState(
          partnerName: TestConstants.stubPaymentRequest.partnerName,
          message: TestConstants.stubPaymentRequest.paymentInfo,
        )
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('getPaymentRequest generic error', () async {
      when(_mockPartnerRepository.getPaymentRequestDetails(
        TestConstants.stubPaymentRequestId,
      )).thenThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await _subject.getHotelPreCheckoutDetails(
        TestConstants.stubPaymentRequestId,
      );

      _expectedFullBlocOutput.addAll([
        HotelPreCheckoutUninitializedState(),
        HotelPreCheckoutLoadingState(),
        HotelPreCheckoutErrorState(LazyLocalizedStrings.defaultGenericError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('getPaymentRequest network error', () async {
      when(_mockPartnerRepository.getPaymentRequestDetails(
        TestConstants.stubPaymentRequestId,
      )).thenThrow(NetworkException());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.networkError);

      await _subject.getHotelPreCheckoutDetails(
        TestConstants.stubPaymentRequestId,
      );

      _expectedFullBlocOutput.addAll([
        HotelPreCheckoutUninitializedState(),
        HotelPreCheckoutLoadingState(),
        HotelPreCheckoutErrorState(LazyLocalizedStrings.networkError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
