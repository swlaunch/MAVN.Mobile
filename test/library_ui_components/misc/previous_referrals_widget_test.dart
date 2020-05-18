import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_ui_models/previous_referrals_list/previous_referrals_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/referral/response_model/referral_response_model.dart';
import 'package:lykke_mobile_mavn/library_models/token_currency.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/previous_referrals_widget.dart';

import '../../helpers/golden_test_helper.dart';
import '../../helpers/widget_frames.dart';
import '../../test_constants.dart';

const Key _previousReferralWidget = Key('previousReferralsWidget');

void main() {
  group('previous referral widget test', () {
    setUp(() {
      initScreenshots();
    });

    testWidgets('staking info null', (widgetTester) async {
      await _givenAPreviousReferralsWidgetIsPresent(
        widgetTester,
        PreviousReferralModel(
          referralStatus: ReferralStatus.ongoing,
          referralType: ReferralType.hospitality,
          referralName: LocalizedStringBuilder.custom('John Although'),
          referralCreationDate: DateTime.parse(TestConstants.stubCreationDate),
          rewardValue: const TokenCurrency(value: '100'),
          partnerName: 'Great Hotels inc',
          hasStaking: false,
          stakingInfo: null,
          progressInfo: ProgressInfoModel(
            earnedAmount: const TokenCurrency(value: '100'),
            totalToEarnAmount: const TokenCurrency(value: '1000'),
            checkpointsAchieved: 1,
            checkpointsTotal: 4,
          ),
          isApproximate: false,
          referralEmail: TestConstants.stubEmail,
        ),
      );

      await thenWidgetShouldMatchScreenshot(widgetTester,
          find.byKey(_previousReferralWidget), 'previous_referrals_no_staking');
    });

    testWidgets('progress info, approximate reward', (widgetTester) async {
      await _givenAPreviousReferralsWidgetIsPresent(
        widgetTester,
        PreviousReferralModel(
          referralStatus: ReferralStatus.ongoing,
          referralType: ReferralType.hospitality,
          referralName: LocalizedStringBuilder.custom('John Although'),
          referralCreationDate: DateTime.parse(TestConstants.stubCreationDate),
          rewardValue: const TokenCurrency(value: '100'),
          partnerName: 'Great Hotels inc',
          hasStaking: false,
          stakingInfo: null,
          progressInfo: ProgressInfoModel(
            earnedAmount: const TokenCurrency(value: '100'),
            totalToEarnAmount: const TokenCurrency(value: '1000'),
            checkpointsAchieved: 1,
            checkpointsTotal: 4,
          ),
          isApproximate: true,
          referralEmail: TestConstants.stubEmail,
        ),
      );

      await thenWidgetShouldMatchScreenshot(
          widgetTester,
          find.byKey(_previousReferralWidget),
          'previous_referrals_no_staking_approximate_reward');
    });

    testWidgets('staking info present', (widgetTester) async {
      await _givenAPreviousReferralsWidgetIsPresent(
        widgetTester,
        PreviousReferralModel(
          referralStatus: ReferralStatus.ongoing,
          referralType: ReferralType.hospitality,
          referralName: LocalizedStringBuilder.custom('John Although'),
          referralCreationDate: DateTime.parse(TestConstants.stubCreationDate),
          rewardValue: const TokenCurrency(value: '100'),
          partnerName: 'Great Hotels inc',
          hasStaking: true,
          stakingInfo: StakingInfoModel(
            stakingAmount: const TokenCurrency(value: '1000'),
            stakingContact: 'Peter',
            stakingTimeLeft: 2,
            stakingTotalTime: 10,
          ),
          progressInfo: null,
          isApproximate: false,
          referralEmail: TestConstants.stubEmail,
        ),
      );

      await thenWidgetShouldMatchScreenshot(widgetTester,
          find.byKey(_previousReferralWidget), 'previous_referrals_staking');
    });

    testWidgets('realestate referral type', (widgetTester) async {
      await _givenAPreviousReferralsWidgetIsPresent(
        widgetTester,
        PreviousReferralModel(
          referralStatus: ReferralStatus.ongoing,
          referralType: ReferralType.realEstate,
          referralName: LocalizedStringBuilder.custom('John Although'),
          referralCreationDate: DateTime.parse(TestConstants.stubCreationDate),
          rewardValue: const TokenCurrency(value: '100'),
          partnerName: 'Great Hotels inc',
          hasStaking: true,
          stakingInfo: StakingInfoModel(
            stakingAmount: const TokenCurrency(value: '1000'),
            stakingContact: 'Peter',
            stakingTimeLeft: 2,
            stakingTotalTime: 10,
          ),
          progressInfo: null,
          isApproximate: false,
          referralEmail: TestConstants.stubEmail,
        ),
      );

      await thenWidgetShouldMatchScreenshot(widgetTester,
          find.byKey(_previousReferralWidget), 'previous_referrals_realestate');
    });

    testWidgets('reward information missing', (widgetTester) async {
      await _givenAPreviousReferralsWidgetIsPresent(
        widgetTester,
        PreviousReferralModel(
          referralStatus: ReferralStatus.ongoing,
          referralType: ReferralType.hospitality,
          referralName: LocalizedStringBuilder.custom('John Although'),
          referralCreationDate: DateTime.parse(TestConstants.stubCreationDate),
          rewardValue: null,
          partnerName: 'Great Hotels inc',
          hasStaking: true,
          stakingInfo: StakingInfoModel(
            stakingAmount: const TokenCurrency(value: '1000'),
            stakingContact: 'Peter',
            stakingTimeLeft: 2,
            stakingTotalTime: 10,
          ),
          progressInfo: null,
          isApproximate: false,
          referralEmail: TestConstants.stubEmail,
        ),
      );

      await thenWidgetShouldMatchScreenshot(
          widgetTester,
          find.byKey(_previousReferralWidget),
          'previous_referrals_reward_info_missing');
    });

    testWidgets('no staking or progress info, reward info present',
        (widgetTester) async {
      await _givenAPreviousReferralsWidgetIsPresent(
        widgetTester,
        PreviousReferralModel(
          referralType: ReferralType.hospitality,
          referralName: LocalizedStringBuilder.custom('John Although'),
          referralCreationDate: DateTime.parse(TestConstants.stubCreationDate),
          rewardValue: const TokenCurrency(value: '100'),
          partnerName: 'Great Hotels inc',
          stakingInfo: null,
          progressInfo: null,
          isApproximate: false,
          referralEmail: TestConstants.stubEmail,
        ),
      );

      await thenWidgetShouldMatchScreenshot(
          widgetTester,
          find.byKey(_previousReferralWidget),
          'previous_referrals_reward_info_present_no_staking_no_progress');
    });

    testWidgets('no staking or progress info, reward info present',
        (widgetTester) async {
      await _givenAPreviousReferralsWidgetIsPresent(
        widgetTester,
        PreviousReferralModel(
          referralType: ReferralType.friend,
          referralName: LocalizedStringBuilder.custom('John Although'),
          referralCreationDate: DateTime.parse(TestConstants.stubCreationDate),
          rewardValue: const TokenCurrency(value: '100'),
          partnerName: 'Great Hotels inc',
          stakingInfo: null,
          progressInfo: null,
          referralEmail: TestConstants.stubEmail,
        ),
      );

      await thenWidgetShouldMatchScreenshot(
          widgetTester,
          find.byKey(_previousReferralWidget),
          'previous_referrals_app_referral');
    });

    testWidgets(
        'no staking or progress info, reward info present, approximate reward',
        (widgetTester) async {
      await _givenAPreviousReferralsWidgetIsPresent(
        widgetTester,
        PreviousReferralModel(
          referralType: ReferralType.hospitality,
          referralName: LocalizedStringBuilder.custom('John Although'),
          referralCreationDate: DateTime.parse(TestConstants.stubCreationDate),
          rewardValue: const TokenCurrency(value: '100'),
          partnerName: 'Great Hotels inc',
          stakingInfo: null,
          progressInfo: null,
          isApproximate: true,
          referralEmail: TestConstants.stubEmail,
        ),
      );

      await thenWidgetShouldMatchScreenshot(
        widgetTester,
        find.byKey(_previousReferralWidget),
        // ignore: lines_longer_than_80_chars
        'previous_referrals_approximate_reward_info_present_no_staking_no_progress',
      );
    });

    testWidgets('referralEmail not present', (widgetTester) async {
      await _givenAPreviousReferralsWidgetIsPresent(
        widgetTester,
        PreviousReferralModel(
          referralStatus: ReferralStatus.ongoing,
          referralType: ReferralType.hospitality,
          referralName: LocalizedStringBuilder.custom('John Although'),
          referralCreationDate: DateTime.parse(TestConstants.stubCreationDate),
          rewardValue: const TokenCurrency(value: '100'),
          partnerName: 'Great Hotels inc',
          hasStaking: true,
          stakingInfo: StakingInfoModel(
            stakingAmount: const TokenCurrency(value: '1000'),
            stakingContact: 'Peter',
            stakingTimeLeft: 2,
            stakingTotalTime: 10,
          ),
          progressInfo: null,
          isApproximate: false,
          referralEmail: null,
        ),
      );

      await thenWidgetShouldMatchScreenshot(
          widgetTester,
          find.byKey(_previousReferralWidget),
          'previous_referrals_no_ref_email');
    });
  });
}

Future _givenAPreviousReferralsWidgetIsPresent(
    WidgetTester tester, PreviousReferralModel model) async {
  await tester.pumpWidget(
    TestAppFrame(
      child: Scaffold(
        body: PreviousReferralsWidget(referral: model),
      ),
    ),
  );
}
