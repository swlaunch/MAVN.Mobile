import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lykke_mobile_mavn/app/app.dart';
import 'package:lykke_mobile_mavn/app/app_localizations_delegate.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_hotel_referral_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_hotel_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_lead_referral_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/accept_lead_referral_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/country_code_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/country_code_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/country_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/customer_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/customer_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/earn_rule_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/spend_rule_list_bloc.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/logout_use_case.dart';
import 'package:lykke_mobile_mavn/base/date/date_time_manager.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_manager.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/countries_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payments_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/remote_config_manager/remote_config_manager.dart';
import 'package:lykke_mobile_mavn/base/repository/balance_repository/balance_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/country/country_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/customer/customer_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/earn/earn_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/local/local_settings_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/mapper/referral_to_ui_model_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/notification/notification_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/partner/partner_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/referral/referral_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/spend/spend_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/token/token_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/user/user_repository.dart';
import 'package:lykke_mobile_mavn/base/repository/wallet/wallet_repository.dart';
import 'package:lykke_mobile_mavn/base/router/external_router.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_balance/bloc/balance/balance_bloc.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc.dart';
import 'package:lykke_mobile_mavn/feature_biometrics/bloc/biometric_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_debug_menu/bloc/debug_menu_bloc.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/analytics/email_verification_analytics_manager.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/email_confirmation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/email_confirmation_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_bloc.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_form_bloc.dart';
import 'package:lykke_mobile_mavn/feature_login/bloc/login_form_state.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_count_bloc.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_count_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_p2p_transactions/bloc/barcode_scanner_manager.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/pending_payment_requests_bloc.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_user_verification/bloc/user_verification_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc.dart';
import 'package:lykke_mobile_mavn/feature_wallet/bloc/wallet_bloc_output.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/dynamic_link_manager.dart';
import 'package:lykke_mobile_mavn/library_analytics/analytics_service.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:lykke_mobile_mavn/library_fcm/bloc/firebase_messaging_bloc.dart';
import 'package:lykke_mobile_mavn/library_fcm/bloc/firebase_messaging_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_qr_actions/qr_content_manager.dart';
import 'package:mockito/mockito.dart';

import '../mock_classes.dart';
import '../test_constants.dart';
import 'test_time_manager.dart';

