import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_camera/bloc/camera_bloc.dart';
import 'package:lykke_mobile_mavn/feature_camera/bloc/camera_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/camera_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/custom_back_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/primary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/secondary_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/divider_decoration.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/standard_sized_svg.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:transparent_image/transparent_image.dart';

//TODO: More refactoring, ideally move build methods to classes
class CameraView extends HookWidget {
  CameraView({
    @required this.cameraViewTitle,
    @required this.pictureDirectory,
    this.onPictureSubmitTapped,
    Key key,
  }) : super(key: key);

  final String cameraViewTitle;
  final String pictureDirectory;
  final void Function(String finalPicturePath) onPictureSubmitTapped;

  final picturePreviewRectKey = GlobalKey();

  final nativeOrientationUpdatedStream = NativeDeviceOrientationCommunicator()
      .onOrientationChanged(useSensor: true)
      .where((orientation) => orientation != NativeDeviceOrientation.unknown);

  @override
  Widget build(BuildContext context) {
    final cameraController = useCameraController();
    final nativeOrientation = useStream(
      nativeOrientationUpdatedStream,
      initialData: NativeDeviceOrientation.portraitUp,
    ).data;

    final cameraBloc = useCameraBloc();
    final cameraBlocState = useBlocState(cameraBloc);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(fit: StackFit.expand, children: <Widget>[
        _buildCameraPreview(
            context: context,
            cameraController: cameraController,
            cameraState: cameraBlocState,
            screenSize: MediaQuery.of(context).size),
        _buildCameraOverlay(
          context: context,
          cameraController: cameraController,
          cameraBloc: cameraBloc,
          cameraBlocState: cameraBlocState,
          nativeOrientation: nativeOrientation,
        ),
      ]),
    );
  }

  Widget _buildCameraPreview({
    @required BuildContext context,
    @required CameraController cameraController,
    @required CameraState cameraState,
    @required Size screenSize,
  }) {
    if (cameraController == null ||
        !cameraController.value.isInitialized ||
        cameraState is! CameraUninitializedState) {
      return Container(
        color: Colors.black,
      );
    } else {
      return Transform.scale(
        child: Center(
          child: AspectRatio(
              aspectRatio: cameraController.value.aspectRatio,
              child: CameraPreview(cameraController)),
        ),
        scale: cameraController.value.aspectRatio / screenSize.aspectRatio,
      );
    }
  }

  //TODO Break this even further into separate widgets
  Widget _buildCameraOverlay({
    @required BuildContext context,
    @required CameraController cameraController,
    @required CameraBloc cameraBloc,
    @required CameraState cameraBlocState,
    @required NativeDeviceOrientation nativeOrientation,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: _backgroundColor(cameraState: cameraBlocState),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).padding.top),
                const SizedBox(height: 24),
                const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: CustomBackButton(color: Colors.white)),
                _buildPageTitle(cameraState: cameraBlocState),
                const Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: DividerDecoration()),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final picturePreviewRectWidth = constraints.maxWidth * 0.85;
                final picturePreviewRectHeight = picturePreviewRectWidth * 0.7;
                final double verticalMargin = max(
                  0,
                  (constraints.maxHeight - picturePreviewRectHeight) / 2,
                );

                return Column(
                  children: <Widget>[
                    Container(
                      height: verticalMargin.roundToDouble(),
                      color: _backgroundColor(cameraState: cameraBlocState),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Container(
                                    color: _backgroundColor(
                                        cameraState: cameraBlocState))),
                            Container(
                              key: picturePreviewRectKey,
                              width: picturePreviewRectWidth,
                              child: _buildPicturePreviewRect(
                                cameraState: cameraBlocState,
                              ),
                            ),
                            Expanded(
                                child: Container(
                                    color: _backgroundColor(
                                        cameraState: cameraBlocState))),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: verticalMargin.roundToDouble(),
                      color: _backgroundColor(
                        cameraState: cameraBlocState,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            color: _backgroundColor(cameraState: cameraBlocState),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 24),
                AutoSizeText(
                  useLocalizedStrings().cameraViewGuide,
                  style: TextStyles.lightBodyBody2Regular,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (cameraBlocState is CameraUninitializedState ||
                        cameraBlocState is CameraTakingPictureState)
                      Container(
                        height: 56,
                        child: FloatingActionButton(
                          onPressed: () {
                            cameraBloc.takePicture(
                                context: context,
                                pictureCaptureOrientation: nativeOrientation,
                                cameraController: cameraController,
                                pictureDirectory: pictureDirectory,
                                cameraPreviewRect: picturePreviewRectKey);
                          },
                          backgroundColor: Colors.white,
                          child: cameraBlocState is CameraTakingPictureState
                              ? Container(
                                  width: 20, height: 20, child: const Spinner())
                              : const StandardSizedSvg(SvgAssets.camera),
                        ),
                      ),
                    if (cameraBlocState is CameraPicturePreviewState)
                      Expanded(
                        child: Container(
                          height: 48,
                          margin: const EdgeInsets.only(
                              right: 8, left: 16, bottom: 4, top: 4),
                          child: SecondaryButton(
                            text:
                                useLocalizedStrings().cameraPreviewRetakeButton,
                            onTap: cameraBloc.retakePicture,
                          ),
                        ),
                      ),
                    if (cameraBlocState is CameraPicturePreviewState)
                      Expanded(
                        child: Container(
                          height: 48,
                          margin: const EdgeInsets.only(
                              left: 8, right: 16, bottom: 4, top: 4),
                          child: PrimaryButton(
                            buttonKey: const Key('imageSubmitButton'),
                            isLight: true,
                            text: useLocalizedStrings().submitButton,
                            onTap: () {
                              if (onPictureSubmitTapped != null) {
                                cameraBloc
                                    .submitPicture(
                                        pictureDirectory: pictureDirectory)
                                    .then(
                                  (finalImagePath) {
                                    onPictureSubmitTapped(finalImagePath);
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      );

  Widget _buildPicturePreviewRect({@required CameraState cameraState}) => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (cameraState is CameraPicturePreviewState)
            Container(
                child: FadeInImage(
                  fadeInDuration: const Duration(milliseconds: 250),
                  image: FileImage(File(cameraState.previewImagePath)),
                  placeholder: MemoryImage(kTransparentImage),
                ),
                decoration: ShapeDecoration(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
          Container(
            decoration: ShapeDecoration(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: _backgroundColor(cameraState: cameraState),
                      width: 4),
                )),
          ),
          Container(
            decoration: ShapeDecoration(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white, width: 4),
                    borderRadius: BorderRadius.circular(10))),
          ),
        ],
      );

  Color _backgroundColor({@required CameraState cameraState}) => Colors.black
      .withOpacity(cameraState is CameraUninitializedState ? 0.7 : 1.0);

  Widget _buildPageTitle({@required CameraState cameraState}) => Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 12),
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 200),
        firstCurve: Curves.easeIn,
        secondCurve: Curves.easeIn,
        sizeCurve: Curves.easeIn,
        crossFadeState: cameraState is CameraPicturePreviewState
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: AutoSizeText(
          cameraViewTitle,
          style: TextStyles.h1PageHeaderLight,
          maxLines: 2,
        ),
        secondChild: AutoSizeText(
          useLocalizedStrings().cameraPreviewTitle,
          style: TextStyles.h1PageHeaderLight,
          maxLines: 2,
        ),
      ));
}
