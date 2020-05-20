import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_details_bloc.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/response_model/voucher_details_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/voucher/voucher_repository.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/di/voucher_details_module.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

export 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_details_bloc_output.dart';

class VoucherDetailsBloc
    extends GenericDetailsBloc<VoucherDetailsResponseModel> {
  VoucherDetailsBloc(this._voucherRepository);

  final VoucherRepository _voucherRepository;

  @override
  Future<VoucherDetailsResponseModel> loadData(String identifier) =>
      _voucherRepository.getVoucherDetails(shortCode: identifier);
}

VoucherDetailsBloc useVoucherDetailsBloc() =>
    ModuleProvider.of<VoucherDetailsModule>(useContext()).voucherDetailsBloc;
