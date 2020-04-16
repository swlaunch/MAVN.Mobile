import 'package:lykke_mobile_mavn/library_bloc/core.dart';

abstract class CameraState extends BlocState {}

class CameraUninitializedState extends CameraState {}

class CameraTakingPictureState extends CameraState {}

class CameraPicturePreviewState extends CameraState {
  CameraPicturePreviewState(this.previewImagePath);

  final String previewImagePath;
}
