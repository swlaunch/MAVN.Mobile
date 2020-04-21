import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/feature_hotel_welcome/bloc/hotel_welcome_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/dialog/custom_dialog_with_close_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/hotel_message.dart';

class HotelWelcomeDialog extends HookWidget {
  const HotelWelcomeDialog({@required this.partnerMessageId});

  final String partnerMessageId;

  @override
  Widget build(BuildContext context) {
    final hotelWelcomeBloc = useHotelWelcomeBloc();
    final hotelWelcomeBlocState = useBlocState(hotelWelcomeBloc);

    void _getPartnerMessage() {
      hotelWelcomeBloc.getPartnerMessage(partnerMessageId);
    }

    useEffect(() {
      _getPartnerMessage();
    }, [
      hotelWelcomeBloc,
    ]);

    return Scaffold(
      body: CustomDialogWithCloseButton(
        isLoading: hotelWelcomeBlocState is HotelWelcomeLoadingState,
        child: Column(
          children: <Widget>[
            if (hotelWelcomeBlocState is HotelWelcomeLoadedState)
              Expanded(
                child: HotelMessage(
                  partnerName: hotelWelcomeBlocState.partnerName,
                  heading: hotelWelcomeBlocState.heading,
                  message: hotelWelcomeBlocState.message,
                ),
              ),
            if (hotelWelcomeBlocState is HotelWelcomeErrorState)
              Container(
                alignment: Alignment.topCenter,
                child: GenericErrorWidget(
                  text: hotelWelcomeBlocState.error.localize(useContext()),
                  onRetryTap: _getPartnerMessage,
                ),
              )
          ],
        ),
      ),
    );
  }
}
