import 'package:tuple/tuple.dart';

abstract class QrContent {
  QrContent(this.data);

  static const separator = '&';
  static const valueStart = '=';

  final String data;

  ///Convert [data] into a [List<Tuple2>] with the relevant
  ///key value pairs
  List<Tuple2> decode();
}
