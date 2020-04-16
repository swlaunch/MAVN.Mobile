import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';

void useFileCleanUpOnDispose({
  List<String> filePaths,
  List keys,
}) =>
    Hook.use(_FileCleanUpOnDisposeHook(
      filePaths: filePaths,
      keys: keys,
    ));

class _FileCleanUpOnDisposeHook extends Hook<void> {
  const _FileCleanUpOnDisposeHook({
    this.filePaths,
    List keys,
  }) : super(keys: keys);

  final List<String> filePaths;

  @override
  _TextEditingControllerHookState createState() =>
      _TextEditingControllerHookState();
}

class _TextEditingControllerHookState
    extends HookState<void, _FileCleanUpOnDisposeHook> {
  @override
  void build(BuildContext context) {}

  @override
  void dispose() {
    hook.filePaths.forEach((filePath) {
      deleteFile(filePath);
    });
  }

  Future<void> deleteFile(String filePath) async {
    try {
      final applicationDocumentsDirectoryPath =
          (await getApplicationDocumentsDirectory()).path;

      await File('$applicationDocumentsDirectoryPath/$filePath')
          .delete(recursive: true);

      print('DirectoryCleanUpHook: Deleted file at path $filePath');
    } catch (e) {
      print('DirectoryCleanUpHook: Exception when deleting file '
          'at path $filePath. Exception: $e');
    }
  }
}
