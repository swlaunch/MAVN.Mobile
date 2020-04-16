import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/spend/spend_repository.dart';
import 'package:lykke_mobile_mavn/feature_spend/bloc/voucher_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_spend/di/spend_rule_detail_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class VoucherPurchaseBloc extends Bloc<VoucherPurchaseState> {
  VoucherPurchaseBloc(this._spendRepository, this._exceptionToMessageMapper);

  final SpendRepository _spendRepository;
  final ExceptionToMessageMapper _exceptionToMessageMapper;

  @override
  VoucherPurchaseState initialState() => VoucherPurchaseUninitializedState();

  Future<void> purchaseVoucher({@required String spendRuleId}) async {
    setState(VoucherPurchaseInProgressState());
    try {
      final purchaseVoucherResponse =
          await _spendRepository.purchaseVoucher(spendRuleId: spendRuleId);

      sendEvent(
        VoucherPurchaseSuccessEvent(
          voucherCode: purchaseVoucherResponse.voucherCode,
        ),
      );
    } on Exception catch (e) {
      setState(
          VoucherPurchaseErrorState(error: _exceptionToMessageMapper.map(e)));
    }
  }
}

VoucherPurchaseBloc useVoucherPurchaseBloc() =>
    ModuleProvider.of<SpendRuleDetailModule>(useContext()).voucherPurchaseBloc;
