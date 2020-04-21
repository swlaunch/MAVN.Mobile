import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_details_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_details_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockPartnerRepository = MockPartnerRepository();

BlocTester<PaymentRequestDetailsBloc> _blocTester =
    BlocTester(PaymentRequestDetailsBloc(_mockPartnerRepository));

PaymentRequestDetailsBloc _subject;

void main() {
  group('PaymentRequestDetailsBlocTests', () {
    setUp(() {
      reset(_mockPartnerRepository);
      _expectedFullBlocOutput.clear();

      _subject = PaymentRequestDetailsBloc(_mockPartnerRepository);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(PaymentRequestDetailsUninitializedState());
    });

    test('getDetailsSuccess success', () async {
      when(_mockPartnerRepository.getPaymentRequestDetails(
        TestConstants.stubPaymentRequestId,
      )).thenAnswer((_) => Future.value(TestConstants.stubPaymentRequest));

      await _subject.getPaymentRequest(
          paymentRequestId: TestConstants.stubPaymentRequestId);

      verify(_mockPartnerRepository
              .getPaymentRequestDetails(TestConstants.stubPaymentRequestId))
          .called(1);

      _expectedFullBlocOutput.addAll([
        PaymentRequestDetailsUninitializedState(),
        PaymentRequestDetailsLoadingState(),
        PaymentRequestDetailsLoadedState(
            payment: TestConstants.stubPaymentRequest),
        PaymentRequestDetailsLoadedEvent(
            payment: TestConstants.stubPaymentRequest),
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('getPaymentRequest generic error', () async {
      when(_mockPartnerRepository.getPaymentRequestDetails(
        TestConstants.stubPaymentRequestId,
      )).thenThrow(Exception());

      await _subject.getPaymentRequest(
          paymentRequestId: TestConstants.stubPaymentRequestId);

      _expectedFullBlocOutput.addAll([
        PaymentRequestDetailsUninitializedState(),
        PaymentRequestDetailsLoadingState(),
        PaymentRequestDetailsErrorState(
          errorTitle: LazyLocalizedStrings.somethingIsNotRightError,
          errorSubtitle: LazyLocalizedStrings.transferRequestGenericError,
          iconAsset: SvgAssets.genericError,
        ),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('getPaymentRequestForm network error', () async {
      when(_mockPartnerRepository.getPaymentRequestDetails(
        TestConstants.stubPaymentRequestId,
      )).thenThrow(NetworkException());

      await _subject.getPaymentRequest(
        paymentRequestId: TestConstants.stubPaymentRequestId,
      );

      _expectedFullBlocOutput.addAll([
        PaymentRequestDetailsUninitializedState(),
        PaymentRequestDetailsLoadingState(),
        PaymentRequestDetailsErrorState(
          errorTitle: LazyLocalizedStrings.networkErrorTitle,
          errorSubtitle: LazyLocalizedStrings.networkError,
          iconAsset: SvgAssets.networkError,
        ),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
