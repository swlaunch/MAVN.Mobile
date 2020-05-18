import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/mapper/referral_to_ui_model_mapper.dart';
import 'package:lykke_mobile_mavn/feature_referral_list/bloc/referral_list_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/state_handled_list_view.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/previous_referrals_widget.dart';

typedef UseBlocFunction = ReferralListBloc Function();

class ReferralListWidget extends HookWidget {
  const ReferralListWidget({
    this.useBloc,
    this.emptyStateText,
    Key key,
  }) : super(key: key);
  final UseBlocFunction useBloc;
  final String emptyStateText;

  @override
  Widget build(BuildContext context) {
    final referralListBloc = useBloc();
    final referralListBlocState = useBlocState(referralListBloc);
    final referralMapper = useReferralMapper();

    final data = useState(<CustomerCommonReferralResponseModel>[]);
    final isErrorDismissed = useState(false);

    void loadData() {
      isErrorDismissed.value = false;
      referralListBloc.getList();
    }

    void loadInitialData() {
      isErrorDismissed.value = false;
      referralListBloc.updateGenericList();
    }

    useEffect(() {
      loadInitialData();
    }, [referralListBloc]);

    if (referralListBlocState is GenericListLoadedState) {
      data.value = referralListBlocState.list;
    }

    return Stack(
      children: [
        RefreshIndicator(
          color: ColorStyles.gold1,
          onRefresh: () async =>
              referralListBloc.updateGenericList(refresh: true),
          child: StateHandledListWidget(
            data: data.value,
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: ColorStyles.offWhite,
            isInitiallyLoading:
                referralListBlocState is GenericListLoadingState,
            isLoading:
                referralListBlocState is GenericListPaginationLoadingState,
            isEmpty: referralListBlocState is GenericListEmptyState,
            emptyText: emptyStateText,
            emptyIcon: SvgAssets.referrals,
            retryOnError: loadData,
            showError: referralListBlocState is GenericListErrorState,
            errorText: referralListBlocState is GenericListErrorState
                ? referralListBlocState.error.localize(useContext())
                : null,
            itemBuilder: (item, _) => PreviousReferralsWidget(
                referral: referralMapper.previousReferralsFromReferral(item)),
            separatorBuilder: (position) => const SizedBox(height: 24),
          ),
        ),
      ],
    );
  }
}
