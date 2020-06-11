import 'package:dio/dio.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/offer_type.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/conversion/response_model/currency_converter_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/countries_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/country/response_model/country_codes_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/customer_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/partner_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/wallet_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_condition_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_condition.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/earn/response_model/extended_earn_rule_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/mobile/response_model/mobile_settings_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/partner_message_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/partner/response_model/payment_request_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/wallet/response_model/link_request_response_model.dart';
import 'package:lykke_mobile_mavn/library_models/fiat_currency.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';

class TestConstants {
  static const stubEmpty = '';
  static const stubErrorText = 'stubErrorText';
  static const stubErrorTitle = 'stubErrorTitle';
  static const stubErrorSubtitle = 'stubErrorSubtitle';
  static const stubErrorIconAsset = 'assets/svg/generic_error_icon.svg';
  static const stubEmail = 'stubEmail';
  static const stubEmailLowercase = 'stubEmail';
  static const stubValidEmail = 'stub@valid.email';
  static const stubInvalidEmail = 'stubInvalid email';
  static const stubPhoneNumber = 'stubPhoneNumber';
  static const stubValidPhoneNumber = '0798654';
  static const stubInvalidPhoneNumber = '0765%[]';
  static const stubName = 'stubName';
  static const stubFirstName = 'stubFirstName';
  static const stubLastName = 'stubLastName';
  static const stubFullName = 'stubFullName';
  static const stubValidName = 'validName';
  static const stubInvalidName = ';;;';
  static const stubNote = 'stubNote';
  static const stubPassword = 'stubPassword';
  static const stubValidPassword = 'validPassword1@';
  static const stubInvalidPassword = 'invp,';
  static const stubReferralCode = 'stubReferralCode';
  static const stubPath = 'stubPath';
  static const stubUrl = 'stubUrl';
  static const stubKey = 'stubKey';
  static const stubNumberOfOffersToPurchaseNone = 0;
  static const stubNumberOfSalesPurchaseAgreementsNone = 0;
  static const stubNumberOfOffersToPurchase = 2;
  static const stubNumberOfSalesPurchaseAgreements = 3;
  static const stubDateString = '2019-06-28T14:22:10.000Z';
  static const stubDateFromLastYearString = '2018-06-28T14:22:10.000Z';
  static const stubPartnerName = 'stubPartnerName';
  static const stubOtherSideCustomerEmail = 'stubOtherSideCustomerEmail';
  static const stubActionRule = 'Some campaign name';
  static const stubCountryId = 0;
  static const stubCountryName = 'stubCountryName';
  static const stubCountryCodePhoneCode = 'stubCode';
  static const stubValidCountryCodePhoneCode = '0123';
  static const stubCountryCodeId = 0;
  static const stubBase64 = 'stubBase64';
  static const stubDocumentType = 'stubDocumentType';
  static const stubImageName = 'stubImageName';
  static const stubValidTransactionAmount = '10.00';
  static const stubGreaterThanBalanceTransactionAmount = 210.0;
  static const stubInvalidAmount = ';;';
  static const stubNegativeAmount = '-1';
  static const stubBalance = '123.00';
  static const stubTokenSymbol = 'ABC';
  static const stubTransactionId = 'stubTransactionId';
  static const stubInvoiceId = 'stubInvoiceId';
  static const stubCampaignId = 'stubInvoiceId';
  static const stubBankName = 'stubBankName';
  static const stubBankBranchName = 'stubBankBranchName';
  static const stubAccountNumber = 'stubAccountNumber';
  static const stubBankAddress = 'stubBankAddress';
  static const stubBankBranchCountryId = 1;
  static const stubValidBankSWIFTCode = 'ABCDEFGH';
  static const stubInvalidBankSWIFTCode = 'ABCDEF';
  static const stubValidBankIBANCode = 'ABCDEFGHIJKLMNOPQ';
  static const stubInvalidBankIBANCode = 'ABCDEFGHIJKLMN';
  static const stubPassportImagePath = 'stubPassportImagePath';
  static const stubAppleToken = 'stubAppleToken';
  static const stubFirebaseToken = 'stubFirebaseToken';
  static const stubLoginToken = 'stubLoginToken';
  static const stubAmount = '16';
  static const stubAmountDouble = 16.0;
  static const stubTotalCount = 100;
  static const stubCurrentPage = 5;
  static const stubPageSize = 30;
  static const stubPendingPageSize = 10;
  static const stubEarnRuleId = 'stubEarnRuleId';
  static const stubTimestamp = 1234;
  static const stubValidWebSite = 'http://www.google.com';

