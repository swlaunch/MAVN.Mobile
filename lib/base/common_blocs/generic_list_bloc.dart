import 'package:flutter/foundation.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class GenericListBloc<R, T> extends Bloc<GenericListState> {
  GenericListBloc({
    @required this.genericErrorSubtitle,
  });

  final LocalizedStringBuilder genericErrorSubtitle;

  @override
  GenericListState initialState() => GenericListUninitializedState();

  Future<void> getList() async {
    if (currentState is GenericListEmptyState) {
      return Future.value();
    }
    if (currentState is GenericListLoadedState) {
      final currentSuccessState = currentState as GenericListLoadedState;
      if (currentSuccessState.totalCount > currentSuccessState.list.length) {
        return _getGenericListForPage(
          currentSuccessState.currentPage + 1,
          currentSuccessState.list,
        );
      }
    } else if (currentState is GenericListErrorState) {
      final currentErrorState = currentState as GenericListErrorState;

      return _getGenericListForPage(
        currentErrorState.currentPage,
        currentErrorState.list,
      ); // retry the previous page
    } else {
      return _getGenericListForPage(1, []);
    }
  }

  Future<void> updateGenericList({bool refresh = false}) async =>
      _getGenericListForPage(1, [], refresh: refresh);

  Future<void> _getGenericListForPage(int page, List<T> currentGenericsList,
      {bool refresh = false}) async {
    if (!refresh) {
      setState(page == 1
          ? GenericListLoadingState()
          : GenericListPaginationLoadingState());
    }

    try {
      final response = await loadData(page);
      final list = getDataFromResponse(response);

      final newGenericList = currentGenericsList..addAll(sort(list));

      if (newGenericList.isEmpty) {
        setState(GenericListEmptyState());
      } else {
        setState(GenericListLoadedState(
          list: newGenericList,
          totalCount: getTotalCount(response),
          currentPage: getCurrentPage(response),
        ));
      }
    } on Exception catch (e) {
      setState(_getErrorState(e, page, currentGenericsList));
    }
  }

  GenericListState _getErrorState(
      Exception e, int page, List<T> currentGenericsList) {
    if (e is NetworkException) {
      return GenericListNetworkErrorState();
    }

    return GenericListErrorState(
      error: genericErrorSubtitle,
      currentPage: page,
      list: currentGenericsList,
    );
  }

  Future<R> loadData(int page);

  List<T> getDataFromResponse(R response);

  int getTotalCount(R response);

  int getCurrentPage(R response);

  List<T> sort(List<T> list) => list;
}
