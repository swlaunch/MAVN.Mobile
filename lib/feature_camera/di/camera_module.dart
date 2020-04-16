import 'package:lykke_mobile_mavn/feature_camera/bloc/camera_bloc.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class CameraModule extends Module {
  CameraBloc get cameraBloc => get();

  @override
  void provideInstances() {
    provideSingleton(() => CameraBloc());
  }
}