  static final stubException = Exception('stubException');

  static final stubDateTime = DateTime(2019, 6, 28, 14, 22, 10);
  static final stubDateTimeToday = DateTime(2019, 6, 28, 10, 11, 12);
  static final stubDateTimeYesterday = DateTime(2019, 6, 27, 14, 22, 10);

  static const stubDateTimeStringToday = '2019-06-28T10:11:12.000Z';
  static const stubDateTimeStringYesterday = '2019-06-27T14:22:10.000Z';
  static const stubInvalidDateTimeString = 'abc';

  static const stubUserIso2CodeUppercase = 'US';
  static const stubUserIso2CodeLowercase = 'us';
  static const stubUserIso3Code = 'USA';
  static const stubBarcode = 'stubBarcode';

  static const stubTermsUrl = 'stubTermsUrl';

  static const stubEmailVerificationCode = 'stubEmailVerificationCode';

  static const stubCountry = Country(
      id: stubCountryId,
      name: stubCountryName,
      countryIso2Code: stubUserIso2CodeUppercase,
      countryIso3Code: stubUserIso3Code);

  static const stubBankBranchCountry = Country(
    id: stubBankBranchCountryId,
    name: stubCountryName,
    countryIso2Code: stubUserIso2CodeUppercase,
    countryIso3Code: stubUserIso3Code,
  );

  static const stubCountryList = <Country>[stubCountry];

  static const stubCountryCode = CountryCode(
    id: stubCountryCodeId,
    name: stubCountryName,
    code: stubValidCountryCodePhoneCode,
    countryIso2Code: stubUserIso2CodeUppercase,
    countryIso3Code: stubUserIso3Code,
  );

  static const stubCountryCodeList = <CountryCode>[stubCountryCode];

  static final unauthorizedDioError =
      DioError(type: DioErrorType.RESPONSE, error: 'Http status error [401]');

  static const String stubHospitalityId = '0';
  static const String stubRealEstateId = '1';
  static const String stubAmountInCurrency = '100.00';
  static const TokenCurrency stubAmountInTokens = TokenCurrency(value: '10');
  static const String stubCurrencyName = 'AED';
  static const String stubSpendRuleTitle = 'Campaign';
  static const String stubSpendRuleDescription = 'studDescription';
  static const String stubImageUrl =
      'https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?s=1024x768';

  static const Partner stubPartner = Partner(
    id: '',
    name: stubName,
    locations: [],
  );

  static const stubTokenCurrency =
      TokenCurrency(value: stubBalance, assetSymbol: stubTokenSymbol);

  static const stubConditionId = '123';
  static const stubAmountInCurrencyDouble = 50.0;
  static const stubCompletionCount = 5;
  static const stubCustomerCompletionCount = 1;
  static const stubStakingRule = 2.0;
  static const stubStakingPeriod = 10;
  static const stubStakingWarningPeriod = 10;
  static final stubImmediateReward = TokenCurrency(value: 10.toString());
  static final stubStakeAmount = TokenCurrency(value: 100.toString());
  static const stubDisplayName = 'stubDisplayName';
  static const stubBurningRule = 2.0;
  static final stubCurrentRewardedAmount = TokenCurrency(value: 10.toString());

  static final stayInHotelCondition = EarnRuleCondition(
      id: stubConditionId,
      rewardType: RewardType.fixed,
      hasStaking: true,
      amountInCurrency: stubAmountInCurrencyDouble,
      completionCount: stubCompletionCount,
      stakingRule: stubStakingRule,
      stakingPeriod: stubStakingPeriod,
      stakeAmount: stubStakeAmount,
      stakeWarningPeriod: stubStakingWarningPeriod,
      immediateReward: stubImmediateReward,
      displayName: stubDisplayName,
      type: EarnRuleConditionType.hotelStay,
      vertical: OfferVertical.hospitality,
      usePartnerCurrencyRate: true,
      burningRule: stubBurningRule,
      amountInTokens: stubAmountInTokens);

