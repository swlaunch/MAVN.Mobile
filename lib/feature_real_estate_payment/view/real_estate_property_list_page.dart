import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/real_estate_properties_response_model.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/spend_rules_response_model.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/bloc/real_estate_property_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_real_estate_payment/bloc/real_estate_property_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_icon_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/empty_list_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/heading.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/network_image_with_placeholder.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/null_safe_text.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';

class RealEstatePropertyListPage extends HookWidget {
  const RealEstatePropertyListPage(this._spendRule);

  static const double _sliverImageSize = 162;

  final SpendRule _spendRule;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();
    final propertyListBloc = usePropertyListBloc();
    final propertyListBlocState = useBlocState(propertyListBloc);

    void loadProperties() {
      propertyListBloc.loadProperties(_spendRule.id);
    }

    useEffect(() {
      loadProperties();
    }, [
      propertyListBloc,
    ]);

    void onPropertyTap(Property property) {
      router.pushInstalmentListPage(
        spendRuleId: _spendRule.id,
        property: property,
      );
    }

    return Scaffold(
      backgroundColor: ColorStyles.white,
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Heading(_spendRule.title),
                  const SizedBox(height: 16),
                  NullSafeText(
                    _spendRule.description,
                    style: TextStyles.darkBodyBody2RegularHigh,
                  ),
                  const SizedBox(height: 36),
                  if (propertyListBlocState is PropertyListLoadingState)
                    _buildLoadingState(),
                  if (propertyListBlocState is PropertyListEmptyState)
                    _buildEmptyListWidget(),
                  if (propertyListBlocState is PropertyListLoadedState)
                    _buildPropertyList(
                        propertyListBlocState.properties, onPropertyTap),
                  if (propertyListBlocState is PropertyListNetworkErrorState)
                    NetworkErrorWidget(onRetry: loadProperties),
                  if (propertyListBlocState is PropertyListErrorState)
                    _buildGenericErrorWidget(onTap: loadProperties),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) => SliverAppBar(
        expandedHeight: _sliverImageSize,
        floating: false,
        pinned: true,
        flexibleSpace: Container(
          color: ColorStyles.primaryDark,
          child: FlexibleSpaceBar(
            background: NetworkImageWithPlaceholder(
              imageUrl: _spendRule.imageUrl,
              height: _sliverImageSize + MediaQuery.of(context).padding.top,
              borderRadiusSize: 0,
            ),
          ),
        ),
      );

  Widget _buildLoadingState() => const Center(
        child: Spinner(),
      );

  Widget _buildEmptyListWidget() => EmptyListWidget(
        text: useLocalizedStrings().realEstateListNoPurchases,
        asset: SvgAssets.homeProperty,
      );

  Widget _buildPropertyList(List<Property> properties,
          Function(Property property) onPropertyTap) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            useLocalizedStrings().realEstateListChooseAProperty,
            style: TextStyles.darkHeadersH3,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, position) =>
                _PropertyItem(properties[position], onPropertyTap).build(),
            itemCount: properties.length,
          ),
          const Divider(
            thickness: 1,
            color: ColorStyles.paleLilac,
          )
        ],
      );

  Widget _buildGenericErrorWidget({VoidCallback onTap}) =>
      GenericErrorIconWidget(
        errorKey: const Key('genericError'),
        title: useLocalizedStrings().somethingIsNotRightError,
        text: useLocalizedStrings().offerDetailGenericError,
        icon: SvgAssets.genericError,
        onRetryTap: onTap,
      );
}

class _PropertyItem {
  _PropertyItem(this.property, this.onTap);

  final Property property;

  final Function(Property) onTap;

  Widget build() => InkWell(
        onTap: () => onTap(property),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: ColorStyles.paleLilac,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  property.name,
                  style: TextStyles.darkBodyBody2RegularHigh,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const StandardSizedSvg(SvgAssets.arrow),
            ],
          ),
        ),
      );
}
