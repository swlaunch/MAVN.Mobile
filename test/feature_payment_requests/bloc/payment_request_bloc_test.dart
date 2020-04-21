import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockPartnerRepository = MockPartnerRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

BlocTester<PaymentRequestBloc> _blocTester = BlocTester(
    PaymentRequestBloc(_mockPartnerRepository, _mockExceptionToMessageMapper));

PaymentRequestBloc _subject;

void main() {
  group('PaymentRequestBlocTests', () {
    setUp(() {
      reset(_mockPartnerRepository);
      _expectedFullBlocOutput.clear();

      _subject = PaymentRequestBloc(
          _mockPartnerRepository, _mockExceptionToMessageMapper);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(PaymentRequestUninitializedState());
    });

    group('Approval tests', () {
      test('approve request success', () async {
        when(_mockPartnerRepository.approvePayment(
                paymentRequestId: TestConstants.stubPaymentRequestId,
                sendingAmount: TestConstants.stubPaymentRequestTotalInToken))
            .thenAnswer((_) => Future.value());

        await _subject.approvePaymentRequest(
            paymentRequestId: TestConstants.stubPaymentRequestId,
            sendingAmount: TestConstants.stubPaymentRequestTotalInTokenDouble);

        verify(_mockPartnerRepository.approvePayment(
                paymentRequestId: TestConstants.stubPaymentRequestId,
                sendingAmount:
                    TestConstants.stubPaymentRequestTotalInTokenDouble))
            .called(1);

        _expectedFullBlocOutput.addAll([
          PaymentRequestUninitializedState(),
          PaymentRequestLoadingState(),
          PaymentRequestApprovedSuccessEvent()
        ]);

        await _blocTester
            .assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
      });

      test('approve request generic error', () async {
        when(_mockPartnerRepository.approvePayment(
                paymentRequestId: TestConstants.stubPaymentRequestId,
                sendingAmount:
                    TestConstants.stubPaymentRequestTotalInTokenDouble))
            .thenThrow(Exception());

        await _subject.approvePaymentRequest(
            paymentRequestId: TestConstants.stubPaymentRequestId,
            sendingAmount: TestConstants.stubPaymentRequestTotalInTokenDouble);

        _expectedFullBlocOutput.addAll([
          PaymentRequestUninitializedState(),
          PaymentRequestLoadingState(),
          PaymentRequestErrorState(
            errorTitle: LazyLocalizedStrings.somethingIsNotRightError,
            errorSubtitle: LazyLocalizedStrings.transferRequestGenericError,
            iconAsset: SvgAssets.genericError,
          ),
        ]);

        await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
      });

      test('approve request network error', () async {
        when(_mockPartnerRepository.approvePayment(
                paymentRequestId: TestConstants.stubPaymentRequestId,
                sendingAmount:
                    TestConstants.stubPaymentRequestTotalInTokenDouble))
            .thenThrow(NetworkException());

        await _subject.approvePaymentRequest(
            paymentRequestId: TestConstants.stubPaymentRequestId,
            sendingAmount: TestConstants.stubPaymentRequestTotalInTokenDouble);

        _expectedFullBlocOutput.addAll([
          PaymentRequestUninitializedState(),
          PaymentRequestLoadingState(),
          PaymentRequestErrorState(
            errorTitle: LazyLocalizedStrings.networkErrorTitle,
            errorSubtitle: LazyLocalizedStrings.networkError,
            iconAsset: SvgAssets.networkError,
          ),
        ]);

        await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
      });

      test('approve request CustomerWalletBlocked error', () async {
        when(_mockPartnerRepository.approvePayment(
                paymentRequestId: TestConstants.stubPaymentRequestId,
                sendingAmount:
                    TestConstants.stubPaymentRequestTotalInTokenDouble))
            .thenThrow(const ServiceException(
                ServiceExceptionType.customerWalletBlocked,
                message: TestConstants.stubErrorText));

        when(_mockExceptionToMessageMapper.map(any)).thenReturn(
            LocalizedStringBuilder.custom(TestConstants.stubErrorText));

        await _subject.approvePaymentRequest(
            paymentRequestId: TestConstants.stubPaymentRequestId,
            sendingAmount: TestConstants.stubPaymentRequestTotalInTokenDouble);

        _expectedFullBlocOutput.addAll([
          PaymentRequestUninitializedState(),
          PaymentRequestLoadingState(),
          PaymentRequestWalletDisabledEvent(),
          PaymentRequestInlineErrorState(
              error:
                  LocalizedStringBuilder.custom(TestConstants.stubErrorText)),
        ]);

        await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
      });

      test('approve request InvalidAmount error', () async {
        when(_mockPartnerRepository.approvePayment(
                paymentRequestId: TestConstants.stubPaymentRequestId,
                sendingAmount:
                    TestConstants.stubPaymentRequestTotalInTokenDouble))
            .thenThrow(const ServiceException(
                ServiceExceptionType.invalidAmount,
                message: TestConstants.stubErrorText));

        when(_mockExceptionToMessageMapper.map(any))
            .thenReturn(LazyLocalizedStrings.invalidAmountError);

        await _subject.approvePaymentRequest(
            paymentRequestId: TestConstants.stubPaymentRequestId,
            sendingAmount: TestConstants.stubPaymentRequestTotalInTokenDouble);

        _expectedFullBlocOutput.addAll([
          PaymentRequestUninitializedState(),
          PaymentRequestLoadingState(),
          PaymentRequestInlineErrorState(
              error: LazyLocalizedStrings.invalidAmountError),
        ]);

        await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
      });

      test('approve request PaymentIsNotInACorrectStatusToBeUpdated error',
          () async {
        when(_mockPartnerRepository.approvePayment(
                paymentRequestId: TestConstants.stubPaymentRequestId,
                sendingAmount:
                    TestConstants.stubPaymentRequestTotalInTokenDouble))
            .thenThrow(const ServiceException(
                ServiceExceptionType.paymentIsNotInACorrectStatusToBeUpdated,
                message: TestConstants.stubErrorText));

        when(_mockExceptionToMessageMapper.map(any))
            .thenReturn(LazyLocalizedStrings.transferRequestInvalidStateError);

        await _subject.approvePaymentRequest(
            paymentRequestId: TestConstants.stubPaymentRequestId,
            sendingAmount: TestConstants.stubPaymentRequestTotalInTokenDouble);

        _expectedFullBlocOutput.addAll([
          PaymentRequestUninitializedState(),
          PaymentRequestLoadingState(),
          PaymentRequestExpiredEvent(),
          PaymentRequestInlineErrorState(
              error: LazyLocalizedStrings.transferRequestInvalidStateError),
        ]);

        await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
      });

      test('approve request NotEnoughTokens error', () async {
        when(_mockPartnerRepository.approvePayment(
                paymentRequestId: TestConstants.stubPaymentRequestId,
                sendingAmount:
                    TestConstants.stubPaymentRequestTotalInTokenDouble))
            .thenThrow(const ServiceException(
                ServiceExceptionType.notEnoughTokens,
                message: TestConstants.stubErrorText));

        when(_mockExceptionToMessageMapper.map(any)).thenReturn(
            LazyLocalizedStrings.transferRequestNotEnoughTokensError);

        await _subject.approvePaymentRequest(
            paymentRequestId: TestConstants.stubPaymentRequestId,
            sendingAmount: TestConstants.stubPaymentRequestTotalInTokenDouble);

        _expectedFullBlocOutput.addAll([
          PaymentRequestUninitializedState(),
          PaymentRequestLoadingState(),
          PaymentRequestInlineErrorState(
              error: LazyLocalizedStrings.transferRequestNotEnoughTokensError),
        ]);

        await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
      });
    });
    group('Rejection tests', () {
      test('reject request success', () async {
        when(_mockPartnerRepository.rejectPayment(
          paymentRequestId: TestConstants.stubPaymentRequestId,
        )).thenAnswer((_) => Future.value());

        await _subject.rejectPaymentRequest(
            paymentRequestId: TestConstants.stubPaymentRequestId);

        verify(_mockPartnerRepository.rejectPayment(
          paymentRequestId: TestConstants.stubPaymentRequestId,
        )).called(1);

        _expectedFullBlocOutput.addAll([
          PaymentRequestUninitializedState(),
          PaymentRequestLoadingState(),
          PaymentRequestRejectedSuccessEvent()
        ]);

        await _blocTester
            .assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
      });

      test('reject request generic error', () async {
        when(_mockPartnerRepository.rejectPayment(
          paymentRequestId: TestConstants.stubPaymentRequestId,
        )).thenThrow(Exception());

        await _subject.rejectPaymentRequest(
          paymentRequestId: TestConstants.stubPaymentRequestId,
        );
        _expectedFullBlocOutput.addAll([
          PaymentRequestUninitializedState(),
          PaymentRequestLoadingState(),
          PaymentRequestErrorState(
            errorTitle: LazyLocalizedStrings.somethingIsNotRightError,
            errorSubtitle: LazyLocalizedStrings.transferRequestGenericError,
            iconAsset: SvgAssets.genericError,
          ),
        ]);

        await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
      });

      test('reject request network error', () async {
        when(_mockPartnerRepository.rejectPayment(
          paymentRequestId: TestConstants.stubPaymentRequestId,
        )).thenThrow(NetworkException());

        await _subject.rejectPaymentRequest(
          paymentRequestId: TestConstants.stubPaymentRequestId,
        );
        _expectedFullBlocOutput.addAll([
          PaymentRequestUninitializedState(),
          PaymentRequestLoadingState(),
          PaymentRequestErrorState(
            errorTitle: LazyLocalizedStrings.networkErrorTitle,
            errorSubtitle: LazyLocalizedStrings.networkError,
            iconAsset: SvgAssets.networkError,
          ),
        ]);

        await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
      });

      test('reject request InvalidAmount error', () async {
        when(_mockPartnerRepository.rejectPayment(
          paymentRequestId: TestConstants.stubPaymentRequestId,
        )).thenThrow(const ServiceException(ServiceExceptionType.invalidAmount,
            message: TestConstants.stubErrorText));

        when(_mockExceptionToMessageMapper.map(any))
            .thenReturn(LazyLocalizedStrings.invalidAmountError);

        await _subject.rejectPaymentRequest(
          paymentRequestId: TestConstants.stubPaymentRequestId,
        );
        _expectedFullBlocOutput.addAll([
          PaymentRequestUninitializedState(),
          PaymentRequestLoadingState(),
          PaymentRequestInlineErrorState(
              error: LazyLocalizedStrings.invalidAmountError),
        ]);

        await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
      });
    });
  });
}
