import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/logout_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_pin/bloc/pin_forgot_bloc.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_logo.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';
import 'package:pedantic/pedantic.dart';

class PinForgotPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final bloc = usePinForgotBloc();

    final isLoading = useState(false);

    return ScaffoldWithLogo(
      hasBackButton: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: <Widget>[
            Heading(
              useLocalizedStrings().pinForgotPageTitle,
              dividerTopSpacing: 16,
            ),
            const SizedBox(height: 32),
            Text(
              useLocalizedStrings().pinForgotPageDescription,
              style: TextStyles.darkBodyBody1Bold,
            ),
            const Spacer(),
            PrimaryButton(
              text: useLocalizedStrings().pinForgotPageButton,
              buttonKey: const Key('proceedButton'),
              isLoading: isLoading.value,
              onTap: () async {
                isLoading.value = true;
                await bloc.resetPinPassCode();
                await useLogOutUseCase(context: context).execute();
                unawaited(router.navigateToLoginPage());
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
