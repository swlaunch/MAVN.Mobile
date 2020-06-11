import 'package:tuple/tuple.dart';

extension TupleFilters on List<Tuple2<dynamic, dynamic>> {
  Tuple2 getByKey(String key) =>
      firstWhere((element) => element.item1 == key, orElse: () => null);

  dynamic getValueByKey(String key) => getByKey(key)?.item2;
}
