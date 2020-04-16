import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';

class ImageCardButton extends StatelessWidget {
  const ImageCardButton({
    @required this.image,
    @required this.onTap,
    this.keyValue,
    this.callToActionText,
    this.body,
    this.bodyHeight,
    this.width = double.infinity,
  });

  final String image;
  final GestureTapCallback onTap;
  final String callToActionText;
  final Widget body;
  final double bodyHeight;
  final double width;
  final String keyValue;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.centerLeft,
          children: <Widget>[
            PositionedDirectional(
              start: 0,
              bottom: 0,
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage(image), fit: BoxFit.cover)),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Builder(
                builder: (context) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 22),
                  width: MediaQuery.of(context).size.width / 2,
                  child: Card(
                    elevation: 4,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: ColorStyles.accentSand,
                        key: keyValue != null ? Key(keyValue) : null,
                        onTap: onTap,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          height: bodyHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(child: body),
                              if (callToActionText != null)
                                _CallToAction(callToActionText)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _CallToAction extends StatelessWidget {
  const _CallToAction(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  text,
                  style: TextStyles.imageButtonCardCallToAction,
                ),
              ),
              SvgPicture.asset(SvgAssets.arrow),
            ],
          )
        ],
      );
}