  static final stayInHotelExtendedCondition = ExtendedEarnRuleCondition(
      id: stubConditionId,
      rewardType: RewardType.fixed,
      hasStaking: true,
      amountInCurrency: stubAmountInCurrencyDouble,
      completionCount: stubCompletionCount,
      stakingRule: stubStakingRule,
      stakingPeriod: stubStakingPeriod,
      stakeAmount: stubStakeAmount,
      stakeWarningPeriod: stubStakingWarningPeriod,
      immediateReward: stubImmediateReward,
      displayName: stubDisplayName,
      type: EarnRuleConditionType.hotelStay,
      vertical: OfferVertical.hospitality,
      usePartnerCurrencyRate: true,
      burningRule: stubBurningRule,
      amountInTokens: stubAmountInTokens,
      partners: [],
      customerCompletionCount: stubCustomerCompletionCount);

  static final stayInHotelExtendedConditionWithPartners =
      ExtendedEarnRuleCondition(
          id: stubConditionId,
          rewardType: RewardType.fixed,
          hasStaking: true,
          amountInCurrency: stubAmountInCurrencyDouble,
          completionCount: stubCompletionCount,
          stakingRule: stubStakingRule,
          stakingPeriod: stubStakingPeriod,
          stakeAmount: stubStakeAmount,
          stakeWarningPeriod: stubStakingWarningPeriod,
          immediateReward: stubImmediateReward,
          displayName: stubDisplayName,
          type: EarnRuleConditionType.hotelStay,
          vertical: OfferVertical.hospitality,
          usePartnerCurrencyRate: true,
          burningRule: stubBurningRule,
          amountInTokens: stubAmountInTokens,
          partners: [stubPartner],
          customerCompletionCount: stubCustomerCompletionCount);

  static final stayInHotelExtendedNoStakingCondition =
      ExtendedEarnRuleCondition(
          id: stubConditionId,
          rewardType: RewardType.fixed,
          hasStaking: false,
          amountInCurrency: stubAmountInCurrencyDouble,
          completionCount: stubCompletionCount,
          stakingRule: null,
          stakingPeriod: null,
          stakeAmount: null,
          stakeWarningPeriod: null,
          immediateReward: stubImmediateReward,
          displayName: stubDisplayName,
          type: EarnRuleConditionType.hotelStay,
          vertical: OfferVertical.hospitality,
          usePartnerCurrencyRate: true,
          burningRule: stubBurningRule,
          amountInTokens: stubAmountInTokens,
          partners: [],
          customerCompletionCount: stubCustomerCompletionCount);

  static const String stubCreatedBy = 'Created by';

  static const stubCreationDate = '2019-09-09T00:00:00.000Z';

  static final stubEarnRule = EarnRule(
    id: 'id1',
    title: 'Offer title',
    imageUrl: '',
    description: 'Offer description',
    fromDate: '2019-09-09T00:00:00.000Z',
    toDate: '2019-09-30T23:59:59.999Z',
    reward: stubTokenCurrency,
    optionalConditions: [],
    completionCount: 1,
    createdBy: stubCreatedBy,
    creationDate: stubCreationDate,
    status: EarnRuleStatus.active,
    conditions: [stayInHotelCondition],
    rewardType: RewardType.fixed,
    approximateAward: null,
    isApproximate: false,
  );

  static const stubEarnRuleNoImage = EarnRule(
    id: 'id1',
    title: 'Offer title',
    imageUrl: null,
    description: 'Offer description',
    fromDate: 'fromDate',
    toDate: 'toDate',
    reward: stubTokenCurrency,
    optionalConditions: [],
    completionCount: null,
    createdBy: stubCreatedBy,
    creationDate: stubCreationDate,
    status: EarnRuleStatus.active,
    conditions: [],
    rewardType: RewardType.fixed,
    approximateAward: null,
    isApproximate: false,
  );

