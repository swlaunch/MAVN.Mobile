import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/bloc/bottom_bar_refresh_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/di/bottom_bar_module.dart';
import 'package:lykke_mobile_mavn/feature_bottom_bar/view/non_mandatory_app_upgrade_dialog.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:version/version.dart';

class BottomBarPageBloc extends Bloc<RefreshState> {
  BottomBarPageBloc(
    this._localSettingsRepository,
    this._router,
  );
  final LocalSettingsRepository _localSettingsRepository;
  final Router _router;

  @override
  RefreshState initialState() => null;

  Future<void> init() async {
    await _checkAppVersionUpgradePrompt();
  }

  void bottomBarIndexChanged(int index) {
    sendEvent(BottomBarRefreshEvent(index: index));
  }

  Future<void> _checkAppVersionUpgradePrompt() async {
    try {
      final currentVersion =
          Version.parse(await _localSettingsRepository.getCurrentAppVersion());

      final lastAppVersionUpgradeDialogPrompt = Version.parse(
        _localSettingsRepository.getLastAppVersionUpgradeDialogPrompt(),
      );

      final latestAppVersion = Version.parse(
        _localSettingsRepository
            .getMobileSettings()
            .appVersion
            .latestAppVersion,
      );

      if (currentVersion < latestAppVersion &&
          lastAppVersionUpgradeDialogPrompt < latestAppVersion) {
        _localSettingsRepository.setLastAppVersionUpgradeDialogPrompt(
          value: latestAppVersion.toString(),
        );

        final shouldNavigateToStore = await _router.showDialog<bool>(
          child: const NonMandatoryAppUpgradeDialog(),
        );

        if (shouldNavigateToStore) {
          await _router.redirectToAppStores();
        }
      }
    } catch (e) {
      // silently fail
    }
  }
}

BottomBarPageBloc useBottomBarPageBloc() =>
    ModuleProvider.of<BottomBarModule>(useContext()).bottomBarPageBloc;
