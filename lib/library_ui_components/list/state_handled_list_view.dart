import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/pagination_error_state.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/empty_list_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

const _defaultPadding = EdgeInsets.all(16);

class StateHandledListWidget<T> extends StatelessWidget {
  const StateHandledListWidget({
    this.data,
    this.onItemTap,
    this.isInitiallyLoading,
    this.isLoading,
    this.isEmpty,
    this.emptyIcon,
    this.emptyText,
    this.errorText,
    this.errorPadding = _defaultPadding,
    this.padding = _defaultPadding,
    this.backgroundColor,
    this.showError,
    this.itemBuilder,
    this.separatorBuilder,
    this.retryOnError,
  });

  final List<T> data;
  final Function onItemTap;
  final bool isInitiallyLoading;
  final bool isLoading;
  final bool isEmpty;
  final String emptyIcon;
  final String emptyText;
  final String errorText;
  final EdgeInsets errorPadding;
  final EdgeInsets padding;
  final Color backgroundColor;
  final bool showError;
  final Function(T item, Function onTap) itemBuilder;
  final Function(int index) separatorBuilder;
  final VoidCallback retryOnError;

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return _buildEmptyState();
    } else {
      return _buildNonEmptyState();
    }
  }

  Widget _buildEmptyState() => LayoutBuilder(
        builder: (context, viewportConstraints) => SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
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
                    physics: const NeverScrollableScrollPhysics(),
                    padding: padding,
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) =>
                        itemBuilder(data[index], onItemTap),
                    separatorBuilder: (context, position) =>
                        separatorBuilder(position),
                  ),
                ),
              if (showError) _buildError(),
            ],
          ),
          if (isInitiallyLoading) const Center(child: Spinner()),
          if (isLoading)
            const Align(
                alignment: Alignment.bottomCenter,
                child: LinearProgressIndicator()),
        ]),
      );

  Padding _buildError() => Padding(
      padding: errorPadding,
      child: PaginationErrorWidget(
        errorText: errorText,
        onRetry: retryOnError,
      ));
}