  static final stubEarnRuleWithStayHotelCondition = EarnRule(
    id: 'id1',
    title: 'Offer title',
    imageUrl:
        'https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?s=1024x768',
    description: 'Offer description',
    fromDate: 'fromDate',
    toDate: 'toDate',
    reward: stubTokenCurrency,
    optionalConditions: [],
    completionCount: null,
    createdBy: stubCreatedBy,
    creationDate: stubCreationDate,
    status: EarnRuleStatus.active,
    conditions: [stayInHotelCondition],
    rewardType: RewardType.fixed,
    approximateAward: null,
    isApproximate: false,
  );

  static const stubEarnRuleWithoutConditions = EarnRule(
    id: 'id1',
    title: 'Offer title',
    imageUrl:
        'https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?s=1024x768',
    description: 'Offer description',
    fromDate: 'fromDate',
    toDate: 'toDate',
    reward: stubTokenCurrency,
    optionalConditions: [],
    completionCount: null,
    createdBy: stubCreatedBy,
    creationDate: stubCreationDate,
    status: EarnRuleStatus.active,
    conditions: [],
    rewardType: RewardType.fixed,
    approximateAward: null,
    isApproximate: false,
  );

  static final stubExtendedEarnRuleWithStayHotelCondition = ExtendedEarnRule(
    id: 'id1',
    title: 'Offer title',
    imageUrl:
        'https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?s=1024x768',
    description: 'Offer description',
    fromDate: 'fromDate',
    toDate: 'toDate',
    reward: stubTokenCurrency,
    optionalConditions: [],
    completionCount: null,
    createdBy: stubCreatedBy,
    creationDate: stubCreationDate,
    status: EarnRuleStatus.active,
    conditions: [stayInHotelExtendedCondition],
    rewardType: RewardType.fixed,
    amountInCurrency: stubAmountInCurrencyDouble,
    customerCompletionCount: stubCustomerCompletionCount,
    currentRewardedAmount: stubCurrentRewardedAmount,
    amountInTokens: stubAmountInTokens,
    approximateAward: null,
    isApproximate: false,
  );

  static final stubExtendedEarnRuleReachedMaxParticipationNoStaking =
      ExtendedEarnRule(
    id: 'id1',
    title: 'Offer title',
    imageUrl:
        'https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?s=1024x768',
    description: 'Offer description',
    fromDate: 'fromDate',
    toDate: 'toDate',
    reward: stubTokenCurrency,
    optionalConditions: [],
    completionCount: stubCompletionCount,
    createdBy: stubCreatedBy,
    creationDate: stubCreationDate,
    status: EarnRuleStatus.active,
    conditions: [stayInHotelExtendedNoStakingCondition],
    rewardType: RewardType.fixed,
    amountInCurrency: stubAmountInCurrencyDouble,
    customerCompletionCount: stubCompletionCount,
    currentRewardedAmount: stubCurrentRewardedAmount,
    amountInTokens: stubAmountInTokens,
    approximateAward: null,
    isApproximate: false,
  );

  static final stubExtendedEarnRuleWithPartners = ExtendedEarnRule(
    id: 'id1',
    title: 'Offer title',
    imageUrl:
        'https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?s=1024x768',
    description: 'Offer description',
    fromDate: 'fromDate',
    toDate: 'toDate',
    reward: stubTokenCurrency,
    optionalConditions: [],
    completionCount: stubCompletionCount,
    createdBy: stubCreatedBy,
    creationDate: stubCreationDate,
    status: EarnRuleStatus.active,
    conditions: [stayInHotelExtendedConditionWithPartners],
    rewardType: RewardType.fixed,
    amountInCurrency: stubAmountInCurrencyDouble,
    customerCompletionCount: stubCompletionCount,
    currentRewardedAmount: stubCurrentRewardedAmount,
    amountInTokens: stubAmountInTokens,
    isApproximate: false,
  );

