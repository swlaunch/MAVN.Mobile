import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_hotel_referral_bloc.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_manager.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/email_confirmation_bloc.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/dynamic_link_manager.dart';
import 'package:mockito/mockito.dart';

import '../mock_classes.dart';

class MockFirebaseDynamicLinks extends Mock implements FirebaseDynamicLinks {}

FirebaseDynamicLinks _mockDynamicLinks;
Router _mockRouter;
AcceptHotelReferralBloc _mockAcceptHotelReferralBloc;
EmailConfirmationBloc _mockEmailConfirmationBloc;
SharedPreferencesManager _mockSharedPreferencesManager;
DynamicLinkManager _subject;

void main() {
  group('DynamicLinkManager tests', () {
    setUp(() {
      _mockDynamicLinks = MockFirebaseDynamicLinks();
      _mockSharedPreferencesManager = MockSharedPreferencesManager();
      _mockRouter = MockRouter();
      _subject = DynamicLinkManager(
        firebaseDynamicLinks: _mockDynamicLinks,
        router: _mockRouter,
        hotelReferralBloc: _mockAcceptHotelReferralBloc,
        emailConfirmationBloc: _mockEmailConfirmationBloc,
        sharedPreferencesManager: _mockSharedPreferencesManager,
        voucherPurchaseSuccessBloc: null,
      );
    });

    test(
        'startListenForDynamicLinks checks '
        'if there is a pending dynamic link ', () async {
      await _subject.startListenOnceForDynamicLinks();

      verify(_mockDynamicLinks.getInitialLink());
    });

    test(
        'startListenForDynamicLinks start listens for success and '
        'error callbacks ', () async {
      await _subject.startListenOnceForDynamicLinks();

      verify(_mockDynamicLinks.onLink(
          onSuccess: anyNamed('onSuccess'), onError: anyNamed('onError')));
    });
  });
}
