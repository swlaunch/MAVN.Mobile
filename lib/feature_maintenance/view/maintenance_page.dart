import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/maintenance/response_model/maintenance_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/token/token_repository.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_maintenance/bloc/maintenance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_maintenance/bloc/maintenance_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class MaintenancePage extends HookWidget {
  const MaintenancePage({@required this.maintenanceModel});

  final MaintenanceResponseModel maintenanceModel;

  @override
  Widget build(BuildContext context) {
    final maintenanceBloc = useMaintenanceBloc();
    final maintenanceState = useBlocState<MaintenanceState>(maintenanceBloc);
    final router = useRouter();

    useBlocEventListener(maintenanceBloc, (event) {
      if (event is MaintenanceCloseEvent) {
        useTokenRepository(context).deleteLoginToken();
        router.closeMaintenancePageAndNavigateToLogin();
      }
    });

    useEffect(() {
      maintenanceBloc.setInitialDurationPeriod(
          maintenanceModel.expectedRemainingDurationInMinutes);
    }, [maintenanceBloc]);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 112),
          child: Column(
            children: [
              SvgPicture.asset(
                SvgAssets.token,
                width: 64,
                height: 64,
              ),
              const SizedBox(height: 16),
              Text(
                useLocalizedStrings().maintenanceTitle,
                style: TextStyles.h1PageHeader,
              ),
              const SizedBox(height: 12),
              Text(
                _errorStateToDuration(maintenanceState),
                textAlign: TextAlign.center,
                style: TextStyles.darkBodyBody2Regular,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _errorStateToDuration(MaintenanceState state) {
    final period = state is MaintenanceErrorState
        ? state.remainingMaintenanceDuration.localize(useContext())
        : useLocalizedStrings().maintenanceErrorCoupleOfHours;

    return useLocalizedStrings().maintenanceDescription(period);
  }
}
