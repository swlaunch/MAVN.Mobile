import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/offer_type.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/spend_rules_response_model.dart';
import 'package:lykke_mobile_mavn/feature_home/helpers/spend_rule_carousel_helper.dart';

import '../../test_constants.dart';

SpendRule stubSpendRuleHospitality(String title) => SpendRule(
      amountInCurrency: TestConstants.stubAmountInCurrency,
      amountInTokens: TestConstants.stubAmountInTokens,
      currencyName: TestConstants.stubCurrencyName,
      id: TestConstants.stubHospitalityId,
      title: title,
      description: TestConstants.stubSpendRuleDescription,
      imageUrl: null,
      type: OfferVertical.hospitality,
      partners: [TestConstants.stubPartner],
      creationDate: TestConstants.stubCreationDate,
    );

SpendRule stubSpendRuleProperty(String title) => SpendRule(
      amountInCurrency: TestConstants.stubAmountInCurrency,
      amountInTokens: TestConstants.stubAmountInTokens,
      currencyName: TestConstants.stubCurrencyName,
      id: TestConstants.stubRealEstateId,
      title: title,
      description: TestConstants.stubSpendRuleDescription,
      imageUrl: null,
      type: OfferVertical.realEstate,
      partners: [TestConstants.stubPartner],
      creationDate: TestConstants.stubCreationDate,
    );

