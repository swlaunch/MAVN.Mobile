import 'dart:convert';
import 'dart:io' show File, Directory;
import 'dart:typed_data';

import 'package:dio/dio.dart' show Response;
import 'package:flutter/services.dart';

Future<ByteData> getFontByteData(String fontPath) async =>
    ByteData.view(Uint8List.fromList(getBytesFromFile(fontPath)).buffer);

List<int> getBytesFromFile(String fileName) {
  var updatedFilename = fileName;
  // Fix for: The current working directory changes when running 'flutter test'
  // from terminal ('projectFolder/test/') compared to running the tests
  // through IntelliJ UI ('projectFolder/'), and File('/x') is relative to the
  // current working directory
  // https://github.com/flutter/flutter/issues/20907
  if (Directory.current.path.endsWith('/test')) {
    updatedFilename = '../$fileName';
  }

  return File(updatedFilename).readAsBytesSync();
}

String getStringFromFile(String fileName) {
  var updatedFilename = fileName;
  // Fix for: The current working directory changes when running 'flutter test'
  // from terminal ('projectFolder/test/') compared to running the tests
  // through IntelliJ UI ('projectFolder/'), and File('/x') is relative to the
  // current working directory
  // https://github.com/flutter/flutter/issues/20907
  if (Directory.current.path.endsWith('/test')) {
    updatedFilename = '../$fileName';
  }

  return File(updatedFilename).readAsStringSync();
}

Response dioResponseFromFile(String fileName, {int statusCode = 200}) =>
    Response(
        data: json.decode(getStringFromFile(fileName)), statusCode: statusCode);
