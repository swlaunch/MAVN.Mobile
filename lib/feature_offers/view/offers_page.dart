import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_earn/view/earn_rule_list_page.dart';
import 'package:lykke_mobile_mavn/feature_vouchers/view/voucher_list_page.dart';

class OffersPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final localizedStrings = useLocalizedStrings();
    return DefaultTabController(
      //TODO add initial index
      length: 2,
      child: Scaffold(
          backgroundColor: ColorStyles.alabaster,
          appBar: AppBar(
            backgroundColor: ColorStyles.alabaster,
            title:
                Text(localizedStrings.offers, style: TextStyles.h1PageHeader),
            bottom: TabBar(
              indicatorColor: ColorStyles.bitterSweet,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    localizedStrings.earn.toUpperCase(),
                    style: TextStyles.darkBodyBody2Regular
                        .copyWith(color: ColorStyles.bitterSweet),
                  ),
                ),
                Tab(
                  child: Text(
                    localizedStrings.redeem.toUpperCase(),
                    style: TextStyles.darkBodyBody2Regular
                        .copyWith(color: ColorStyles.bitterSweet),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      EarnRuleListPage(),
                      VoucherListPage(),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