void main() {
  group('SpendRuleCarouselHelper tests', () {
    setUp(() {});

    test(
        'getSpendRuleListItems - '
        'show 3 hospitality, 2 real estate items', () {
      final spendRuleList = [
        stubSpendRuleProperty('Property 1'),
        stubSpendRuleHospitality('Hospitality 1'),
        stubSpendRuleProperty('Property 2'),
        stubSpendRuleHospitality('Hospitality 2'),
        stubSpendRuleProperty('Property 3'),
        stubSpendRuleHospitality('Hospitality 3'),
        stubSpendRuleProperty('Property 4'),
        stubSpendRuleHospitality('Hospitality 4'),
        stubSpendRuleProperty('Property 5'),
        stubSpendRuleHospitality('Hospitality 5'),
      ];

      final spendRuleWidgetList =
          SpendRuleCarouselHelper.getSpendRuleCarouselItems(spendRuleList)
              .toList();

      expect(spendRuleWidgetList.length, 5);
      expect(spendRuleWidgetList[0].title, 'Hospitality 1');
      expect(spendRuleWidgetList[1].title, 'Hospitality 2');
      expect(spendRuleWidgetList[2].title, 'Hospitality 3');
      expect(spendRuleWidgetList[3].title, 'Property 1');
      expect(spendRuleWidgetList[4].title, 'Property 2');
    });

    test(
        'getSpendRuleListItems - '
        'show 2 hospitality, 3 real estate items', () {
      final spendRuleList = [
        stubSpendRuleProperty('Property 1'),
        stubSpendRuleHospitality('Hospitality 1'),
        stubSpendRuleProperty('Property 2'),
        stubSpendRuleHospitality('Hospitality 2'),
        stubSpendRuleProperty('Property 3'),
        stubSpendRuleProperty('Property 4'),
        stubSpendRuleProperty('Property 5'),
      ];

      final spendRuleWidgetList =
          SpendRuleCarouselHelper.getSpendRuleCarouselItems(spendRuleList)
              .toList();

      expect(spendRuleWidgetList.length, 5);
      expect(spendRuleWidgetList[0].title, 'Hospitality 1');
      expect(spendRuleWidgetList[1].title, 'Hospitality 2');
      expect(spendRuleWidgetList[2].title, 'Property 1');
      expect(spendRuleWidgetList[3].title, 'Property 2');
      expect(spendRuleWidgetList[4].title, 'Property 3');
    });
  });

  test(
      'getSpendRuleListItems - '
      'show 1 hospitality, 4 real estate items', () {
    final spendRuleList = [
      stubSpendRuleProperty('Property 1'),
      stubSpendRuleHospitality('Hospitality 1'),
      stubSpendRuleProperty('Property 2'),
      stubSpendRuleProperty('Property 3'),
      stubSpendRuleProperty('Property 4'),
      stubSpendRuleProperty('Property 5'),
    ];

    final spendRuleWidgetList =
        SpendRuleCarouselHelper.getSpendRuleCarouselItems(spendRuleList)
            .toList();

    expect(spendRuleWidgetList.length, 5);
    expect(spendRuleWidgetList[0].title, 'Hospitality 1');
    expect(spendRuleWidgetList[1].title, 'Property 1');
    expect(spendRuleWidgetList[2].title, 'Property 2');
    expect(spendRuleWidgetList[3].title, 'Property 3');
    expect(spendRuleWidgetList[4].title, 'Property 4');
  });

  test(
      'getSpendRuleListItems - '
      '5 real estate items', () {
    final spendRuleList = [
      stubSpendRuleProperty('Property 1'),
      stubSpendRuleProperty('Property 2'),
      stubSpendRuleProperty('Property 3'),
      stubSpendRuleProperty('Property 4'),
      stubSpendRuleProperty('Property 5'),
      stubSpendRuleProperty('Property 6'),
    ];

    final spendRuleWidgetList =
        SpendRuleCarouselHelper.getSpendRuleCarouselItems(spendRuleList)
            .toList();

    expect(spendRuleWidgetList.length, 5);
    expect(spendRuleWidgetList[0].title, 'Property 1');
    expect(spendRuleWidgetList[1].title, 'Property 2');
    expect(spendRuleWidgetList[2].title, 'Property 3');
    expect(spendRuleWidgetList[3].title, 'Property 4');
    expect(spendRuleWidgetList[4].title, 'Property 5');
  });

  test(
      'getSpendRuleListItems - '
      'show 4 estate items, 1 hospitality item', () {
    final spendRuleList = [
      stubSpendRuleProperty('Property 1'),
      stubSpendRuleHospitality('Hospitality 1'),
      stubSpendRuleHospitality('Hospitality 2'),
      stubSpendRuleHospitality('Hospitality 3'),
      stubSpendRuleHospitality('Hospitality 4'),
      stubSpendRuleHospitality('Hospitality 5'),
    ];

    final spendRuleWidgetList =
        SpendRuleCarouselHelper.getSpendRuleCarouselItems(spendRuleList)
            .toList();

    expect(spendRuleWidgetList.length, 5);
    expect(spendRuleWidgetList[0].title, 'Hospitality 1');
    expect(spendRuleWidgetList[1].title, 'Hospitality 2');
    expect(spendRuleWidgetList[2].title, 'Hospitality 3');
    expect(spendRuleWidgetList[3].title, 'Hospitality 4');
    expect(spendRuleWidgetList[4].title, 'Property 1');
  });

  test(
      'getSpendRuleListItems - '
      'show 5 hospitality items', () {
    final spendRuleList = [
      stubSpendRuleHospitality('Hospitality 1'),
      stubSpendRuleHospitality('Hospitality 2'),
      stubSpendRuleHospitality('Hospitality 3'),
      stubSpendRuleHospitality('Hospitality 4'),
      stubSpendRuleHospitality('Hospitality 5'),
      stubSpendRuleHospitality('Hospitality 6'),
    ];

    final spendRuleWidgetList =
        SpendRuleCarouselHelper.getSpendRuleCarouselItems(spendRuleList)
            .toList();

    expect(spendRuleWidgetList.length, 5);
    expect(spendRuleWidgetList[0].title, 'Hospitality 1');
    expect(spendRuleWidgetList[1].title, 'Hospitality 2');
    expect(spendRuleWidgetList[2].title, 'Hospitality 3');
    expect(spendRuleWidgetList[3].title, 'Hospitality 4');
    expect(spendRuleWidgetList[4].title, 'Hospitality 5');
  });

  test(
      'getSpendRuleListItems - '
      'show 3 hospitality, 1 real estate items', () {
    final spendRuleList = [
      stubSpendRuleProperty('Property 1'),
      stubSpendRuleHospitality('Hospitality 1'),
      stubSpendRuleHospitality('Hospitality 2'),
      stubSpendRuleHospitality('Hospitality 3'),
    ];

    final spendRuleWidgetList =
        SpendRuleCarouselHelper.getSpendRuleCarouselItems(spendRuleList)
            .toList();

    expect(spendRuleWidgetList.length, 4);
    expect(spendRuleWidgetList[0].title, 'Hospitality 1');
    expect(spendRuleWidgetList[1].title, 'Hospitality 2');
    expect(spendRuleWidgetList[2].title, 'Hospitality 3');
    expect(spendRuleWidgetList[3].title, 'Property 1');
  });

  test(
      'getSpendRuleListItems - '
      'show 4 real estate items', () {
    final spendRuleList = [
      stubSpendRuleProperty('Property 1'),
      stubSpendRuleProperty('Property 2'),
      stubSpendRuleProperty('Property 3'),
      stubSpendRuleProperty('Property 4'),
    ];

    final spendRuleWidgetList =
        SpendRuleCarouselHelper.getSpendRuleCarouselItems(spendRuleList)
            .toList();

    expect(spendRuleWidgetList.length, 4);
    expect(spendRuleWidgetList[0].title, 'Property 1');
    expect(spendRuleWidgetList[1].title, 'Property 2');
    expect(spendRuleWidgetList[2].title, 'Property 3');
    expect(spendRuleWidgetList[3].title, 'Property 4');
  });

  test(
      'getSpendRuleListItems - '
      'show 4 hospitality items', () {
    final spendRuleList = [
      stubSpendRuleProperty('Hospitality 1'),
      stubSpendRuleProperty('Hospitality 2'),
      stubSpendRuleProperty('Hospitality 3'),
      stubSpendRuleProperty('Hospitality 4'),
    ];

    final spendRuleWidgetList =
        SpendRuleCarouselHelper.getSpendRuleCarouselItems(spendRuleList)
            .toList();

    expect(spendRuleWidgetList.length, 4);
    expect(spendRuleWidgetList[0].title, 'Hospitality 1');
    expect(spendRuleWidgetList[1].title, 'Hospitality 2');
    expect(spendRuleWidgetList[2].title, 'Hospitality 3');
    expect(spendRuleWidgetList[3].title, 'Hospitality 4');
  });
}
