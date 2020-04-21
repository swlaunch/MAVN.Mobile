import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/has_pin_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_logo.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';

class BiometricAgreementPage extends HookWidget {
  BiometricAgreementPage({@required this.unauthorizedInterceptorRedirection});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final bool unauthorizedInterceptorRedirection;

  void checkUnauthorizedRedirection(BiometricBloc biometricBloc) {
    if (!unauthorizedInterceptorRedirection) {
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      biometricBloc.clear();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          useLocalizedStrings().loginPageUnauthorizedRedirectionMessage,
          key: const Key('unauthorizedRedirectionMessage'),
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final biometricBloc = useBiometricBloc();
    final hasPinUseCase = useHasPinUseCase(context);

    useBlocEventListener(biometricBloc, (event) async {
      if ([
        BiometricAuthenticationApprovedEvent,
        BiometricAuthenticationDeclinedEvent,
        BiometricAuthenticationWillNotAuthenticateEvent
      ].contains(event.runtimeType)) {
        await hasPinUseCase.execute()
            ? await router.navigateToLandingPage()
            : await router.pushRootPinCreatePage();
      }
    });

    useEffect(() {
      checkUnauthorizedRedirection(biometricBloc);
    }, [_scaffoldKey]);

    return ScaffoldWithLogo(
      key: _scaffoldKey,
      hasBackButton: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        child: Column(
          children: [
            Heading(_headingText),
            const SizedBox(height: 8),
            Text(
              _descriptionText,
              style: TextStyles.darkBodyBody2RegularHigh,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PrimaryButton(
                    text: useLocalizedStrings().warningDialogYesButton,
                    onTap: () => biometricBloc
                        .setBiometricAuthenticationPermission(hasAgreed: true),
                  ),
                  FlatButton(
                    onPressed: () => biometricBloc
                        .setBiometricAuthenticationPermission(hasAgreed: false),
                    child: Text(
                      useLocalizedStrings().warningDialogNoThanksButton,
                      style: TextStyles.linksTextLinkBold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _headingText => Platform.isIOS
      ? useLocalizedStrings().biometricAuthenticationDialogTitleIOS
      : useLocalizedStrings().biometricAuthenticationDialogTitleAndroid;

  String get _descriptionText => Platform.isIOS
      ? useLocalizedStrings().biometricAuthenticationDialogMessageIOS
      : useLocalizedStrings().biometricAuthenticationDialogMessageAndroid;
}