  static final stubExtendedEarnRuleReachedMaxParticipation = ExtendedEarnRule(
    id: 'id1',
    title: 'Offer title',
    imageUrl:
        'https://pix10.agoda.net/hotelImages/124/1246280/1246280_16061017110043391702.jpg?s=1024x768',
    description: 'Offer description',
    fromDate: 'fromDate',
    toDate: 'toDate',
    reward: stubTokenCurrency,
    optionalConditions: [],
    completionCount: stubCompletionCount,
    createdBy: stubCreatedBy,
    creationDate: stubCreationDate,
    status: EarnRuleStatus.active,
    conditions: [stayInHotelExtendedCondition],
    rewardType: RewardType.fixed,
    amountInCurrency: stubAmountInCurrencyDouble,
    customerCompletionCount: stubCompletionCount,
    currentRewardedAmount: stubCurrentRewardedAmount,
    amountInTokens: stubAmountInTokens,
    isApproximate: false,
  );

  static final stubEarnRuleList = <EarnRule>[
    stubEarnRuleWithStayHotelCondition
  ];

  static final stubEarnRuleListWithoutConditions = <EarnRule>[
    stubEarnRuleWithoutConditions
  ];

  static final stubWalletLinkedResponseModel = WalletResponseModel(
    balance: stubTokenCurrencyWalletBalance,
    walletLinkingStatus: WalletLinkingStatusType.linked,
    privateWalletAddress: '321321',
  );

  static final stubWalletResponseModel =
      WalletResponseModel(balance: stubTokenCurrencyWalletBalance);

  static final stubWalletResponseModelNoBalance = WalletResponseModel(
    balance: stubTokenCurrencyWalletZeroBalance,
    externalBalance: stubTokenCurrencyWalletZeroBalance,
  );

  static const stubWalletPublicAddress = '1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2';
  static const stubWalletLinkingCode =
      '0x9955af11969a2d2a7f860cb00e6a00cfa7c581f5df2dbe8ea16700b33f4b4b9b69'
      'f945012f7ea7d3febf11eb1b78e1adc2d1c14c2cf48b25000938cc1860c83e01';

  //region Payment requests
  static const stubPaymentRequestBalance = '1230000000.0';
  static const stubPaymentRequestInsufficientWalletBalance = '4000000.0';
  static const stubPaymentRequestId = 'stubId';
  static const stubPaymentRequestTotalInToken = '5000000';
  static const stubPaymentRequestTotalInTokenGreaterThanBill = '6000000';
  static const stubPaymentRequestTotalInTokenDouble = '5000000.0';
  static const stubPaymentRequestRequestedInTokenDouble = '4000000.0';
  static const double stubPaymentRequestTotalInCurrency = 500000;
  static const stubPaymentRequestStatus = PaymentRequestStatus.pending;
  static const TokenCurrency stubPaymentRequestAmountInTokens =
      TokenCurrency(value: stubPaymentRequestTotalInTokenDouble);
  static const TokenCurrency stubPaymentRequestRequestedInTokens =
      TokenCurrency(value: stubPaymentRequestRequestedInTokenDouble);
  static const stubPaymentRequestCurrencyCode = 'stubCurrencyCode';
  static const stubPaymentRequestPartnerId = 'stubPartnerId';
  static const stubPaymentRequestPartnerName = 'stubPartnerName';
  static const stubPaymentRequestLocationId = 'stubLocationId';
  static const stubPaymentRequestLocationName = 'stubLocationName';
  static const stubPaymentRequestPaymentInfo = 'stubPaymentInfo';
  static const stubPaymentRequestConversionRate = 0.5;
  static const stubTokenCurrencyWalletBalance = TokenCurrency(
      value: stubPaymentRequestBalance, assetSymbol: stubTokenSymbol);
  static const stubTokenCurrencyWalletZeroBalance =
      TokenCurrency(value: '0', assetSymbol: stubTokenSymbol);
  static const stubTokenCurrencyWalletInsufficientBalance = TokenCurrency(
      value: stubPaymentRequestInsufficientWalletBalance,
      assetSymbol: stubTokenSymbol);

  static const stubSendingAmountInToken = TokenCurrency(
      value: stubPaymentRequestBalance, assetSymbol: stubTokenSymbol);

  static const stubExpirationTimeInSeconds = 60;

  static const stubExpirationTimeStamp = '2019-09-17T07:28:13.368Z';

