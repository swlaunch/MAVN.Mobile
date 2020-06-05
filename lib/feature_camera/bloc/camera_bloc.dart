import 'dart:io';
import 'dart:math';

import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:lykke_mobile_mavn/feature_camera/di/camera_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:path_provider/path_provider.dart';

import 'camera_bloc_output.dart';

class CameraBloc extends Bloc<CameraState> {
  CameraBloc();

  @override
  CameraState initialState() => CameraUninitializedState();

  CancelableOperation takePictureOperation;

  @override
  void dispose() {
    takePictureOperation?.cancel();
    super.dispose();
  }

  void retakePicture() {
    setState(CameraUninitializedState());
  }

  Future<void> takePicture({
    @required BuildContext context,
    @required NativeDeviceOrientation pictureCaptureOrientation,
    @required CameraController cameraController,
    @required String pictureDirectory,
    @required GlobalKey cameraPreviewRect,
  }) async {
    takePictureOperation = CancelableOperation.fromFuture(
      _takePictureOperation(
        context: context,
        pictureCaptureOrientation: pictureCaptureOrientation,
        cameraController: cameraController,
        pictureDirectory: pictureDirectory,
        cameraPreviewRect: cameraPreviewRect,
      ),
      onCancel: () => print('CameraWidget: takePicture was cancelled'),
    );
    return takePictureOperation.value;
  }

  Future<void> _takePictureOperation({
    @required BuildContext context,
    @required NativeDeviceOrientation pictureCaptureOrientation,
    @required CameraController cameraController,
    @required String pictureDirectory,
    @required GlobalKey cameraPreviewRect,
  }) async {
    try {
      if (currentState is CameraTakingPictureState ||
          pictureCaptureOrientation == null ||
          cameraController == null ||
          !cameraController.value.isInitialized ||
          cameraController.value.isTakingPicture) {
        return;
      }

      setState(CameraTakingPictureState());

      final previewImagePath =
          await _getPreviewImagePath(pictureDirectory: pictureDirectory);

      await _deletePreviousPhoto(imagePath: previewImagePath);

      await cameraController.takePicture(previewImagePath);

      await _resizeAndCropImage(
        context: context,
        pictureCaptureOrientation: pictureCaptureOrientation,
        cameraController: cameraController,
        cameraPreviewRect: cameraPreviewRect,
        imagePath: previewImagePath,
      );

      setState(CameraPicturePreviewState(previewImagePath));
    } on Exception catch (e) {
      //TODO: Maybe add some error handling in the future
      print('CameraWidget: takePicture exception: $e');
    }
  }

  Future<void> _resizeAndCropImage({
    @required BuildContext context,
    @required GlobalKey cameraPreviewRect,
    @required CameraController cameraController,
    @required NativeDeviceOrientation pictureCaptureOrientation,
    @required String imagePath,
  }) async {
    final size = MediaQuery.of(context).size;

    final RenderBox box = cameraPreviewRect.currentContext.findRenderObject();

    final cameraAspectRatio = cameraController.value.previewSize.height <
            cameraController.value.previewSize.width
        ? cameraController.value.aspectRatio
        : 1 / cameraController.value.aspectRatio;

    var degrees = 0;
    switch (pictureCaptureOrientation) {
      case NativeDeviceOrientation.landscapeLeft:
        degrees = 90;
        break;
      case NativeDeviceOrientation.landscapeRight:
        degrees = -90;
        break;
      case NativeDeviceOrientation.portraitDown:
        degrees = 180;
        break;
      default:
        degrees = 0;
        break;
    }

    await _rotateAndResizeImage(imagePath: imagePath, rotation: degrees);

    final decodedImage =
        await decodeImageFromList(File(imagePath).readAsBytesSync());

    final imageWidth = decodedImage.width;
    final imageHeight = decodedImage.height;

    var extraX = 0.0;
    var extraY = 0.0;
    var cameraPreviewToImageFileRatio = 0.0;

    if (size.width / cameraAspectRatio < size.height) {
      // preview fits height, rest of width goes outside of the screen
      cameraPreviewToImageFileRatio =
          max(imageHeight, imageWidth) / size.height;

      extraX = (size.height * cameraAspectRatio - size.width) /
          2 *
          cameraPreviewToImageFileRatio;
    } else {
      // preview fits width, rest of the height goes outside of the screen
      cameraPreviewToImageFileRatio = min(imageHeight, imageWidth) / size.width;

      extraY = (size.width / cameraAspectRatio - size.height) /
          2 *
          cameraPreviewToImageFileRatio;
    }

    final offsetX = box.localToGlobal(const Offset(0, 0)).dx *
            cameraPreviewToImageFileRatio +
        extraX;

    final offsetY = box.localToGlobal(const Offset(0, 0)).dy *
            cameraPreviewToImageFileRatio +
        extraY;

    await (await FlutterNativeImage.cropImage(
      imagePath,
      offsetX.toInt(),
      offsetY.toInt(),
      (box.size.width * cameraPreviewToImageFileRatio).toInt(),
      (box.size.height * cameraPreviewToImageFileRatio).toInt(),
    ))
        .copy(imagePath);
  }

  static Future<void> _rotateAndResizeImage({
    @required String imagePath,
    @required int rotation,
  }) async {
    try {
      final imageFile = File(imagePath);

      final result = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        quality: 80,
        rotate: rotation,
        minWidth: 1500,
        keepExif: true,
        autoCorrectionAngle: true,
      );

      await imageFile.writeAsBytes(result);
    } catch (e) {
      print('CameraWidget: Resize exception: $e');
    }
  }

  Future<void> _deletePreviousPhoto({@required String imagePath}) async {
    try {
      imageCache.clear();
      await File(imagePath).delete();
    } catch (_) {}
  }

  Future<String> _getPictureDirectoryFilePath({
    @required String pictureDirectory,
  }) async {
    final applicationDocumentsDirectoryPath =
        (await getApplicationDocumentsDirectory()).path;

    final pictureDirectoryFilePath =
        '$applicationDocumentsDirectoryPath/$pictureDirectory';

    await Directory(pictureDirectoryFilePath).create(recursive: true);

    return pictureDirectoryFilePath;
  }

  Future<String> _getPreviewImagePath({
    @required String pictureDirectory,
  }) async {
    final pictureDirectoryFilePath =
        await _getPictureDirectoryFilePath(pictureDirectory: pictureDirectory);

    return '$pictureDirectoryFilePath/preview.jpg';
  }

  Future<String> _getFinalImagePath({
    @required String pictureDirectory,
  }) async {
    final pictureDirectoryFilePath =
        await _getPictureDirectoryFilePath(pictureDirectory: pictureDirectory);

    return '$pictureDirectoryFilePath/final${DateTime.now().toUtc().millisecondsSinceEpoch}.jpg';
  }

  Future<String> submitPicture({@required String pictureDirectory}) async {
    final previewPhotoImagePath =
        await _getPreviewImagePath(pictureDirectory: pictureDirectory);
    final finalPhotoImagePath =
        await _getFinalImagePath(pictureDirectory: pictureDirectory);

    await File(previewPhotoImagePath).copy(finalPhotoImagePath);

    return finalPhotoImagePath;
  }
}

CameraBloc useCameraBloc() =>
    ModuleProvider.of<CameraModule>(useContext()).cameraBloc;
