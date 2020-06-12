import 'package:dio/dio.dart' show LogInterceptor;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:location/location.dart';
import 'package:lykke_mobile_mavn/app/app.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_hotel_referral_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/country_code_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/country_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/customer_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/earn_rule_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/has_pin_use_case.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/logout_use_case.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/route_authentication_use_case.dart';
import 'package:lykke_mobile_mavn/base/date/date_time_manager.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/secure_store/secure_store.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_manager.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/sim_info/sim_card_info_manager.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/campaign/campaign_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/conversion/conversion_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/country_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/customer_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/earn_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/email/email_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/http_client.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/interceptor/analytics_interceptor.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/interceptor/local_cache_interceptor.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/interceptor/maintenance_interceptor.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/interceptor/token_interceptor.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/interceptor/unauthorized_user_redirect_interceptor.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/mobile/mobile_settings_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/partner_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/phone/phone_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/referral_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/sme/sme_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/voucher/voucher_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/wallet_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/notification/notification_api.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/remote_config_manager/remote_config_keys.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/remote_config_manager/remote_config_manager.dart';
import 'package:lykke_mobile_mavn/base/repository/balance_repository/balance_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/campaign/campaign_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/conversion/conversion_respository.dart';
import 'package:lykke_mobile_mavn/base/repository/country/country_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/earn/earn_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/email/email_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/mapper/referral_to_ui_model_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/mobile/mobile_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/notification/notification_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/partner/partner_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/phone/phone_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/pin/pin_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/referral/referral_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/sme/sme_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/token/token_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/user/user_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/voucher/voucher_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/wallet/wallet_repository.dart';
import 'package:lykke_mobile_mavn/base/router/external_router.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/base/router/router_page_factory.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc.dart';
import 'package:lykke_mobile_mavn/feature_debug_menu/bloc/debug_menu_bloc.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/analytics/email_verification_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/email_confirmation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_location/bloc/user_location_bloc.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_bloc.dart';
import 'package:lykke_mobile_mavn/feature_login/use_case/login_use_case.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_count_bloc.dart';
import 'package:lykke_mobile_mavn/feature_notification/router/notification_router.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/pending_payment_requests_bloc.dart';
import 'package:lykke_mobile_mavn/feature_personal_details/bloc/delete_account_use_case.dart';
import 'package:lykke_mobile_mavn/feature_transfer_vouchers/bloc/transfer_voucher_bloc.dart';
import 'package:lykke_mobile_mavn/feature_user_verification/bloc/user_verification_bloc.dart';
import 'package:lykke_mobile_mavn/feature_voucher_details/bloc/cancel_voucher_bloc.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/bloc/voucher_purchase_success_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/dynamic_link_manager.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_fcm/bloc/firebase_messaging_bloc.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/qr_content_manager.dart';
import 'package:lykke_mobile_mavn/library_websocket_wamp_client/websocket_wamp_client.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModule extends Module {
  AppModule({
    @required this.context,
    @required this.sharedPreferences,
    @required this.remoteConfig,
  });

  final BuildContext context;
  final SharedPreferences sharedPreferences;
  final RemoteConfig remoteConfig;

  /// Router ///
  Router get router => get();

  RouterPageFactory get routerPageFactory => get();

  NotificationRouter get notificationRouter => get();

  Location get location => get();

  GlobalKey<NavigatorState> get globalNavigatorStateKey => get();

  static const String bottomBarGlobalKeyQualifier = 'bottomBarGlobalKey';

  GlobalKey get bottomBarGlobalKey =>
      get(qualifierName: bottomBarGlobalKeyQualifier);

  ExternalRouter get externalRouter => get();

  DebugMenuBloc get debugMenuBloc => get();

  TokenRepository get tokenRepository => get();

  UserRepository get userRepository => get();

  LocalSettingsRepository get localSettingsRepository => get();

  RemoteConfigManager get remoteConfigManager => get();

  CustomerRepository get customerRepository => get();

  CountryRepository get countryRepository => get();

  WalletRepository get walletRepository => get();

  PartnerRepository get partnerRepository => get();

  EmailRepository get emailRepository => get();

  PhoneRepository get phoneRepository => get();

  ReferralRepository get referralRepository => get();

  EarnRepository get earnRepository => get();

  CampaignRepository get campaignRepository => get();

  VoucherRepository get voucherRepository => get();

  NotificationRepository get notificationRepository => get();

  SmeRepository get smeRepository => get();

  NotificationCountBloc get notificationCountBloc => get();

  DateTimeManager get dateTimeManager => get();

  HasPinUseCase get hasPinUseCase => get();

  GetMobileSettingsUseCase get getMobileSettingsUseCase => get();

  ExceptionToMessageMapper get getExceptionToMessageMapper => get();

  BalanceBloc get balanceBloc => get();

  WalletBloc get walletBloc => get();

  CountryListBloc get countryListBloc => get();

  CountryCodeListBloc get countryCodeListBloc => get();

  EarnRuleListBloc get earnRuleListBloc => get();

  PendingPartnerPaymentsBloc get pendingPartnerPaymentsBloc => get();

  BiometricBloc get biometricBloc => get();

  LoginBloc get loginBloc => get();

  SharedPreferencesManager get sharedPreferencesManager => get();

  DynamicLinkManager get dynamicLinkManager => get();

  LocalAuthentication get localAuthentication => get();

  AcceptHotelReferralBloc get acceptHotelReferralBloc => get();

  LogOutUseCase get logoutUseCase => get();

  DeleteAccountUseCase get deleteAccountUseCase => get();

  EmailConfirmationBloc get emailConfirmationBloc => get();

  CustomerBloc get customerBloc => get();

  RouteAuthenticationUseCase get routeAuthenticationUseCase => get();

  UserVerificationBloc get userVerificationBloc => get();

  ReferralToUiModelMapper get referralMapper => get();

  QrContentManager get qrContentManager => get();

  EmailVerificationAnalyticsManager get emailVerificationAnalyticsManager =>
      get();

  FirebaseMessaging get firebaseMessaging => get();

  FirebaseMessagingBloc get firebaseMessagingBloc => get();

  VoucherPurchaseSuccessBloc get voucherPurchaseSuccessBloc => get();

  CancelVoucherBloc get cancelVoucherBloc => get();

  UserLocationBloc get userLocationBloc => get();

  TransferVoucherBloc get transferVoucherBloc => get();

  @override
  void provideInstances() {
    // Global navigator state key
    provideSingleton(() => GlobalKey<NavigatorState>());
    // Global bottom nav bar key
    provideSingleton(() => GlobalKey(),
        qualifierName: bottomBarGlobalKeyQualifier);

    // Router
    provideSingleton(
      () => Router(
          globalNavigatorStateKey: get(),
          globalBottomNavBarStateKey:
              get(qualifierName: bottomBarGlobalKeyQualifier)),
    );
    provideSingleton(() => ExternalRouter(get()));

    provideSingleton(() => NotificationRouter(get()));

    //Location

    provideSingleton(() => Location());

    // Analytics
    provideSingleton(() => FirebaseAnalytics());
    provideSingleton(() => AnalyticsService(get()));

    // Interceptor
    provideSingleton(
      () => LogInterceptor(requestBody: true, responseBody: true),
    );
    provideSingleton(() => TokenInterceptor(get()));
    provideSingleton(() => AnalyticsInterceptor(get()));
    provideSingleton(
        () => UnauthorizedUserRedirectInterceptor(get(), get(), get(), get()));
    provideSingleton(() => MaintenanceInterceptor(get()));
    provideSingleton(() => LocalCacheInterceptor(get()));

    // Http Client
    const customerApiHttpClientQualifier = 'customerHttpClient';

    provideSingleton(
      () => HttpClient(
        remoteConfig.getString(RemoteConfigKeys.customerApiBaseRestUrl) ??
            'https://customer-api.mavn.ch/api',
        interceptors: [
          get<LogInterceptor>(),
          get<TokenInterceptor>(),
          get<AnalyticsInterceptor>(),
          get<UnauthorizedUserRedirectInterceptor>(),
          get<MaintenanceInterceptor>(),
          get<LocalCacheInterceptor>()
        ],
        timeoutSeconds:
            remoteConfig.getInt(RemoteConfigKeys.customerApiTimeoutSeconds),
        sharedPreferencesManager: get(),
      ),
      qualifierName: customerApiHttpClientQualifier,
    );

    const walletSocketRealm = 'prices';

    // Web socket WAMP client
    provideSingleton(() => WampClient(
          url: remoteConfig
                  .getString(RemoteConfigKeys.customerApiBaseSocketUrl) ??
              'wss://customer-api-ws.mavn.ch/ws',
          realm: walletSocketRealm,
        ));

    //Local authentication
    provideSingleton(() => LocalAuthentication());

    // API
    provideSingleton(() => CustomerApi(
        get<HttpClient>(qualifierName: customerApiHttpClientQualifier)));
    provideSingleton(() => CountryApi(
        get<HttpClient>(qualifierName: customerApiHttpClientQualifier)));
    provideSingleton(() => WalletApi(
        get<HttpClient>(qualifierName: customerApiHttpClientQualifier)));
    provideSingleton(() => PartnerApi(
        get<HttpClient>(qualifierName: customerApiHttpClientQualifier)));
    provideSingleton(() => ConversionApi(
        get<HttpClient>(qualifierName: customerApiHttpClientQualifier)));
    provideSingleton(() => MobileSettingsApi(
        get<HttpClient>(qualifierName: customerApiHttpClientQualifier)));
    provideSingleton(() => EmailApi(
        get<HttpClient>(qualifierName: customerApiHttpClientQualifier)));
    provideSingleton(() => PhoneApi(
        get<HttpClient>(qualifierName: customerApiHttpClientQualifier)));
    provideSingleton(() => ReferralApi(
        get<HttpClient>(qualifierName: customerApiHttpClientQualifier)));
    provideSingleton(() => EarnApi(
        get<HttpClient>(qualifierName: customerApiHttpClientQualifier)));
    provideSingleton(() => CampaignApi(
        get<HttpClient>(qualifierName: customerApiHttpClientQualifier)));
    provideSingleton(() => VoucherApi(
        get<HttpClient>(qualifierName: customerApiHttpClientQualifier)));
    provideSingleton(() => NotificationApi(
        get<HttpClient>(qualifierName: customerApiHttpClientQualifier)));
    provideSingleton(() =>
        SmeApi(get<HttpClient>(qualifierName: customerApiHttpClientQualifier)));

    provideSingleton(() => RemoteConfigManager(
          remoteConfig: remoteConfig,
          analyticsService: get(),
          isReleaseMode: App.isReleaseMode,
        ));

    // Local Data Source
    provideSingleton(() => SecureStore(const FlutterSecureStorage()));
    provideSingleton(() => SharedPreferencesManager(sharedPreferences));
    provideSingleton(() => SimCardInfoManager());

    // Repository
    provideSingleton(() => CustomerRepository(get()));
    provideSingleton(() => TokenRepository(get()));
    provideSingleton(() => UserRepository(get()));
    provideSingleton(() => CountryRepository(get()));
    provideSingleton(() => WalletRepository(get()));
    provideSingleton(() => PartnerRepository(get()));
    provideSingleton(() => LocalSettingsRepository(get()));
    provideSingleton(() => ConversionRepository(get()));
    provideSingleton(() => FirebaseMessaging());
    provideSingleton(() => FirebaseMessagingBloc(get(), get(), get()));
    provideSingleton(() => MobileSettingsRepository(get()));
    provideSingleton(() => WalletRealTimeRepository(get()));
    provideSingleton(() => EmailRepository(get()));
    provideSingleton(() => PhoneRepository(get()));
    provideSingleton(() => DateTimeManager());
    provideSingleton(() => PinRepository(get(), get()));
    provideSingleton(() => ReferralRepository(get()));
    provideSingleton(() => EarnRepository(get()));
    provideSingleton(() => CampaignRepository(get()));
    provideSingleton(() => VoucherRepository(get()));
    provideSingleton(() => NotificationRepository(get()));
    provideSingleton(() => SmeRepository(get()));
    provideSingleton(() => NotificationCountBloc(get()));

    // Bloc
    provideSingleton(() => BalanceBloc(get(), get(), get(), get()));

    provideSingleton(() => WalletBloc(get(), get(), get(), get()));

    provideSingleton(() => DebugMenuBloc(get(), get()));

    provideSingleton(() => CountryListBloc(get(), get(), get()));

    provideSingleton(() => CountryCodeListBloc(get(), get(), get()));

    provideSingleton(() => EarnRuleListBloc(get()));

    provideSingleton<PendingPartnerPaymentsBloc>(
        () => PendingPartnerPaymentsBloc(get()));

    provideSingleton(() => BiometricBloc(
        get(), get(), get(), get(), LocalizedStrings.of(context)));

    provideSingleton(() => LoginBloc(get(), get()));

    provideSingleton(() => AcceptHotelReferralBloc(get(), get(), get()));

    provideSingleton(() => EmailConfirmationBloc(get(), get(), get()));

    provideSingleton(() => CustomerBloc(get(), get()));

    provideSingleton(
        () => UserVerificationBloc(get(), get(), get(), get(), get()));

    provideSingleton(() => VoucherPurchaseSuccessBloc(get()));

    provideSingleton(() => CancelVoucherBloc(get(), get()));

    provideSingleton(() => UserLocationBloc(get()));

    provideSingleton(() => TransferVoucherBloc(get(), get()));

    // Dynamic Link Manager
    provideSingleton(
      () => DynamicLinkManager(
        firebaseDynamicLinks: FirebaseDynamicLinks.instance,
        router: get(),
        hotelReferralBloc: get(),
        emailConfirmationBloc: get(),
        voucherPurchaseSuccessBloc: get(),
        sharedPreferencesManager: get(),
      ),
    );

    //Qr Content Manager
    provideSingleton(() => QrContentManager(get(), get(), get(), get()));

    //Use case
    provideSingleton(() => LoginUseCase(get(), get(), get()));
    provideSingleton(() => LogOutUseCase(get(), get(), get(), get(), get()));
    provideSingleton(() => HasPinUseCase(get()));
    provideSingleton(() => GetMobileSettingsUseCase(get()));
    provideSingleton(() =>
        RouteAuthenticationUseCase(get(), get(), get(), get(), get(), get()));
    provideSingleton(() => ExceptionToMessageMapper(get()));
    provideSingleton(() => DeleteAccountUseCase(get(), get()));

    //Misc
    provideSingleton(() => ReferralToUiModelMapper());

    provideSingleton(() => EmailVerificationAnalyticsManager(get()));
  }

  @override
  void dispose() {
    get<WalletRealTimeRepository>().dispose();
    super.dispose();
  }
}
