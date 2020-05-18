import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_bloc.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_form_bloc.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_form_state.dart';
import 'package:lykke_mobile_mavn/feature_login/view/login_form.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/auth_scaffold.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';
import 'package:pedantic/pedantic.dart';

class LoginPage extends HookWidget {
  LoginPage({this.unauthorizedInterceptorRedirection = false});

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailContextKey = GlobalKey();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordContextKey = GlobalKey();

  final bool unauthorizedInterceptorRedirection;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();

    final biometricBloc = useBiometricBloc();
    final loginBloc = useLoginBloc();
    final loginFormBloc = useLoginFormBloc();

    final emailTextEditingController = useCustomTextEditingController();
    final passwordTextEditingController = useCustomTextEditingController();

    void proceedToLandingPage() {
      loginBloc.clear();
      router.navigateToLandingPage();
    }

    useBlocEventListener(loginBloc, (event) async {
      if (event is LoginSuccessEvent) {
        proceedToLandingPage();
        return;
      }

      if (event is LoginErrorDeactivatedAccountEvent) {
        await loginBloc.clear();

        unawaited(router.pushRootWelcomePageForMultiPush());
        unawaited(router.pushLoginPageForMultiPush());
        unawaited(router.pushAccountDeactivatedPage());
      }
    });

    useBlocEventListener(loginFormBloc, (event) {
      if (event is LoginFormEmailFetchedEvent &&
          emailTextEditingController.text.isEmpty) {
        emailTextEditingController.text = event.email;
        _emailFieldKey.currentState.didChange(event.email);
      }
    });

    useEffect(() {
      checkUnauthorizedRedirection(biometricBloc);
    }, [_scaffoldKey]);

    useEffect(() {
      loginFormBloc.fetchEmail();
    }, [loginFormBloc]);

    void doLogin() {
      loginBloc.login(
        emailTextEditingController.text,
        passwordTextEditingController.text,
      );
    }

    return AuthScaffold(
        scaffoldKey: _scaffoldKey,
        hasBackButton: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Heading(useLocalizedStrings().loginPageHeader)),
            const SizedBox(height: 12),
            Expanded(
              child: LoginForm(
                formKey: _formKey,
                emailGlobalKey: _emailContextKey,
                emailFieldKey: _emailFieldKey,
                passwordGlobalKey: _passwordContextKey,
                emailTextEditingController: emailTextEditingController,
                passwordTextEditingController: passwordTextEditingController,
                onSubmit: doLogin,
              ),
            ),
          ],
        ));
  }

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
}
