import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/library_ui_components/form/full_page_select/list_formatter.dart';

void main() {
  group('ListFormatter tests', () {
    group('sort and group alphabetically', () {
      final list = <MockListItem>[
        MockListItem('cat'),
        MockListItem('duck'),
        MockListItem('car'),
      ];

      String displayValueSelector(item) => item.text;

      final expectedList = <dynamic>[
        ListHeading('C'),
        MockListItem('car'),
        MockListItem('cat'),
        ListHeading('D'),
        MockListItem('duck'),
      ];

      test('group items', () {
        final actualList = ListFormatter.sortAndGroupAlphabetically(
          list,
          displayValueSelector,
        );

        expect(actualList[0].text, expectedList[0].text);
        expect(actualList[1].text, expectedList[1].text);
        expect(actualList[2].text, expectedList[2].text);
        expect(actualList[3].text, expectedList[3].text);
        expect(actualList[4].text, expectedList[4].text);
        expect(actualList.length, 5);
      });
    });

    group('filter', () {
      final list = <MockListItem>[
        MockListItem('car'),
        MockListItem('cat'),
        MockListItem('cyan'),
      ];

      String displayValueSelector(item) => item.text;

      final expectedList = <MockListItem>[
        MockListItem('car'),
        MockListItem('cat'),
      ];

      test('filter returns some items', () {
        const query = 'ca';

        final actualList = ListFormatter.filter(
          list,
          query,
          displayValueSelector,
        );

        expect(actualList[0].text, expectedList[0].text);
        expect(actualList[1].text, expectedList[1].text);
        expect(actualList.length, 2);
      });

      test('filter returns no items', () {
        const query = 'cab';

        final actualList = ListFormatter.filter(
          list,
          query,
          displayValueSelector,
        );

        expect(actualList.length, 0);
      });

      test('empty query in filter returns all items', () {
        const query = '';

        final actualList = ListFormatter.filter(
          list,
          query,
          displayValueSelector,
        );

        expect(actualList.length, 3);
      });

      test('null query in filter returns all items', () {
        const query = null;

        final actualList = ListFormatter.filter(
          list,
          query,
          displayValueSelector,
        );

        expect(actualList.length, 3);
      });
    });
  });
}

class MockListItem {
  MockListItem(this.text);

  final String text;
}

class MockHeaderItem {
  MockHeaderItem(this.text);

  final String text;
}
