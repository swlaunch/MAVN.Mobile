import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_hotel_pre_checkout/bloc/hotel_pre_checkout_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/dialog/custom_dialog_with_close_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/hotel_message.dart';

class HotelPreCheckoutDialog extends HookWidget {
  const HotelPreCheckoutDialog({@required this.paymentRequestId});

  final String paymentRequestId;

  @override
  Widget build(BuildContext context) {
    final hotelPreCheckoutBloc = useHotelPreCheckoutBloc();
    final hotelPreCheckoutBlocState = useBlocState(hotelPreCheckoutBloc);

    void _getPartnerMessage() {
      hotelPreCheckoutBloc.getHotelPreCheckoutDetails(paymentRequestId);
    }

    useEffect(() {
      _getPartnerMessage();
    }, [
      hotelPreCheckoutBloc,
    ]);

    Widget _buildContent() {
      if (hotelPreCheckoutBlocState is HotelPreCheckoutLoadedState) {
        return HotelMessage(
          partnerName: hotelPreCheckoutBlocState.partnerName,
          heading: useLocalizedStrings().hotelPreCheckoutDialogHeading,
          message: hotelPreCheckoutBlocState.message,
          endContent: PrimaryButton(
            text: useLocalizedStrings().hotelPreCheckoutDialogViewInvoiceButton,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        );
      } else if (hotelPreCheckoutBlocState is HotelPreCheckoutErrorState) {
        return Container(
          alignment: Alignment.topCenter,
          child: GenericErrorWidget(
            text: hotelPreCheckoutBlocState.error.localize(useContext()),
            onRetryTap: _getPartnerMessage,
          ),
        );
      }
    }

    return Scaffold(
      body: CustomDialogWithCloseButton(
        isLoading: hotelPreCheckoutBlocState is HotelPreCheckoutLoadingState,
        child: _buildContent(),
      ),
    );
  }
}
