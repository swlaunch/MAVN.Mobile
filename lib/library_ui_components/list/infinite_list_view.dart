import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/pagination_error_state.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/empty_list_widget.dart';

const _defaultPadding = EdgeInsets.all(16);

class InfiniteListWidget<T> extends StatelessWidget {
  const InfiniteListWidget({
    this.data,
    this.loadData,
    this.onItemTap,
    this.isLoading,
    this.isEmpty,
    this.emptyIcon,
    this.emptyText,
    this.errorText,
    this.padding = _defaultPadding,
    this.errorPadding = _defaultPadding,
    this.backgroundColor,
    this.showError,
    this.itemBuilder,
    this.separatorBuilder,
    this.retryOnError,
  });

  final List<T> data;
  final VoidCallback loadData;
  final Function onItemTap;
  final bool isLoading;
  final bool isEmpty;
  final String emptyIcon;
  final String emptyText;
  final String errorText;
  final EdgeInsets padding;
  final EdgeInsets errorPadding;
  final Color backgroundColor;
  final bool showError;
  final Function(T item, Function onTap, BuildContext context) itemBuilder;
  final Function(int index) separatorBuilder;
  final VoidCallback retryOnError;

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return _buildEmptyState();
    } else {
      return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            final isEnd = scrollNotification is ScrollUpdateNotification &&
                scrollNotification.metrics.maxScrollExtent ==
                    scrollNotification.metrics.pixels;
            if (isEnd && loadData != null && !showError) loadData();
          },
          child: _buildNonEmptyState());
    }
  }

  Widget _buildEmptyState() => LayoutBuilder(
        builder: (context, viewportConstraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: EmptyListWidget(text: emptyText, asset: emptyIcon),
          ),
        ),
      );

  Widget _buildNonEmptyState() => Container(
        color: backgroundColor,
        child: Stack(children: [
          Column(
            children: [
              if (data.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: padding,
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) =>
                        itemBuilder(data[index], onItemTap, context),
                    separatorBuilder: (context, position) =>
                        separatorBuilder(position),
                  ),
                ),
              if (showError) _buildError(),
            ],
          ),
          if (isLoading) const LinearProgressIndicator(),
        ]),
      );

  Padding _buildError() => Padding(
      padding: errorPadding,
      child: PaginationErrorWidget(
        errorText: errorText,
        onRetry: retryOnError,
      ));
}