  static const stubPaymentRequest = PaymentRequestResponseModel(
    paymentRequestId: TestConstants.stubPaymentRequestId,
    status: TestConstants.stubPaymentRequestStatus,
    totalInToken: TestConstants.stubPaymentRequestAmountInTokens,
    requestedAmountInTokens: stubPaymentRequestRequestedInTokens,
    totalInCurrency: TestConstants.stubPaymentRequestTotalInCurrency,
    sendingAmountInToken: stubSendingAmountInToken,
    currencyCode: TestConstants.stubPaymentRequestCurrencyCode,
    partnerId: TestConstants.stubPaymentRequestPartnerId,
    partnerName: TestConstants.stubPaymentRequestPartnerName,
    locationId: TestConstants.stubPaymentRequestLocationId,
    locationName: TestConstants.stubPaymentRequestLocationName,
    paymentInfo: TestConstants.stubPaymentRequestPaymentInfo,
    walletBalance: TestConstants.stubTokenCurrencyWalletBalance,
    date: TestConstants.stubDateString,
    lastUpdatedDate: TestConstants.stubDateString,
    tokensToFiatConversionRate: TestConstants.stubPaymentRequestConversionRate,
    expirationTimeLeftInSeconds: stubExpirationTimeInSeconds,
    expirationTimeStamp: stubExpirationTimeStamp,
  );

  static const stubPaymentRequestDatedLastYear = PaymentRequestResponseModel(
      paymentRequestId: TestConstants.stubPaymentRequestId,
      status: TestConstants.stubPaymentRequestStatus,
      totalInToken: TestConstants.stubPaymentRequestAmountInTokens,
      requestedAmountInTokens: stubPaymentRequestRequestedInTokens,
      totalInCurrency: TestConstants.stubPaymentRequestTotalInCurrency,
      sendingAmountInToken: stubSendingAmountInToken,
      currencyCode: TestConstants.stubPaymentRequestCurrencyCode,
      partnerId: TestConstants.stubPaymentRequestPartnerId,
      partnerName: TestConstants.stubPaymentRequestPartnerName,
      locationId: TestConstants.stubPaymentRequestLocationId,
      locationName: TestConstants.stubPaymentRequestLocationName,
      paymentInfo: TestConstants.stubPaymentRequestPaymentInfo,
      walletBalance: TestConstants.stubTokenCurrencyWalletBalance,
      date: TestConstants.stubDateFromLastYearString,
      lastUpdatedDate: TestConstants.stubDateString,
      tokensToFiatConversionRate:
          TestConstants.stubPaymentRequestConversionRate,
      expirationTimeLeftInSeconds: stubExpirationTimeInSeconds,
      expirationTimeStamp: stubExpirationTimeStamp);

  static const stubPaymentRequestInsufficientBalance =
      PaymentRequestResponseModel(
    paymentRequestId: TestConstants.stubPaymentRequestId,
    status: TestConstants.stubPaymentRequestStatus,
    totalInToken: TestConstants.stubPaymentRequestAmountInTokens,
    requestedAmountInTokens: TestConstants.stubPaymentRequestAmountInTokens,
    totalInCurrency: TestConstants.stubPaymentRequestTotalInCurrency,
    sendingAmountInToken: stubSendingAmountInToken,
    currencyCode: TestConstants.stubPaymentRequestCurrencyCode,
    partnerId: TestConstants.stubPaymentRequestPartnerId,
    partnerName: TestConstants.stubPaymentRequestPartnerName,
    locationId: TestConstants.stubPaymentRequestLocationId,
    locationName: TestConstants.stubPaymentRequestLocationName,
    paymentInfo: TestConstants.stubPaymentRequestPaymentInfo,
    walletBalance: TestConstants.stubTokenCurrencyWalletInsufficientBalance,
    date: TestConstants.stubDateString,
    lastUpdatedDate: TestConstants.stubDateString,
    tokensToFiatConversionRate: TestConstants.stubPaymentRequestConversionRate,
    expirationTimeLeftInSeconds: stubExpirationTimeInSeconds,
    expirationTimeStamp: stubExpirationTimeStamp,
  );

//endregion Payment requests

// region Earn details

//end region Earn details

// region Hotel Welcome

