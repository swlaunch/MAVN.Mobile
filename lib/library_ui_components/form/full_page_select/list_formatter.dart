import 'package:collection/collection.dart';
import 'package:lykke_mobile_mavn/library_utils/string_utils.dart';

typedef _DisplayValueSelector<T> = String Function(T selectedValue);

class ListFormatter {
  static List<dynamic> sortAndGroupAlphabetically<T>(
    List<T> list,
    _DisplayValueSelector displayValueSelector,
  ) {
    list.sort(
      (a, b) => displayValueSelector(a).compareTo(displayValueSelector(b)),
    );

    final groupedList = groupBy<T, String>(
      list,
      (item) => displayValueSelector(item).substring(0, 1).toUpperCase(),
    );

    final listWithHeadings = <dynamic>[];
    groupedList.forEach((key, group) {
      listWithHeadings
        ..add(ListHeading(key))
        ..addAll(group);
    });
    return listWithHeadings;
  }

  static List<T> filter<T>(
    List<T> list,
    String query,
    _DisplayValueSelector displayValueSelector,
  ) =>
      StringUtils.isNullOrWhitespace(query)
          ? list
          : list
              .where(
                (item) => displayValueSelector(item)
                    .toLowerCase()
                    .startsWith(query.trim().toLowerCase()),
              )
              .toList();
}

class ListHeading {
  ListHeading(this.text);

  final String text;
}
