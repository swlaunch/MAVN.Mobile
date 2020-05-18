import 'package:lykke_mobile_mavn/base/remote_data_source/api/common/offer_type.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/spend_rules_response_model.dart';

class SpendRuleCarouselHelper {
  static const maxItems = 5;
  static const hospitalityItemCount = 3;

  // The items for the carousel should contain 'maxItems' items maximum.
  // The first 'hospitalityItemCount' items should be hospitality and
  // the rest realEstate.
  // If there are not enough items in one type to fill the list,
  // the list should be filled with the other type.
  // If the total number of items is less than the maximum then show all items.

  static List<SpendRule> getSpendRuleCarouselItems(
      List<SpendRule> spendRuleList) {
    final allHospitalityListItems = spendRuleList
        .where((spendRule) => spendRule.type == OfferVertical.hospitality);
    final allRealEstateListItems = spendRuleList
        .where((spendRule) => spendRule.type == OfferVertical.realEstate);

    final hospitalityListItems =
        allHospitalityListItems.take(hospitalityItemCount).toList();

    final realEstateListItems =
        allRealEstateListItems.take(maxItems - hospitalityListItems.length);

    final totalItems = hospitalityListItems.length + realEstateListItems.length;

    if (totalItems < maxItems &&
        allHospitalityListItems.length > hospitalityItemCount) {
      hospitalityListItems.addAll(allHospitalityListItems
          .skip(hospitalityItemCount)
          .take(maxItems - totalItems));
    }

    return [...hospitalityListItems, ...realEstateListItems];
  }
}