  static const stubPartnerMessageId = 'TestPartnerMessageId';

  static final stubPartnerMessage = PartnerMessageResponseModel(
    partnerMessageId: 'TestPartnerMessageId',
    partnerId: 'TestPartnerId',
    partnerName: 'TestPartnerName',
    locationId: null,
    locationName: null,
    customerId: 'TestCustomerId',
    timestamp: '2019-09-17T07:28:13.368Z',
    subject: 'Test Subject',
    message: '<html><body><p>Test message</p></body></html>',
  );

  static final stubCustomer = CustomerResponseModel(
    email: TestConstants.stubEmail,
    phoneNumber: TestConstants.stubPhoneNumber,
    firstName: TestConstants.stubFirstName,
    lastName: TestConstants.stubLastName,
    isEmailVerified: true,
    isPhoneNumberVerified: true,
    isAccountBlocked: false,
    phoneCountryCode: TestConstants.stubCountryCodePhoneCode,
    phoneCountryCodeId: TestConstants.stubCountryCodeId,
    countryOfNationalityId: TestConstants.stubCountryId,
    countryOfNationalityName: TestConstants.stubCountryName,
    hasPin: true,
    linkedPartnerId: null,
  );

// endregion Hotel Welcome

//region Customer
  static final verifiedCustomer = CustomerResponseModel(
    firstName: TestConstants.stubFirstName,
    lastName: TestConstants.stubLastName,
    phoneNumber: TestConstants.stubValidPhoneNumber,
    email: TestConstants.stubEmail,
    isEmailVerified: true,
    isPhoneNumberVerified: true,
    isAccountBlocked: false,
    phoneCountryCode: TestConstants.stubCountryCodePhoneCode,
    phoneCountryCodeId: TestConstants.stubCountryCodeId,
    countryOfNationalityId: TestConstants.stubCountryId,
    countryOfNationalityName: TestConstants.stubCountryName,
    hasPin: true,
    linkedPartnerId: null,
  );

  static final nonVerifiedCustomer = CustomerResponseModel(
    firstName: TestConstants.stubFirstName,
    lastName: TestConstants.stubLastName,
    phoneNumber: null,
    email: TestConstants.stubEmail,
    isEmailVerified: false,
    isPhoneNumberVerified: false,
    isAccountBlocked: false,
    phoneCountryCode: null,
    phoneCountryCodeId: null,
    countryOfNationalityId: TestConstants.stubCountryId,
    countryOfNationalityName: TestConstants.stubCountryName,
    hasPin: true,
    linkedPartnerId: null,
  );

  static final nonVerifiedPhoneCustomer = CustomerResponseModel(
    firstName: TestConstants.stubFirstName,
    lastName: TestConstants.stubLastName,
    phoneNumber: null,
    email: TestConstants.stubEmail,
    isEmailVerified: true,
    isPhoneNumberVerified: false,
    isAccountBlocked: false,
    phoneCountryCode: null,
    phoneCountryCodeId: null,
    countryOfNationalityId: TestConstants.stubCountryId,
    countryOfNationalityName: TestConstants.stubCountryName,
    hasPin: true,
    linkedPartnerId: null,
  );

  static final verifiedEmailNonVerifiedPhoneCustomer = CustomerResponseModel(
    firstName: TestConstants.stubFirstName,
    lastName: TestConstants.stubLastName,
    phoneNumber: TestConstants.stubValidPhoneNumber,
    email: TestConstants.stubEmail,
    isEmailVerified: false,
    isPhoneNumberVerified: true,
    isAccountBlocked: false,
    phoneCountryCode: TestConstants.stubCountryCodePhoneCode,
    phoneCountryCodeId: TestConstants.stubCountryCodeId,
    countryOfNationalityId: TestConstants.stubCountryId,
    countryOfNationalityName: TestConstants.stubCountryName,
    hasPin: true,
    linkedPartnerId: null,
  );