class TestAppFrame extends StatelessWidget {
  const TestAppFrame({
    this.child,
    this.navigatorGlobalStateKey,
    this.mockRouter,
    this.mockExternalRouter,
    this.mockRemoteConfigManager,
    this.mockDebugMenuBloc,
    this.mockCountryListBloc,
    this.mockCountryCodeListBloc,
    this.mockBalanceBloc,
    this.mockSpendRuleListBloc,
    this.mockEarnRuleListBloc,
    this.mockSharedPreferencesManager,
    this.mockPartnerPaymentsPendingBloc,
    this.mockDynamicLinkManager,
    this.mockBiometricBloc,
    this.mockLoginBloc,
    this.mockLocalSettingsRepository,
    this.mockHotelReferralBloc,
    this.mockLeadReferralBloc,
    this.mockLogOutUseCase,
    this.mockGetMobileSettingsUseCase,
    this.mockCustomerBloc,
    this.mockEmailConfirmationBloc,
    this.mockDateTimeManager,
    this.mockWalletBloc,
    this.mockUserVerificationBloc,
    this.mockReferralToUiModelMapper,
    this.mockExceptionToMessageMapper,
    this.mockNotificationCountBloc,
    this.mockQrContentManager,
    this.mockBarcodeScanManager,
    this.mockFirebaseMessagingBloc,
    this.mockThemeBloc,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorGlobalStateKey;
  final Router mockRouter;
  final ExternalRouter mockExternalRouter;
  final RemoteConfigManager mockRemoteConfigManager;
  final MockSharedPreferencesManager mockSharedPreferencesManager;
  final MockDynamicLinkManager mockDynamicLinkManager;
  final DebugMenuBloc mockDebugMenuBloc;
  final MockCountryListBloc mockCountryListBloc;
  final MockCountryCodeListBloc mockCountryCodeListBloc;
  final MockBalanceBloc mockBalanceBloc;
  final MockSpendRuleListBloc mockSpendRuleListBloc;
  final MockEarnRuleListBloc mockEarnRuleListBloc;
  final MockPartnerPaymentsPendingBloc mockPartnerPaymentsPendingBloc;
  final MockBiometricBloc mockBiometricBloc;
  final MockLoginBloc mockLoginBloc;
  final MockLocalSettingsRepository mockLocalSettingsRepository;
  final MockAcceptHotelReferralBloc mockHotelReferralBloc;
  final MockAcceptLeadReferralBloc mockLeadReferralBloc;
  final MockLogOutUseCase mockLogOutUseCase;
  final MockGetMobileSettingsUseCase mockGetMobileSettingsUseCase;
  final CustomerBloc mockCustomerBloc;
  final EmailConfirmationBloc mockEmailConfirmationBloc;
  final MockDateTimeManager mockDateTimeManager;
  final MockWalletBloc mockWalletBloc;
  final MockUserVerificationBloc mockUserVerificationBloc;
  final MockNotificationCountBloc mockNotificationCountBloc;
  final MockReferralToUiModelMapper mockReferralToUiModelMapper;
  final MockExceptionToMessageMapper mockExceptionToMessageMapper;
  final MockQrContentManager mockQrContentManager;
  final MockBarcodeScannerManager mockBarcodeScanManager;
  final MockFirebaseMessagingBloc mockFirebaseMessagingBloc;
  final MockThemeBloc mockThemeBloc;

  @override
  Widget build(BuildContext context) => ModuleProvider<AppModule>(
        module: TestAppModule(
          mockRouter: mockRouter,
          mockExternalRouter: mockExternalRouter,
          mockRemoteConfigManager: mockRemoteConfigManager,
          mockSharedPreferencesManager: mockSharedPreferencesManager,
          mockDynamicLinkManager: mockDynamicLinkManager,
          mockDebugMenuBloc: mockDebugMenuBloc,
          mockCountryListBloc: mockCountryListBloc,
          mockCountryCodeListBloc: mockCountryCodeListBloc,
          mockBalanceBloc: mockBalanceBloc,
          mockSpendRuleListBloc: mockSpendRuleListBloc,
          mockEarnRuleListBloc: mockEarnRuleListBloc,
          mockPartnerPaymentsPendingBloc: mockPartnerPaymentsPendingBloc,
          mockBiometricBloc: mockBiometricBloc,
          mockLoginBloc: mockLoginBloc,
          mockLocalSettingsRepository: mockLocalSettingsRepository,
          mockHotelReferralBloc: mockHotelReferralBloc,
          mockLeadReferralBloc: mockLeadReferralBloc,
          mockLogOutUseCase: mockLogOutUseCase,
          mockGetMobileSettingsUseCase: mockGetMobileSettingsUseCase,
          mockCustomerBloc: mockCustomerBloc,
          mockEmailConfirmationBloc: mockEmailConfirmationBloc,
          mockDateTimeManager: mockDateTimeManager,
          mockWalletBloc: mockWalletBloc,
          mockUserVerificationBloc: mockUserVerificationBloc,
          mockNotificationCountBloc: mockNotificationCountBloc,
          mockReferralToUiModelMapper: mockReferralToUiModelMapper,
          mockExceptionToMessageMapper: mockExceptionToMessageMapper,
          mockQrContentManager: mockQrContentManager,
          mockBarcodeScanManager: mockBarcodeScanManager,
          mockFirebaseMessagingBloc: mockFirebaseMessagingBloc,
          mockThemeBloc: mockThemeBloc,
        ),
        child: MaterialApp(
          home: MaterialApp(
            navigatorKey: navigatorGlobalStateKey,
            title: 'Test widget frame',
            theme: ThemeData(),
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: appSupportedLocales,
            localeResolutionCallback: defaultLocaleResolution,
            home: child,
          ),
        ),
      );
}

class TestAppModule extends AppModule {
  TestAppModule({
    this.mockRouter,
    this.mockExternalRouter,
    this.mockRemoteConfigManager,
    this.mockDynamicLinkManager,
    this.mockDebugMenuBloc,
    this.mockCountryListBloc,
    this.mockCountryCodeListBloc,
    this.mockBalanceBloc,
    this.mockSpendRuleListBloc,
    this.mockEarnRuleListBloc,
    this.mockSharedPreferencesManager,
    this.mockPartnerPaymentsPendingBloc,
    this.mockSplashBloc,
    this.mockBiometricBloc,
    this.mockLoginBloc,
    this.mockLocalSettingsRepository,
    this.mockHotelReferralBloc,
    this.mockLeadReferralBloc,
    this.mockLogOutUseCase,
    this.mockGetMobileSettingsUseCase,
    this.mockCustomerBloc,
    this.mockEmailConfirmationBloc,
    this.mockDateTimeManager,
    this.mockWalletBloc,
    this.mockUserVerificationBloc,
    this.mockNotificationCountBloc,
    this.mockReferralToUiModelMapper,
    this.mockExceptionToMessageMapper,
    this.mockQrContentManager,
    this.mockBarcodeScanManager,
    this.mockFirebaseMessagingBloc,
    this.mockThemeBloc,
  });

  final RemoteConfigManager mockRemoteConfigManager;
  final SharedPreferencesManager mockSharedPreferencesManager;
  final MockDynamicLinkManager mockDynamicLinkManager;
  final Router mockRouter;
  final ExternalRouter mockExternalRouter;
  final DebugMenuBloc mockDebugMenuBloc;
  final MockCountryListBloc mockCountryListBloc;
  final MockCountryCodeListBloc mockCountryCodeListBloc;
  final MockBalanceBloc mockBalanceBloc;
  final MockSpendRuleListBloc mockSpendRuleListBloc;
  final MockEarnRuleListBloc mockEarnRuleListBloc;
  final MockPartnerPaymentsPendingBloc mockPartnerPaymentsPendingBloc;
  final MockSplashBloc mockSplashBloc;
  final MockBiometricBloc mockBiometricBloc;
  final MockLoginBloc mockLoginBloc;
  final MockLocalSettingsRepository mockLocalSettingsRepository;
  final MockAcceptHotelReferralBloc mockHotelReferralBloc;
  final MockAcceptLeadReferralBloc mockLeadReferralBloc;
  final MockLogOutUseCase mockLogOutUseCase;
  final MockGetMobileSettingsUseCase mockGetMobileSettingsUseCase;
  final MockCustomerBloc mockCustomerBloc;
  final MockEmailConfirmationBloc mockEmailConfirmationBloc;
  final MockDateTimeManager mockDateTimeManager;
  final MockWalletBloc mockWalletBloc;
  final MockUserVerificationBloc mockUserVerificationBloc;
  final MockNotificationCountBloc mockNotificationCountBloc;
  final MockReferralToUiModelMapper mockReferralToUiModelMapper;
  final MockExceptionToMessageMapper mockExceptionToMessageMapper;
  final MockQrContentManager mockQrContentManager;
  final MockBarcodeScannerManager mockBarcodeScanManager;
  final MockFirebaseMessagingBloc mockFirebaseMessagingBloc;
  final MockThemeBloc mockThemeBloc;

  @override
  void provideInstances() {
    provideSingleton(() => GlobalKey<NavigatorState>());
    provideSingleton(() => GlobalKey(),
        qualifierName: AppModule.bottomBarGlobalKeyQualifier);

    //////////////////////////

    provideSingleton<Router>(() => mockRouter ?? MockRouter());
    provideSingleton<ExternalRouter>(
        () => mockExternalRouter ?? MockExternalRouter());
    provideSingleton<CountryListBloc>(() =>
        mockCountryListBloc ??
        MockCountryListBloc(CountryListUninitializedState()));
    provideSingleton<CountryCodeListBloc>(() =>
        mockCountryCodeListBloc ??
        MockCountryCodeListBloc(CountryCodeListUninitializedState()));
    provideSingleton<BalanceBloc>(
        () => mockBalanceBloc ?? MockBalanceBloc(BalanceUninitializedState()));
    provideSingleton<WalletBloc>(
        () => mockWalletBloc ?? MockWalletBloc(WalletUninitializedState()));
    provideSingleton<SpendRuleListBloc>(() =>
        mockSpendRuleListBloc ??
        MockSpendRuleListBloc(GenericListUninitializedState()));
    provideSingleton<EarnRuleListBloc>(() =>
        mockEarnRuleListBloc ??
        MockEarnRuleListBloc(GenericListUninitializedState()));
    provideSingleton<PendingPartnerPaymentsBloc>(() =>
        mockPartnerPaymentsPendingBloc ??
        MockPartnerPaymentsPendingBloc(GenericListUninitializedState()));

    provideSingleton<BiometricBloc>(() =>
        mockBiometricBloc ?? MockBiometricBloc(BiometricUninitializedState()));
    provideSingleton<LoginBloc>(
        () => mockLoginBloc ?? MockLoginBloc(LoginUninitializedState()));
    provideSingleton<LoginFormBloc>(
        () => MockLoginFormBloc(LoginFormUninitializedState()));

    provideSingleton<AcceptHotelReferralBloc>(() =>
        mockHotelReferralBloc ??
        MockAcceptHotelReferralBloc(AcceptHotelReferralUninitializedState()));

    provideSingleton<AcceptLeadReferralBloc>(() =>
        mockLeadReferralBloc ??
        MockAcceptLeadReferralBloc(AcceptLeadReferralUninitializedState()));

    provideSingleton<CustomerBloc>(() =>
        mockCustomerBloc ?? MockCustomerBloc(CustomerUninitializedState()));
    provideSingleton<EmailConfirmationBloc>(() =>
        mockEmailConfirmationBloc ??
        MockEmailConfirmationBloc(EmailConfirmationUninitializedState()));

    provideSingleton<LogOutUseCase>(
        () => mockLogOutUseCase ?? MockLogOutUseCase());

    provideSingleton<GetMobileSettingsUseCase>(
        () => mockGetMobileSettingsUseCase ?? MockGetMobileSettingsUseCase());

    provideSingleton<UserVerificationBloc>(
        () => mockUserVerificationBloc ?? MockUserVerificationBloc());

    provideSingleton<NotificationCountBloc>(() =>
        mockNotificationCountBloc ??
        MockNotificationCountBloc(NotificationCountUninitializedState()));

    provideSingleton<FirebaseMessagingBloc>(() =>
        mockFirebaseMessagingBloc ??
        MockFirebaseMessagingBloc(FirebaseMessagingUninitializedState()));

    provideSingleton<ThemeBloc>(() =>
        mockThemeBloc ??
        MockThemeBloc(ThemeSelectedState(theme: LightTheme())));

    //////////////////////////

    final defaultMockCustomerRepository = MockCustomerRepository();
    final defaultMockSpendRepository = MockSpendRepository();

    when(defaultMockSpendRepository.getSpendRules()).thenAnswer((_) async {
      final mockSpendRuleListResponseModel = MockSpendRuleListResponseModel();
      when(mockSpendRuleListResponseModel.spendRuleList).thenReturn([]);
      return mockSpendRuleListResponseModel;
    });

    provideSingleton<SpendRepository>(() => defaultMockSpendRepository);

    provideSingleton<CustomerRepository>(() => defaultMockCustomerRepository);

    final defaultMockCountryRepository = MockCountryRepository();

    when(defaultMockCountryRepository.getCountryList()).thenAnswer(
        (_) async => CountryListResponseModel(countryList: <Country>[]));

    when(defaultMockCountryRepository.getCountryCodeList()).thenAnswer(
      (_) async => CountryCodeListResponseModel(
        countryCodeList: <CountryCode>[],
      ),
    );

    provideSingleton<CountryRepository>(() => defaultMockCountryRepository);

    provideSingleton<WalletRepository>(() => MockWalletRepository());

    provideSingleton<WalletRealTimeRepository>(
        () => MockWalletRealTimeRepository());

    provideSingleton<UserRepository>(() => MockUserRepository());

    final partnerRepository = MockPartnerRepository();
    when(partnerRepository.getPendingPayments(
            currentPage: anyNamed('currentPage')))
        .thenAnswer((_) => Future.value(PaginatedPartnerPaymentsResponseModel(
            paymentRequests: [TestConstants.stubPaymentRequest])));

    provideSingleton<PartnerRepository>(() => partnerRepository);

    if (mockLocalSettingsRepository == null) {
      final defaultMobileSettings = MockMobileSettings();
      when(defaultMobileSettings.tokenPrecision).thenReturn(2);

      final defaultLocalSettingsRepository = MockLocalSettingsRepository();
      when(defaultLocalSettingsRepository.getMobileSettings())
          .thenReturn(defaultMobileSettings);

      provideSingleton<LocalSettingsRepository>(
          () => defaultLocalSettingsRepository);
    } else {
      provideSingleton<LocalSettingsRepository>(
          () => mockLocalSettingsRepository);
    }
    final defaultMockReferralRepository = MockReferralRepository();

    provideSingleton<ReferralRepository>(() => defaultMockReferralRepository);

    final defaultMockEarnRepository = MockEarnRepository();

    when(defaultMockEarnRepository.getEarnRules()).thenAnswer((_) async {
      final mockEarnRuleListResponseModel = MockEarnRuleListResponseModel();
      when(mockEarnRuleListResponseModel.earnRuleList).thenReturn([]);
      return mockEarnRuleListResponseModel;
    });

    provideSingleton<EarnRepository>(() => defaultMockEarnRepository);

    final defaultMockNotificationRepository = MockNotificationRepository();

    provideSingleton<NotificationRepository>(
        () => defaultMockNotificationRepository);

    //////////////////////////

    final defaultMockRemoteConfigManager = MockRemoteConfigManager();
    when(defaultMockRemoteConfigManager
            .readBool('is_policies_checkbox_above_button'))
        .thenReturn(false);

    provideSingleton<RemoteConfigManager>(
        () => mockRemoteConfigManager ?? defaultMockRemoteConfigManager);

    final defaultSharedPreferencesManager = MockSharedPreferencesManager();

    provideSingleton<SharedPreferencesManager>(
        () => mockSharedPreferencesManager ?? defaultSharedPreferencesManager);

    final defaultDynamicLinkManager = MockDynamicLinkManager();

    provideSingleton<DynamicLinkManager>(
        () => mockDynamicLinkManager ?? defaultDynamicLinkManager);

    final defaultDateTimeManager = TestTimeManager();

    provideSingleton<DateTimeManager>(
        () => mockDateTimeManager ?? defaultDateTimeManager);

    provideSingleton<ReferralToUiModelMapper>(
        () => mockReferralToUiModelMapper ?? MockReferralToUiModelMapper());

    /////////////////////////
    provideSingleton<TokenRepository>(() => MockTokenRepository());
    provideSingleton<AnalyticsService>(() => MockAnalyticsService());
    provideSingleton<DebugMenuBloc>(() =>
        mockDebugMenuBloc ??
        MockDebugMenuBloc(DebugMenuState(proxyUrl: TestConstants.stubUrl)));
    provideSingleton<ExceptionToMessageMapper>(
        () => mockExceptionToMessageMapper ?? MockExceptionToMessageMapper());
    provideSingleton<QrContentManager>(
        () => mockQrContentManager ?? MockQrContentManager());
    provideSingleton<BarcodeScanManager>(
        () => mockBarcodeScanManager ?? MockBarcodeScannerManager());

    provideSingleton<EmailVerificationAnalyticsManager>(
        () => MockEmailVerificationAnalyticsManager());
  }
}
