import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/feature_partners/bloc/partner_name_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_partners/di/partner_name_di.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PartnerNameBloc extends Bloc<PartnerNameState> {
  @override
  PartnerNameState initialState() => PartnerNameUninitializedState();

  Future<void> getPartnerName({ExtendedEarnRule extendedEarnRule}) async {
    final partnerName = (extendedEarnRule?.conditions?.isNotEmpty ?? false)
        ? extendedEarnRule?.conditions?.first?.partners
            ?.firstWhere((partner) => partner != null, orElse: () => null)
            ?.name
        : null;

    if (partnerName != null) {
      setState(PartnerNameLoadedState(partnerName: partnerName));
    }
  }
}

PartnerNameBloc usePartnerNameBloc() =>
    ModuleProvider.of<PartnerNameModule>(useContext()).partnerNameBloc;
