import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/customer_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/customer_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/analytics/phone_number_verification_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_number_verification_bloc.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_number_verification_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_verification_generation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/bloc/phone_verification_generation_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/ui_components/resend_code_widget.dart';
import 'package:lykke_mobile_mavn/feature_phone_number_verification/ui_components/sms_auto_fill_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/on_dispose_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/auth_scaffold.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';

class PhoneNumberVerificationPage extends HookWidget {
  static const _step = 3;

  final smsFillKey = GlobalKey();
  final codeFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final router = useRouter();

    final phoneNumberVerificationBloc = usePhoneNumberVerificationBloc();
    final phoneNumberVerificationState =
        useBlocState(phoneNumberVerificationBloc);

    final phoneVerificationGenerationBloc =
        usePhoneVerificationGenerationBloc();
    final phoneVerificationGenerationState =
        useBlocState<PhoneVerificationGenerationState>(
            phoneVerificationGenerationBloc);

    final customerBloc = useCustomerBloc();
    final customerBlocState = useBlocState<CustomerState>(customerBloc);

    final codeValueNotifier = useValueNotifier<String>();
    final isErrorDismissed = useState(false);

    final phoneNumberAnalyticsManager = usePhoneNumberAnalyticsManager();

    void proceed() {
      phoneNumberAnalyticsManager.phoneVerificationSuccessful();
      router.pushRootBottomBarPage();
    }

    void getCustomer() {
      customerBloc.getCustomer();
    }

    void sendVerification() {
      phoneNumberAnalyticsManager.requestNewVerificationCodeTap();
      isErrorDismissed.value = true;
      phoneVerificationGenerationBloc.sendVerificationMessage();
    }

    void verifyPhoneNumber() {
      phoneNumberAnalyticsManager.verifyCodeTap();
      isErrorDismissed.value = false;
      phoneNumberVerificationBloc.verify(
          verificationCode: codeValueNotifier.value);
    }

    useBlocEventListener(phoneNumberVerificationBloc, (event) {
      if (event is PhoneNumberVerifiedEvent ||
          event is PhoneNumberVerificationAlreadyVerifiedErrorEvent) {
        proceed();
      }
    });

    useBlocEventListener(phoneVerificationGenerationBloc, (event) {
      if (event is PhoneVerificationGenerationAlreadyVerifiedErrorEvent) {
        proceed();
      }
    });

    useEffect(() {
      getCustomer();
    }, [customerBloc]);

    useOnDispose(() {
      codeFocusNode.dispose();
    });

    return AuthScaffold(
      hasBackButton: true,
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Column(
          children: [
            Heading(
              LocalizedStrings.phoneNumberVerificationPageTitle,
              currentStep: _step.toString(),
              totalSteps: _step.toString(),
            ),
            const SizedBox(height: 24),
            _getContent(
                customerBlocState,
                getCustomer,
                phoneNumberVerificationState,
                verifyPhoneNumber,
                phoneVerificationGenerationState,
                sendVerification,
                codeValueNotifier,
                isErrorDismissed),
          ],
        ),
      ),
    );
  }

  Widget _getContent(
    CustomerState customerState,
    VoidCallback getCustomer,
    PhoneNumberVerificationState phoneNumberVerificationState,
    VoidCallback verifyPhoneNumber,
    PhoneVerificationGenerationState phoneVerificationGenerationState,
    VoidCallback sendVerification,
    ValueNotifier<String> codeValueNotifier,
    ValueNotifier<bool> isErrorDismissed,
  ) {
    if (phoneNumberVerificationState
        is PhoneNumberVerificationNetworkErrorState) {
      return _buildNetworkError(onRetryTap: verifyPhoneNumber);
    } else if (phoneVerificationGenerationState
        is PhoneVerificationGenerationNetworkErrorState) {
      return _buildNetworkError(onRetryTap: sendVerification);
    } else if (customerState is CustomerNetworkErrorState) {
      return _buildNetworkError(onRetryTap: getCustomer);
    } else {
      return _buildContent(customerState, codeValueNotifier, isErrorDismissed,
          verifyPhoneNumber, sendVerification, phoneNumberVerificationState);
    }
  }

  Widget _buildContent(
          CustomerState customerState,
          ValueNotifier<String> codeValueNotifier,
          ValueNotifier<bool> isErrorDismissed,
          VoidCallback verifyPhoneNumber,
          VoidCallback sendVerification,
          PhoneNumberVerificationState phoneNumberVerificationState) =>
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: _buildDetailsText(customerState),
            ),
            SmsAutoFillWidget(
              verificationCodeValueNotifier: codeValueNotifier,
              isErrorDismissed: isErrorDismissed,
              verifyOnTap: verifyPhoneNumber,
              key: smsFillKey,
              codeFocusNode: codeFocusNode,
            ),
            Expanded(child: ResendCodeWidget(onTap: sendVerification)),
            PrimaryButton(
                text: LocalizedStrings.nextPageButton,
                onTap: verifyPhoneNumber,
                isLoading: phoneNumberVerificationState
                    is PhoneNumberVerificationLoadingState),
            const SizedBox(height: 64),
          ],
        ),
      );

  Widget _buildNetworkError({VoidCallback onRetryTap}) =>
      NetworkErrorWidget(onRetry: onRetryTap);

  Widget _buildDetailsText(CustomerState customerState) {
    if (customerState is CustomerLoadedState &&
        customerState.customer.phoneNumber != null &&
        customerState.customer.phoneCountryCode != null) {
      return Row(
        children: <Widget>[
          Flexible(
            child: Text(
              LocalizedStrings.phoneNumberVerificationDetails(
                  '${customerState.customer.phoneCountryCode}'
                  '${customerState.customer.phoneNumber}'),
              style: TextStyles.darkBodyBody2RegularHigh,
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
