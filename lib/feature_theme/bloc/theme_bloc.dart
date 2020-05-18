import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:pedantic/pedantic.dart';

class ThemeBloc extends Bloc<ThemeState> {
  ThemeBloc(this._localSettingsRepository);

  final LocalSettingsRepository _localSettingsRepository;

  @override
  ThemeState initialState() => ThemeUninitializedState();

  Future<void> getTheme() async {
    //use light theme as default
    final isDarkMode = _localSettingsRepository.getIsDarkMode() ?? false;
    setState(
        ThemeSelectedState(theme: isDarkMode ? DarkTheme() : LightTheme()));
  }

  Future<void> setTheme({bool isDarkMode}) async {
    unawaited(_localSettingsRepository.setIsDarkMode(isDarkMode: isDarkMode));
    setState(
        ThemeSelectedState(theme: isDarkMode ? DarkTheme() : LightTheme()));
  }
}

ThemeBloc useThemeBloc() =>
    ModuleProvider.of<AppModule>(useContext()).themeBloc;
