import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/bloc/voucher_purchase_success_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class VoucherPurchaseSuccessBloc extends Bloc<VoucherPurchaseSuccessState> {
  VoucherPurchaseSuccessBloc(
    this._localSettingsRepository,
  );

  final LocalSettingsRepository _localSettingsRepository;

  @override
  VoucherPurchaseSuccessState initialState() =>
      VoucherPurchaseSuccessUninitializedState();

  Future<void> storeFlag() async {
    await _localSettingsRepository.setBoughtVouchersFlag();
    sendEvent(VoucherPurchaseSuccessStoredKey());
  }

  bool hasBoughtVoucher() =>
      _localSettingsRepository.getBoughtVouchersFlag() != null;

  Future<void> seeVoucher() async {
    try {
      await _localSettingsRepository.removeBoughtVouchersFlag();

      setState(VoucherPurchaseSuccessSuccessState());
      sendEvent(VoucherPurchaseSuccessSuccessEvent());
    } on Exception {
      setState(VoucherPurchaseSuccessErrorState(
          error: LazyLocalizedStrings.somethingIsNotRightError));
    }
  }
}

VoucherPurchaseSuccessBloc useVoucherPurchaseSuccessBloc() =>
    ModuleProvider.of<AppModule>(useContext()).voucherPurchaseSuccessBloc;
