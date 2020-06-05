import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/image_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/scroll_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/custom_back_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/material_hero.dart';

class ScaffoldWithSliverHero extends HookWidget {
  const ScaffoldWithSliverHero({
    @required this.title,
    @required this.body,
    @required this.heroTag,
    @required this.heroWidget,
    @required this.bottom,
    @required this.error,
  });

  final String title;
  final Widget body;
  final String heroTag;
  final Widget heroWidget;
  final Widget bottom;
  final Widget error;

  static const double _sliverImageSize = 200;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  title: Text(
                    title,
                    style: TextStyles.lightHeaderTitle,
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: ColorStyles.white,
                  elevation: 0,
                  expandedHeight: _sliverImageSize,
                  floating: false,
                  pinned: true,
                  flexibleSpace: Container(
                    color: ColorStyles.salmon,
                    child: FlexibleSpaceBar(
                      background: Image(
                        image: AssetImage(ImageAssets.backgroundFoodItems),
                        fit: BoxFit.none,
                      ),
                    ),
                  ),
                  leading: const CustomBackButton(color: ColorStyles.white),
                ),
                SliverToBoxAdapter(child: body),
              ],
            ),
            _buildHero(context, scrollController),
            bottom,
            if (error != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: error,
              )
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, ScrollController scrollController) {
    //starting widget position
    final defaultTopMargin =
        _sliverImageSize + MediaQuery.of(context).padding.top - 150.0;
    //pixels from top where opacity change should start
    final opacityChangeStart = defaultTopMargin / 2;
    //pixels from top where opacity change should end
    final opacityChangeEnd = opacityChangeStart / 2;

    var top = defaultTopMargin;
    var opacity = 1.0;
    if (scrollController.hasClients) {
      final offset = scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - opacityChangeStart) {
        //offset small => don't decrease opacity
        opacity = 1;
      } else if (offset < defaultTopMargin - opacityChangeEnd) {
        //opacityChangeStart < offset> opacityChangeEnd => decrease opacity
        opacity =
            (defaultTopMargin - opacityChangeEnd - offset) / opacityChangeEnd;
      } else {
        //offset passed opacityChangeEnd => hide widget
        opacity = 0;
      }
    }
    final availableWidth = MediaQuery.of(context).size.width;

    final width = availableWidth - (2 * 24);
    return Positioned(
      top: top + 24,
      left: 24,
      child: Opacity(
        opacity: opacity,
        child: MaterialHero(
          tag: heroTag,
          child: Container(
            width: width,
            child: heroWidget,
          ),
        ),
      ),
    );
  }
}
