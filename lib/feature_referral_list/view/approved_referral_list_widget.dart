import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/bloc/completed_referral_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/view/referral_list_widget.dart';

class ApprovedReferralListWidget extends HookWidget {
  @override
  Widget build(BuildContext context) => ReferralListWidget(
        useBloc: () => useCompletedReferralListBloc(),
        emptyStateText: useLocalizedStrings().approvedReferralListEmptyState,
      );
}
