import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';

const widthFactor = .4;
const animationDuration = 1000;

class SkeletonLoading extends StatefulWidget {
  const SkeletonLoading({
    @required this.child,
    @required this.isLoading,
    this.shimmerColor = Colors.white54,
    this.gradientColor = ColorStyles.skeletonLoadingDefaultGradientStart,
    this.backgroundColor = ColorStyles.paleLilac,
    this.curve = Curves.fastOutSlowIn,
    Key key,
  }) : super(key: key);

  final Widget child;
  final Color shimmerColor;
  final Color gradientColor;
  final Color backgroundColor;
  final Curve curve;
  final bool isLoading;

  @override
  _SkeletonLoadingState createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<SkeletonLoading>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: animationDuration),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.isLoading
      ? Stack(
          children: <Widget>[
            widget.child,
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: widget.backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: ClipRect(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: _getAnimationBuilder,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.gradientColor,
                            widget.shimmerColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      : widget.child;

  Widget _getAnimationBuilder(context, child) => FractionallySizedBox(
        widthFactor: widthFactor,
        alignment: AlignmentGeometryTween(
          begin: const Alignment(-1.0 - widthFactor * 3, 0),
          end: const Alignment(1.0 + widthFactor * 3, 0),
        ).chain(CurveTween(curve: widget.curve)).evaluate(_controller),
        child: child,
      );
}
