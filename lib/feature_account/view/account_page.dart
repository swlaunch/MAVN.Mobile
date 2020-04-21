import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_account/ui_components/switch_list_item_widget.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/select_list_item.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/standard_divider.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/page_title.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class AccountPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final biometricBloc = useBiometricBloc();
    final router = useRouter();

    useBlocEventListener(biometricBloc, (event) async {
      if (event is BiometricAuthenticationDisabledEvent) {
        await router.showEnableBiometricsDialog(LocalizedStrings.of(context));
      }
    });

    final settings = [
      _AccountSettingWithTrailingIcon(
        title: useLocalizedStrings().referralTrackingPersonalDetailsOption,
        asset: SvgAssets.referralTracking,
        onSelected: router.pushReferralListPage,
      ),
      _AccountSettingWithTrailingIcon(
        title: useLocalizedStrings().vouchersOption,
        asset: SvgAssets.voucher,
        onSelected: router.pushVoucherListPage,
      ),
      _AccountSettingWithTrailingIcon(
          title: useLocalizedStrings().accountPagePersonalDetailsOption,
          asset: SvgAssets.settingsPersonalDetails,
          onSelected: router.pushPersonalDetailsPage),
      _AccountSettingWithTrailingIcon(
        title: useLocalizedStrings().accountPageChangePasswordOption,
        asset: SvgAssets.settingsChangePassword,
        onSelected: router.pushChangePasswordPage,
      ),
      _AccountSettingWithTrailingIcon(
        title: useLocalizedStrings().contactUsButton,
        asset: SvgAssets.settingsContactUs,
        onSelected: router.pushContactUsPage,
      ),
      _AccountSettingWithTrailingIcon(
        title: useLocalizedStrings().termsOfUse,
        asset: SvgAssets.settingsTerms,
        onSelected: router.pushTermsOfUsePage,
      ),
      _AccountSettingWithTrailingIcon(
        title: useLocalizedStrings().privacyPolicy,
        asset: SvgAssets.settingsPrivacy,
        onSelected: router.pushPrivacyPolicyPage,
      ),
      AccountSettingWithSwitch(
        title: Platform.isIOS
            ? useLocalizedStrings().accountPageBiometricsSignInOptionIOS
            : useLocalizedStrings().accountPageBiometricsSignInOptionAndroid,
        initialSelectedState: biometricBloc.isBiometricEnabled,
        onBeforeChange: (currentValue) =>
            biometricBloc.toggleBiometrics(enable: !currentValue),
      ),
    ];

    return ScaffoldWithAppBar(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PageTitle(
                title: useLocalizedStrings().accountPageTitle,
              ),
              const SizedBox(height: 56),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, position) => settings[position].build(),
                separatorBuilder: (context, position) => StandardDivider(),
                itemCount: settings.length,
              ),
              StandardDivider(),
              _AppVersionWidget(),
              _LogoutButton(
                onTap: () => router
                    .showLogOutConfirmationDialog(LocalizedStrings.of(context)),
              ),
            ]),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({this.onTap});

  final Function onTap;

  @override
  Widget build(BuildContext context) => SelectListItem(
        valueKey: Key(LocalizedStrings.of(context).accountPageLogoutOption),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const StandardSizedSvg(SvgAssets.settingsLogout),
            const SizedBox(width: 16),
            Text(LocalizedStrings.of(context).accountPageLogoutOption,
                style: TextStyles.darkBodyBody1RegularHigh),
          ],
        ),
        padding: const EdgeInsets.all(24),
        onTap: onTap,
      );
}

class _AccountSettingWithTrailingIcon extends _AccountSetting {
  _AccountSettingWithTrailingIcon({
    final String title,
    final String asset,
    final Function onSelected,
  }) : super(title: title, asset: asset, onSelected: onSelected);

  @override
  Widget build() => SelectListItem(
        valueKey: Key(title),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(title, style: TextStyles.darkBodyBody1RegularHigh),
            StandardSizedSvg(asset),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        onTap: onSelected,
      );
}

class AccountSettingWithSwitch extends _AccountSetting {
  AccountSettingWithSwitch({
    final String title,
    final Function(bool) onChanged,
    this.onBeforeChange,
    this.initialSelectedState,
  }) : super(title: title, onSelected: onChanged);

  final Future<bool> initialSelectedState;
  final Future<bool> Function(bool) onBeforeChange;

  @override
  Widget build() => SwitchListItemWidget(
        title: title,
        onChanged: onSelected,
        initialSelectedState: initialSelectedState,
        onBeforeChange: onBeforeChange,
      );
}

abstract class _AccountSetting {
  _AccountSetting({this.title, this.asset, this.onSelected});

  final String title;
  final String asset;
  final Function onSelected;

  Widget build();
}

class _AppVersionWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final localSettingsRepository = useLocalSettingsRepository();

    return FutureBuilder(
      initialData: null,
      future: localSettingsRepository.getCurrentAppVersion(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 24),
            child: Text(
              LocalizedStrings.of(context).accountAppVersion(snapshot.data),
              style: TextStyles.darkBodyBody3RegularHigh,
            ),
          );
        }

        return Container();
      },
    );
  }
}
