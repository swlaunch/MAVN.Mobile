import 'package:lykke_mobile_mavn/feature_link_sme_account/bloc/sme_linking_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class SmeLinkingModule extends Module {
  SmeLinkingBloc get smeLinkingBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => SmeLinkingBloc(get(), get()));
  }
}
