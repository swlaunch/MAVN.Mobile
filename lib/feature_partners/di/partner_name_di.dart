import 'package:lykke_mobile_mavn/feature_partners/bloc/partner_name_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class PartnerNameModule extends Module {
  PartnerNameBloc get partnerNameBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => PartnerNameBloc());
  }
}
