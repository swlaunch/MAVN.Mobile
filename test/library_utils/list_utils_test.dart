import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/library_utils/list_utils.dart';

void main() {
  group('List utils tests', () {
    group('Sort by', () {
      test('Sort numbers', () {
        expect(ListUtils.sortBy([2, 3, null, 2, 5], (item) => item),
            [2, 2, 3, 5, null]);
      });

      test('Sort numbers in reverse', () {
        expect(
            ListUtils.sortBy(
              [2, 3, null, 2, 5],
              (item) => item,
              descendingOrder: true,
            ),
            [5, 3, 2, 2, null]);
      });

      test('Sort using selector', () {
        expect(
            ListUtils.sortBy(
                ['abc', 'gdsvg', null, 's'], (item) => item?.length),
            ['s', 'abc', 'gdsvg', null]);
      });

      test('Sort using selector reverse', () {
        expect(
            ListUtils.sortBy(
              ['abc', 'gdsvg', null, 's'],
              (item) => item?.length,
              descendingOrder: true,
            ),
            ['gdsvg', 'abc', 's', null]);
      });
    });
  });
}
