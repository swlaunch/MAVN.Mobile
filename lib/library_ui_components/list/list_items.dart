import 'package:flutter/widgets.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';

class OrderedListItems<E> extends StatelessWidget {
  const OrderedListItems({
    @required this.items,
    @required this.itemBuilder,
    this.type = OrderedListType.bulleted,
    this.numberStyle,
    Key key,
  }) : super(key: key);

  final List<E> items;
  final OrderedListType type;
  final Function(E item) itemBuilder;
  final TextStyle numberStyle;

  @override
  Widget build(BuildContext context) => Column(
      children: _buildChildren()
          .map((child) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: child,
              ))
          .toList());

  List<Widget> _buildChildren() => type == OrderedListType.numbered
      ? _buildNumberedItems()
      : _buildBulletedItems();

  List<Row> _buildNumberedItems() => items
      .asMap()
      .map((key, item) => MapEntry(
          key,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${key + 1}.', style: numberStyle),
              const SizedBox(width: 4),
              itemBuilder(item),
            ],
          )))
      .values
      .toList();

  List<Widget> _buildBulletedItems() => items
      .map((item) => Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: ColorStyles.progressBar),
              ),
              const SizedBox(width: 12),
              itemBuilder(item),
            ],
          ))
      .toList();
}

enum OrderedListType { numbered, bulleted }
