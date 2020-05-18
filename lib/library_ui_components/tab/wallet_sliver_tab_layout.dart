import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/image_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/tab/colored_tab_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/tab/keep_alive_container.dart';
import 'package:lykke_mobile_mavn/library_ui_components/tab/sliver_tab_layout.dart';

const animationDurationOn = 50;
const animationDurationOff = 25;

class HomeSliverTabLayout extends StatefulWidget {
  const HomeSliverTabLayout({
    @required this.tabs,
    @required this.title,
  }) : assert(
          // isNotEmpty does not work since it is not constant
          // ignore: prefer_is_empty
          tabs != null && tabs.length != 0,
          'List cannot be empty',
        );

  final List<SliverTabConfiguration> tabs;
  final String title;

  @override
  _HomeSliverTabLayoutState createState() => _HomeSliverTabLayoutState();
}

class _HomeSliverTabLayoutState extends State<HomeSliverTabLayout>
    with TickerProviderStateMixin {
  TabController _controller;

  AnimationController _animationControllerOn;

  AnimationController _animationControllerOff;

  int _currentIndex = 0;
  int _previousControllerIndex = 0;

  double _animationValue = 0;
  double _previousAnimationValue = 0;

  final _scrollController = ScrollController();
  final _nestedScrollController = ScrollController();

  bool _buttonTaped = false;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: widget.tabs.length);
    _controller.animation.addListener(_handleTabAnimation);
    _controller.addListener(_handleTabChange);

    _animationControllerOff = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: animationDurationOff))
      ..value = 1;

    _animationControllerOn = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: animationDurationOn))
      ..value = 1;

    _nestedScrollController.addListener(() {
      final isEnd = _nestedScrollController.offset ==
          _nestedScrollController.position.maxScrollExtent;

      if (isEnd) {
        widget.tabs[_currentIndex].onScroll();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _nestedScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          top: false,
          child: NestedScrollView(
            controller: _nestedScrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
              SliverAppBar(
                title: Text(
                  widget.title,
                  style: TextStyles.lightHeadersH1,
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                backgroundColor: ColorStyles.white,
                elevation: 0,
                expandedHeight: 150,
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
                bottom: ColoredTabBar(
                  color: ColorStyles.salmon,
                  tabBar: TabBar(
                    tabs: widget.tabs
                        .map(
                          (e) => Tab(
                            child: AutoSizeText(
                              e.title,
                              maxLines: 1,
                            ),
                          ),
                        )
                        .toList(growable: false),
                    controller: _controller,
                    indicatorColor: ColorStyles.white,
                    labelStyle: TextStyles.lightButtonExtraBold,
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _controller,
              children: widget.tabs
                  .map((tab) => KeepAliveContainer(tab.buildWidget()))
                  .toList(),
            ),
          ),
        ),
      );

  void _handleTabAnimation() {
    _animationValue = _controller.animation.value;

    if (!_buttonTaped &&
        (_animationValue - _previousAnimationValue).abs() < 1) {
      _setCurrentIndex(_animationValue.round());
    }
    _previousAnimationValue = _animationValue;
  }

  void _handleTabChange() {
    if (_buttonTaped) _setCurrentIndex(_controller.index);

    if ((_controller.index == _previousControllerIndex) ||
        (_controller.index == _animationValue.round())) _buttonTaped = false;

    _previousControllerIndex = _controller.index;
  }

  void _setCurrentIndex(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });

      _triggerAnimation();
      _scrollTo(index);
    }
  }

  void _triggerAnimation() {
    _animationControllerOn.reset();
    _animationControllerOff.reset();

    _animationControllerOn.forward();
    _animationControllerOff.forward();
  }

  void _scrollTo(int index) {
    double screenWidth = MediaQuery.of(context).size.width;

    RenderBox renderBox =
        widget.tabs[index].globalKey.currentContext.findRenderObject();
    double size = renderBox.size.width;
    double position = renderBox.localToGlobal(Offset.zero).dx;

    double offset = (position + size / 2) - screenWidth / 2;

    if (offset < 0) {
      renderBox = widget.tabs.first.globalKey.currentContext.findRenderObject();
      position = renderBox.localToGlobal(Offset.zero).dx;

      if (position > offset) offset = position;
    } else {
      renderBox = widget.tabs.last.globalKey.currentContext.findRenderObject();
      position = renderBox.localToGlobal(Offset.zero).dx;
      size = renderBox.size.width;

      if (position + size < screenWidth) screenWidth = position + size;

      if (position + size - offset < screenWidth) {
        offset = position + size - screenWidth;
      }
    }
    _scrollController.animateTo(offset + _scrollController.offset,
        duration: const Duration(milliseconds: animationDurationOn),
        curve: Curves.easeInOut);
  }
}
