import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/analytics/transaction_form_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/bloc/transaction_form_bloc.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/bloc/transaction_form_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/view/transaction_balance_error_widget.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/view/transaction_form.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_wallet/ui_components/available_and_staked_balance_widget.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dismiss_keyboard_on_tap.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/page_title.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class TransactionFormPage extends HookWidget with FormMixin {
  TransactionFormPage({this.emailAddress});

  final _formKey = GlobalKey<FormState>();
  final _amountGlobalKey = GlobalKey();
  final _walletAddressGlobalKey = GlobalKey();
  final _walletAddressFieldKey = GlobalKey<FormFieldState>();
  final String emailAddress;

  @override
  Widget build(BuildContext context) {
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);
    final router = useRouter();
    final isFormSubmissionErrorDismissed = useState(false);
    final transactionFormBloc = useTransactionFormBloc();
    final transactionFormState =
        useBlocState<TransactionFormState>(transactionFormBloc);
    final walletBloc = useWalletBloc();
    final walletBlocState = useBlocState<WalletState>(walletBloc);
    final walletAddressController =
        useCustomTextEditingController(text: emailAddress);
    final amountController = useCustomTextEditingController();
    final transactionFormAnalyticsManager =
        useTransactionFormAnalyticsManager();

    void fetchWallet() {
      walletBloc.fetchWallet();
    }

    useBlocEventListener(transactionFormBloc, (event) {
      if (event is TransactionFormSuccessEvent) {
        router.replaceWithTransactionSuccessPage();
      } else if (event is BarcodeScanSuccessEvent) {
        walletAddressController.text = event.barcode;
        _walletAddressFieldKey.currentState.didChange(event.barcode);
        _walletAddressFieldKey.currentState.validate();
      } else if (event is TransactionFormWalletDisabledEvent) {
        router.showWalletDisabledDialog();
      }
    });

    void onSend() {
      transactionFormAnalyticsManager.transferFormSubmit();
      isFormSubmissionErrorDismissed.value = false;
      transactionFormBloc.postTransaction(
          walletAddress: walletAddressController.text,
          amount: amountController.text);
    }

    void onScanQrCodeButtonTapped() {
      transactionFormAnalyticsManager.transferFormScanQrCodeTap();
      dismissKeyboard(context);
      isFormSubmissionErrorDismissed.value = false;
      transactionFormBloc.startScan();
    }

    useEffect(() {
      transactionFormAnalyticsManager.transferFormStarted();
    }, [transactionFormAnalyticsManager]);

    return DismissKeyboardOnTap(
      child: ScaffoldWithAppBar(
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                PageTitle(
                  title: useLocalizedStrings()
                      .transactionFormPageTitle(tokenSymbol.value),
                  assetIconLeading: SvgAssets.sendTokens,
                  assetIconTrailing: walletBlocState is WalletErrorState
                      ? SvgAssets.error
                      : SvgAssets.tokenLight,
                  assetIconTrailingAlignedToTitle: true,
                ),
                if (walletBlocState is WalletLoadedState)
                  Expanded(
                    child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.only(left: 24, top: 16, right: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildTitle(tokenSymbol.value),
                          const SizedBox(height: 32),
                          AvailableAndStakedBalanceWidget(
                            wallet: walletBlocState.wallet,
                          ),
                          const SizedBox(height: 16),
                          _buildScanQRLabel(onScanQrCodeButtonTapped),
                          const SizedBox(height: 32),
                          TransactionForm(
                              formKey: _formKey,
                              walletAddressGlobalKey: _walletAddressGlobalKey,
                              walletAddressFieldKey: _walletAddressFieldKey,
                              amountGlobalKey: _amountGlobalKey,
                              walletAddressTextEditingController:
                                  walletAddressController,
                              amountTextEditingController: amountController,
                              onSendTap: onSend,
                              balance: walletBlocState.wallet.balance),
                        ],
                      ),
                    ),
                  ),
                if (walletBlocState is WalletErrorState)
                  _buildBalanceError(fetchWallet),
                if (walletBlocState is WalletLoadingState)
                  const Spinner(key: Key('transactionFormLoadingSpinner')),
              ],
            ),
            if (transactionFormState is TransactionFormErrorState &&
                !isFormSubmissionErrorDismissed.value)
              _buildError(
                key: 'transactionFormPageError',
                error: transactionFormState.error.localize(useContext()),
                onRetryTap: onSend,
                onCloseTap: () {
                  isFormSubmissionErrorDismissed.value = true;
                },
              ),
            if (transactionFormState is BarcodeScanPermissionErrorState &&
                !isFormSubmissionErrorDismissed.value)
              _buildError(
                key: 'transactionFormBarcodePermissonError',
                error: transactionFormState.error.localize(useContext()),
                onRetryTap: onScanQrCodeButtonTapped,
                onCloseTap: () {
                  isFormSubmissionErrorDismissed.value = true;
                },
              ),
            if (transactionFormState is BarcodeScanErrorState &&
                !isFormSubmissionErrorDismissed.value)
              _buildError(
                key: 'transactionFormBarcodeError',
                error: transactionFormState.error.localize(useContext()),
                onRetryTap: onScanQrCodeButtonTapped,
                onCloseTap: () {
                  isFormSubmissionErrorDismissed.value = true;
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String tokenSymbol) => Text(
        useLocalizedStrings().transactionFormPageSubDetails(tokenSymbol),
        style: TextStyles.darkBodyBody1RegularHigh,
      );

  Widget _buildScanQRLabel(VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          SvgPicture.asset(SvgAssets.qrCode),
          const SizedBox(width: 8),
          Text(
            useLocalizedStrings().transactionFormScanQRCode,
            style: TextStyles.linksTextLinkBold,
          ),
          const SizedBox(width: 8),
          Text(
            useLocalizedStrings().transactionFormOr,
            style: TextStyles.darkBodyBody2Bold,
          )
        ],
      ));

  Widget _buildError({
    String key,
    String error,
    VoidCallback onRetryTap,
    VoidCallback onCloseTap,
  }) =>
      Align(
          alignment: Alignment.bottomCenter,
          child: GenericErrorWidget(
            valueKey: Key(key),
            text: error,
            onRetryTap: onRetryTap,
            onCloseTap: onCloseTap,
          ));

  Widget _buildBalanceError(VoidCallback onRetry) =>
      TransactionBalanceErrorWidget(
        onRetryTap: onRetry,
      );
}
