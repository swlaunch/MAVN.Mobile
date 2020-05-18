import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/countries_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/view/email_verification_page.dart';
import 'package:lykke_mobile_mavn/feature_register/analytics/register_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_register/bloc/register_bloc.dart';
import 'package:lykke_mobile_mavn/feature_register/view/register_form_step1.dart';
import 'package:lykke_mobile_mavn/feature_register/view/register_form_step2.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/auth_scaffold.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';

class RegisterPage extends HookWidget {
  final _form1Key = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();

  final _emailGlobalKey = GlobalKey();
  final _firstNameGlobalKey = GlobalKey();
  final _lastNameGlobalKey = GlobalKey();
  final _passwordGlobalKey = GlobalKey();
  final _nationalityGlobalKey = GlobalKey<FormFieldState<Country>>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final router = useRouter();

    final registerBloc = useRegisterBloc();

    final registerAnalyticsManager = useRegisterAnalyticsManager();

    final currentPage = useState<int>(0);
    final titles = [
      useLocalizedStrings().personalDetailsHeader,
      useLocalizedStrings().createAPasswordHeader,
    ];
    final _pageController =
        PageController(initialPage: currentPage.value, keepPage: true);

    Future<void> proceedToNextPage() async {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      currentPage.value = _pageController.page.toInt();
    }

    Future<void> backToPreviousPage() async {
      await _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      currentPage.value = _pageController.page.toInt();
    }

    final emailTextEditingController = useCustomTextEditingController();
    final firstNameTextEditingController = useCustomTextEditingController();
    final lastNameTextEditingController = useCustomTextEditingController();
    final passwordTextEditingController = useCustomTextEditingController();
    final selectedCountryOfNationalityNotifier =
        useValueNotifier<Country>(null);

    void onSubmit() {
      registerBloc.register(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text,
        firstName: firstNameTextEditingController.text,
        lastName: lastNameTextEditingController.text,
        countryOfNationalityId: selectedCountryOfNationalityNotifier.value?.id,
      );
    }

    useBlocEventListener(registerBloc, (event) {
      if (event is RegisterSuccessEvent) {
        registerAnalyticsManager.registrationSuccessful();
        router.pushRootEmailVerificationPage(
          email: event.registrationEmail,
          status: VerificationStatus.notVerified,
        );
      }
    });

    return WillPopScope(
      onWillPop: () {
        if (_pageController.page > 0) {
          backToPreviousPage();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: AuthScaffold(
        scaffoldKey: _scaffoldKey,
        hasBackButton: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Heading(
                titles[currentPage.value],
                currentStep: (currentPage.value + 1).toString(),
                totalSteps: titles.length.toString(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                key: const Key('registerPageView'),
                children: <Widget>[
                  RegisterFormStep1(
                    formKey: _form1Key,
                    emailGlobalKey: _emailGlobalKey,
                    firstNameGlobalKey: _firstNameGlobalKey,
                    lastNameGlobalKey: _lastNameGlobalKey,
                    nationalityGlobalKey: _nationalityGlobalKey,
                    emailTextEditingController: emailTextEditingController,
                    firstNameTextEditingController:
                        firstNameTextEditingController,
                    lastNameTextEditingController:
                        lastNameTextEditingController,
                    onNextTap: proceedToNextPage,
                    selectedCountryOfNationalityNotifier:
                        selectedCountryOfNationalityNotifier,
                  ),
                  RegisterFormStep2(
                    passwordGlobalKey: _passwordGlobalKey,
                    formKey: _form2Key,
                    passwordTextEditingController:
                        passwordTextEditingController,
                    onSubmitTap: onSubmit,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
