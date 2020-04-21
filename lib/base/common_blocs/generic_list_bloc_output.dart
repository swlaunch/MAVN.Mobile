import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:meta/meta.dart';

abstract class GenericListState<T> extends BaseState {}

class GenericListUninitializedState extends GenericListState {}

class GenericListPaginationLoadingState extends GenericListState {}

class GenericListLoadingState extends GenericListState {}

class GenericListErrorState<T> extends GenericListState {
  GenericListErrorState({
    @required this.error,
    @required this.currentPage,
    @required this.list,
  });

  final LocalizedStringBuilder error;

  final List<T> list;
  final int currentPage;

  @override
  List get props => super.props..addAll([error, list, currentPage]);
}

class GenericListNetworkErrorState extends GenericListState
    with BaseNetworkErrorState {}

class GenericListLoadedState<T> extends GenericListState {
  GenericListLoadedState({
    @required this.list,
    @required this.currentPage,
    @required this.totalCount,
  });

  final List<T> list;
  final int currentPage;
  final int totalCount;

  @override
  List get props => super.props
    ..addAll([
      list,
      currentPage,
      totalCount,
    ]);
}

class GenericListEmptyState extends GenericListState {}
