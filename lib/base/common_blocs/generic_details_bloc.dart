import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

import 'generic_details_bloc_state.dart';

export 'package:lykke_mobile_mavn/feature_payment_request/bloc/payment_request_details_bloc_output.dart';

abstract class GenericDetailsBloc<T> extends Bloc<GenericDetailsState> {
  @override
  GenericDetailsState initialState() => GenericDetailsUninitializedState();

  Future<void> getDetails({@required String identifier}) async {
    setState(GenericDetailsLoadingState());

    try {
      final response = await loadData(identifier);
      setState(GenericDetailsLoadedState(details: response));
    } on Exception catch (e) {
      setState(_mapExceptionToErrorState(e));
    }
  }

  GenericDetailsState _mapExceptionToErrorState(Exception e) {
    if (e is NetworkException) {
      return GenericDetailsNetworkErrorState();
    }
    return GenericDetailsErrorState(
      error: LazyLocalizedStrings.somethingIsNotRightError,
    );
  }

  ///The call to repository that would fetch the details
  Future<T> loadData(String identifier);
}
