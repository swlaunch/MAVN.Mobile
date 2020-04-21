import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payment_request_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payments_response_model.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/failed_payment_requests_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/partner_payments_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockPartnerRepository = MockPartnerRepository();

BlocTester<PartnerPaymentsBloc> _blocTester =
    BlocTester(FailedPartnerPaymentsBloc(_mockPartnerRepository));

PartnerPaymentsBloc _subject;

void main() {
  group('PaginatedPartnerPaymentsBlocTests', () {
    setUp(() {
      reset(_mockPartnerRepository);
      _expectedFullBlocOutput.clear();

      _subject = FailedPartnerPaymentsBloc(_mockPartnerRepository);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(GenericListUninitializedState());
    });
    const _initialPage = 1;
    final _paginatedPartnerPaymentsResponseModel =
        PaginatedPartnerPaymentsResponseModel(
            currentPage: TestConstants.stubCurrentPage,
            pageSize: TestConstants.stubPageSize,
            totalCount: TestConstants.stubTotalCount,
            paymentRequests: [
          TestConstants.stubPaymentRequest,
        ]);

    test('get payments success', () async {
      when(
        _mockPartnerRepository.getFailedPayments(
          currentPage: anyNamed('currentPage'),
        ),
      ).thenAnswer((_) => Future.value(_paginatedPartnerPaymentsResponseModel));

      await _subject.getList();

      verify(_mockPartnerRepository.getFailedPayments(
              currentPage: _initialPage))
          .called(1);

      _expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListLoadedState<PaymentRequestResponseModel>(
          currentPage: TestConstants.stubCurrentPage,
          list: [
            TestConstants.stubPaymentRequest,
          ],
          totalCount: TestConstants.stubTotalCount,
        )
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('get payments generic error', () async {
      when(_mockPartnerRepository.getFailedPayments(
        currentPage: anyNamed('currentPage'),
      )).thenThrow(Exception());

      await _subject.getList();

      _expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListErrorState<PaymentRequestResponseModel>(
            error: LazyLocalizedStrings.transferRequestListGenericError,
            currentPage: 1,
            list: []),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('get payments network error', () async {
      when(_mockPartnerRepository.getFailedPayments(
        currentPage: anyNamed('currentPage'),
      )).thenThrow(NetworkException());

      await _subject.getList();

      _expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListNetworkErrorState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