  static final emailVerifiedCustomer = CustomerResponseModel(
    firstName: TestConstants.stubFirstName,
    lastName: TestConstants.stubLastName,
    phoneNumber: null,
    email: TestConstants.stubEmail,
    isEmailVerified: true,
    isPhoneNumberVerified: false,
    isAccountBlocked: false,
    phoneCountryCode: null,
    phoneCountryCodeId: null,
    countryOfNationalityId: TestConstants.stubCountryId,
    countryOfNationalityName: TestConstants.stubCountryName,
    hasPin: true,
    linkedPartnerId: null,
  );

//endregion Customer

  //region Wallet
  static final stubLinkCodeRequestResponseModel =
      LinkCodeRequestResponseModel.fromJson({'LinkCode': '321'});

  static final stubCurrencyConverterResponseModel =
      CurrencyConverterResponseModel.fromJson({'Amount': '1'});

  //endregion Wallet

  static const stubPhoneVerificationCode = '1234';

  static const stubInStockCount = 10;
  static const stubSoldCount = 2;
  static const stubOutOfStockCount = 0;
  static const stubTokenPrecision = 5;
  static const stubVerificationCodeExpirationPeriod = Duration(minutes: 1);
  static const stubMinLength = 8;
  static const stubMaxLength = 100;
  static const stubMinUpperCase = 1;
  static const stubMinLowerCase = 1;
  static const stubMinNumbers = 1;
  static const stubMinSpecialSymbols = 1;
  static const stubSpecialCharacters = '!@#\$%';
  static const canUseSpaces = true;
  static const stubBaseCurrency = 'AED';
  static const stubOutdatedAppVersion = '0.0.7';
  static const stubLatestAppVersion = '0.0.8';
  static const stubLatestMandatoryUpgradeAppVersion = '0.0.8';
  static const stubLinkWalletAppUrlTemplate =
      'http://www.WalletAppUrlTemplate.com/';

  static final stubMobileSettings = MobileSettings(
    supportPhoneNumber: TestConstants.stubPhoneNumber,
    supportEmail: TestConstants.stubValidEmail,
    termsOfUseUrl: stubTermsUrl,
    privacyUrl: stubTermsUrl,
    tokenPrecision: stubTokenPrecision,
    baseCurrency: stubBaseCurrency,
    tokenSymbol: stubTokenSymbol,
    registrationMobileSettings: const RegistrationMobileSettings(
        verificationCodeExpirationPeriod: stubVerificationCodeExpirationPeriod),
    passwordStrength: const PasswordStrength(
      minLength: stubMinLength,
      maxLength: stubMaxLength,
      minUpperCase: stubMinUpperCase,
      minLowerCase: stubMinLowerCase,
      minNumbers: stubMinNumbers,
      minSpecialSymbols: stubMinSpecialSymbols,
      specialCharacters: stubSpecialCharacters,
      canUseSpaces: canUseSpaces,
    ),
    appVersion: const AppVersion(
      latestAppVersion: stubLatestAppVersion,
      latestMandatoryUpgradeAppVersion: stubLatestMandatoryUpgradeAppVersion,
    ),
    dAppMobileSettings: DAppMobileSettings.fromJson(
      const {
        'LinkWalletAppUrlTemplate':
            'https://customer-website.mavn-dev.open-source.exchange/en/dapp-linking?internal-address={internalAddress}&link-code={linkCode}'
      },
    ),
    pinCode: stubPinCode,
  );

  static const stubSpendRuleId = 'stubId';

  static const stubInstalmentId = 'stubInstalmentId';

  static const stubInstalmentName = 'stubInstalmentName';

  static const stubDoubleAmountInCurrency = 123.0;

  static final stubAmountInFiat = FiatCurrency(
    value: stubDoubleAmountInCurrency,
    assetSymbol: stubTokenSymbol,
  );

  static const stubId = 'stubId';
  static const stubMessageGroupId = 'stubMessageGroupId';

  static const stubPinCode = PinCode(
    pinCodeLength: 4,
    pinCodeMaximumAttemptCount: 5,
    pinCodeWarningAttemptCount: 3,
  );
  static const stubContactEmailSubject = 'stubContactEmailSubject';
  static const stubContactEmailBody = 'stubContactEmailBody';
}
