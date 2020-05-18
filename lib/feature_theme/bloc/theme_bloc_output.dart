import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class ThemeState extends BlocState {}

abstract class ThemeEvent extends BlocEvent {}

class ThemeUninitializedState extends ThemeState {}

class ThemeSelectedState extends ThemeState {
  ThemeSelectedState({this.theme});

  final BaseAppTheme theme;
}
