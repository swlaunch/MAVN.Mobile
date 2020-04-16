import 'package:flutter/cupertino.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/base_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

class RefreshState extends BaseState {}

class BottomBarRefreshEvent extends BlocEvent {
  BottomBarRefreshEvent({@required this.index});
  final int index;
}
