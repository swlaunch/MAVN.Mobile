typedef _ComparableSelector<T, U> = Comparable<U> Function(T item);

class ListUtils {
  static bool isNullOrEmpty(List list) => list == null || list.isEmpty;

  static List<T> sortBy<T, U>(
    List<T> list,
    _ComparableSelector valueToCompare, {
    bool descendingOrder = false,
  }) {
    final listCopy = [...list]..sort((a, b) {
        final valueA = descendingOrder ? valueToCompare(b) : valueToCompare(a);
        final valueB = descendingOrder ? valueToCompare(a) : valueToCompare(b);

        if (valueA == null && valueB == null) {
          return 0;
        }

        if (valueA == null) {
          return descendingOrder ? -1 : 1;
        }

        if (valueB == null) {
          return descendingOrder ? 1 : -1;
        }

        return valueA.compareTo(valueB);
      });

    return listCopy;
  }
}
