import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/list_formatter.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dark_page_title.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/empty_list_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/icon_oval.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';
import 'package:lykke_mobile_mavn/library_utils/list_utils.dart';

typedef Widget _HeadingBuilder<String>(String headingItem);
typedef Widget _ListItemBuilder<T>(T listItem, String query);
typedef String _DisplayValueSelector<T>(T listItem);

class FullPageSelectList<T> extends HookWidget {
  const FullPageSelectList({
    @required this.itemBuilder,
    this.headingBuilder,
    this.pageTitle,
    this.valueKey,
    this.isLoading = false,
    this.errorText,
    this.list,
    this.onRetry,
    this.displayValueSelector,
    this.groupAlphabetically = false,
    this.showFilter = false,
    this.listPadding = const EdgeInsets.symmetric(horizontal: 24),
    this.filterHintText,
    this.useDarkHeader = false,
  });

  final _ListItemBuilder<T> itemBuilder;
  final _HeadingBuilder<String> headingBuilder;
  final String pageTitle;
  final ValueKey valueKey;
  final bool isLoading;
  final String errorText;
  final List<T> list;
  final VoidCallback onRetry;
  final _DisplayValueSelector displayValueSelector;
  final bool groupAlphabetically;
  final bool showFilter;
  final EdgeInsets listPadding;
  final String filterHintText;
  final bool useDarkHeader;

  @override
  Widget build(BuildContext context) {
    final router = useRouter();

    final filterTextEditingController =
        useCustomTextEditingController(rebuildOnChange: true);

    return ScaffoldWithAppBar(
      useDarkTheme: useDarkHeader,
      key: valueKey,
      title: useDarkHeader
          ? null
          : Text(pageTitle, style: TextStyles.darkHeadersH3),
      body: _buildContent(router, filterTextEditingController),
    );
  }

  Widget _buildContent(
    Router router,
    TextEditingController filterTextEditingController,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (showFilter) _buildFilter(filterTextEditingController),
          if (pageTitle != null && useDarkHeader)
            DarkPageTitle(pageTitle: pageTitle),
          _buildListContent(router, filterTextEditingController),
        ],
      );

  Widget _buildFilter(
    TextEditingController filterTextEditingController,
  ) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: TextField(
          controller: filterTextEditingController,
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorStyles.paleLilac,
            hintText: filterHintText,
            hintStyle: TextStyles.darkBodyBody2RegularHigh,
            contentPadding: const EdgeInsets.all(12),
            suffixIcon: filterTextEditingController.text == null ||
                    filterTextEditingController.text.isEmpty
                ? const _SearchButton()
                : _ClearButton(
                    textEditingController: filterTextEditingController,
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
          ),
        ),
      );

  Widget _buildListContent(
    Router router,
    TextEditingController filterTextEditingController,
  ) {
    if (isLoading) {
      return _buildCircularProgressIndicator();
    }

    if (errorText != null) {
      return GenericErrorWidget(
        valueKey: const Key('fullPageSelectListError'),
        text: errorText,
        onRetryTap: onRetry ?? () {},
      );
    }

    if (ListUtils.isNullOrEmpty(list)) {
      return _buildEmptyListWidget();
    }

    final filteredList = showFilter
        ? ListFormatter.filter(
            list,
            filterTextEditingController.text,
            displayValueSelector,
          )
        : list;

    if (filteredList.isEmpty) {
      return _buildEmptyListWidget();
    }

    final groupedList = groupAlphabetically
        ? ListFormatter.sortAndGroupAlphabetically(
            filteredList,
            displayValueSelector,
          )
        : filteredList;

    return _buildListView(groupedList, router, filterTextEditingController);
  }

  Widget _buildEmptyListWidget() => Expanded(
        child: SingleChildScrollView(
          child: EmptyListWidget(
            image: IconOval(
                child: SvgPicture.asset(
              SvgAssets.emptySearch,
              width: 80,
              height: 80,
            )),
            title: useLocalizedStrings().listNoResultsTitle,
            text: useLocalizedStrings().listNoResultsDetails,
          ),
        ),
      );

  Widget _buildCircularProgressIndicator() => const Expanded(
        child: Center(
          key: Key('fullPageSelectListLoadingSpinner'),
          child: CircularProgressIndicator(),
        ),
      );

  Widget _buildListView(
    List<dynamic> list,
    Router router,
    TextEditingController filterTextEditingController,
  ) =>
      Expanded(
        key: const Key('fullPageSelectList'),
        child: ListView.separated(
          padding: listPadding,
          itemBuilder: (context, i) {
            final item = list[i];

            if (item is ListHeading) {
              return headingBuilder(item.text);
            }

            return itemBuilder(item, filterTextEditingController.text.trim());
          },
          separatorBuilder: (context, i) {
            final isHeading = list[i] is ListHeading;
            final requiresSeparator = !isHeading;

            if (!requiresSeparator) {
              return const SizedBox();
            }

            return const Divider(
              height: 1,
              color: ColorStyles.paleLilac,
            );
          },
          itemCount: list.length,
        ),
      );
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(12),
        child: StandardSizedSvg(
          SvgAssets.search,
          color: ColorStyles.slateGrey,
        ),
      );
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({@required this.textEditingController});

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(
          Icons.close,
          size: 24,
          color: ColorStyles.slateGrey,
        ),
        iconSize: 24,
        padding: const EdgeInsets.all(0),
        onPressed: () {
          // The following is wrapped in a addPostFrameCallback to
          // avoid an exception
          // https://github.com/flutter/flutter/issues/17647
          WidgetsBinding.instance
              .addPostFrameCallback((_) => textEditingController.clear());
        },
      );
}
