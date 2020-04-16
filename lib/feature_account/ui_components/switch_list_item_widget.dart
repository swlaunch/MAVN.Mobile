import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/select_list_item.dart';

class SwitchListItemWidget extends HookWidget {
  const SwitchListItemWidget({
    this.title,
    this.onChanged,
    this.initialSelectedState,
    this.onBeforeChange,
  });

  final String title;
  final Function(bool) onChanged;
  final Future<bool> Function(bool) onBeforeChange;
  final Future<bool> initialSelectedState;

  @override
  Widget build(BuildContext context) {
    final isSelectedInitialState =
        useFuture<bool>(initialSelectedState ?? Future.value(false));
    final isSelected = useState<bool>();

    if (isSelectedInitialState.hasData && isSelected.value == null) {
      isSelected.value = isSelectedInitialState.data;
    }

    Future<void> select() async {
      if (onBeforeChange != null) {
        final onBeforeChangeResult = await onBeforeChange(isSelected.value);

        if (onBeforeChangeResult != null && onBeforeChangeResult != true) {
          return;
        }
      }

      isSelected.value = !isSelected.value;
      if (onChanged != null) {
        onChanged(isSelected.value);
      }
    }

    return SelectListItem(
      valueKey: Key(title),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Text(title, style: TextStyles.darkBodyBody1RegularHigh)),
          Switch(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: isSelected.value ?? false,
            onChanged: (newValue) => select(),
          )
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 12, 12),
      onTap: select,
    );
  }
}
