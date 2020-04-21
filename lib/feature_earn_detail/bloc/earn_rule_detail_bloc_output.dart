import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:meta/meta.dart';

abstract class EarnRuleDetailState extends BaseState {}

class EarnRuleDetailUninitializedState extends EarnRuleDetailState {}

class EarnRuleDetailLoadingState extends EarnRuleDetailState {}

class EarnRuleDetailErrorState extends EarnRuleDetailState {
  EarnRuleDetailErrorState({
    @required this.errorTitle,
    @required this.errorSubtitle,
    @required this.iconAsset,
  });

  final LocalizedStringBuilder errorTitle;
  final LocalizedStringBuilder errorSubtitle;
  final String iconAsset;

  @override
  List get props => super.props..addAll([errorTitle, errorSubtitle, iconAsset]);
}

class EarnRuleDetailNetworkErrorState extends EarnRuleDetailState
    with BaseNetworkErrorState {}

class EarnRuleDetailLoadedState extends EarnRuleDetailState {
  EarnRuleDetailLoadedState({@required this.earnRuleDetail});

  final ExtendedEarnRule earnRuleDetail;
}
