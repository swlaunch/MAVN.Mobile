import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/date/date_time_manager.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/real_estate_properties_response_model.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/bloc/instalment_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/di/real_estate_property_module.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/utility_model/extended_instalment_model.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class InstalmentListBloc extends Bloc<InstalmentListState> {
  InstalmentListBloc(this._dateTimeManager);

  final DateTimeManager _dateTimeManager;

  @override
  InstalmentListState initialState() => InstalmentListUninitializedState();

  Future<void> mapInstalments(List<Instalment> propertyInstalments) async {
    setState(InstalmentListLoadingState());

    try {
      final now = DateTime.now();
      final extendedInstalmentList = propertyInstalments.map((instalment) {
        final localDueDate = _dateTimeManager.toLocal(instalment.dueDate);
        return ExtendedInstalmentModel(
          instalment: instalment,
          isOverdue: localDueDate.isBefore(now),
          localDueDate: localDueDate,
          formattedDate: _dateTimeManager.formatShortBasedOnYear(localDueDate),
        );
      }).toList();

      setState(
        InstalmentListLoadedState(
          extendedInstalments: extendedInstalmentList,
        ),
      );
    } on Exception {
      setState(InstalmentListLoadedState(extendedInstalments: []));
    }
  }
}

InstalmentListBloc useInstalmentListBloc() =>
    ModuleProvider.of<RealEstatePropertyModule>(useContext())
        .instalmentListBloc;
