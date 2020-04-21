import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_response_model.dart';
import 'package:lykke_mobile_mavn/feature_vouchers/bloc/voucher_list_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockVoucherRepository = MockVoucherRepository();

BlocTester<VoucherListBloc> _blocTester =
    BlocTester(VoucherListBloc(_mockVoucherRepository));

VoucherListBloc _subject;

void main() {
  group('VoucherListBlocTests', () {
    setUp(() {
      reset(_mockVoucherRepository);
      _expectedFullBlocOutput.clear();

      _subject = VoucherListBloc(_mockVoucherRepository);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(GenericListUninitializedState());
    });
    const _initialPage = 1;
    final _voucherListResponseModel = VoucherListResponseModel(
        currentPage: TestConstants.stubCurrentPage,
        pageSize: TestConstants.stubPageSize,
        totalCount: TestConstants.stubTotalCount,
        vouchers: [
          VoucherResponseModel(),
        ]);

    test('get vouchers success', () async {
      when(
        _mockVoucherRepository.getVouchers(
          currentPage: anyNamed('currentPage'),
        ),
      ).thenAnswer((_) => Future.value(_voucherListResponseModel));

      await _subject.getList();

      verify(_mockVoucherRepository.getVouchers(currentPage: _initialPage))
          .called(1);

      _expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListLoadedState(
            totalCount: TestConstants.stubTotalCount,
            currentPage: TestConstants.stubCurrentPage,
            list: [..._voucherListResponseModel.vouchers])
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('get vouchers generic error', () async {
      when(_mockVoucherRepository.getVouchers(
        currentPage: anyNamed('currentPage'),
      )).thenThrow(Exception());

      await _subject.getList();

      _expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListErrorState<VoucherResponseModel>(
            error: LazyLocalizedStrings.defaultGenericError,
            currentPage: 1,
            list: []),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('get vouchers network error', () async {
      when(_mockVoucherRepository.getVouchers(
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
