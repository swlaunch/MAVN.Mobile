import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

CameraController useCameraController() => Hook.use(_CameraControllerHook());

class _CameraControllerHook extends Hook<CameraController> {
  @override
  _CameraControllerHookState createState() => _CameraControllerHookState();
}

class _CameraControllerHookState
    extends HookState<CameraController, _CameraControllerHook>
    with WidgetsBindingObserver {
  CameraController _cameraController;

  bool isInitializing = false;

  @override
  void initHook() {
    Future.delayed(const Duration(milliseconds: 350), () {
      _initCamera();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (isInitializing) {
      return;
    }

    if (state == AppLifecycleState.resumed) {
      _initCamera();
    } else {
      _cameraController?.dispose();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  CameraController build(BuildContext context) => _cameraController;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
  }

  Future<void> _initCamera() async {
    if (isInitializing) return;

    isInitializing = true;

    try {
      final camera = (await availableCameras()).firstWhere(
          (cameraDescription) =>
              cameraDescription.lensDirection == CameraLensDirection.back);

      if (camera == null) {
        return;
      }

      await _cameraController?.dispose();

      _cameraController =
          CameraController(camera, ResolutionPreset.high, enableAudio: false);

      await _cameraController.initialize();

      isInitializing = false;

      setState(() {});
    } catch (e) {
      isInitializing = false;

      print('CameraWidget: Error when initializing camera. Error: $e');
    }
  }
}
