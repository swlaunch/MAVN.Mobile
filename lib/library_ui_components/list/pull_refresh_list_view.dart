import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';

typedef _ListItemBuilder<T> = Widget Function(T listItem);

class PullToRefreshListView<T> extends StatelessWidget {
  const PullToRefreshListView({
    @required this.itemBuilder,
    @required this.itemsList,
    @required this.onRefresh,
    this.header,
  });

  final _ListItemBuilder<T> itemBuilder;
  final List<T> itemsList;
  final RefreshCallback onRefresh;
  final Widget header;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: onRefresh,
        //This dummy future fixed the widget test
        color: ColorStyles.gold1,
        child: ListView.builder(
          itemCount: itemsList != null
              ? itemsList.length + (header != null ? 1 : 0)
              : 1,
          itemBuilder: (context, index) {
            //present the header if exists
            if (header != null && index == 0) {
              return header;
            }

            //subtract 1 from the index number to match the array values
            index -= 1;

            final item = itemsList[index];
            return itemBuilder(item);
          },
        ),
      );
}
