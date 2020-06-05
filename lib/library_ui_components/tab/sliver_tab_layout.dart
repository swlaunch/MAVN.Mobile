import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/buttons/custom_back_button.dart';
import 'package:lykke_mobile_mavn/library_ui_components/tab/keep_alive_container.dart';

const animationDurationOn = 50;
const animationDurationOff = 25;

// ignore: lines_longer_than_80_chars
//TODO figure out a way to merge it with the regular tab layout when there;s enough time
class SliverTabBarLayout extends StatefulWidget {
  const SliverTabBarLayout({
    @required this.tabs,
    @required this.title,
  }) : assert(
          // isNotEmpty does not work since it is not constant
          // ignore: prefer_is_empty
          tabs != null && tabs.length != 0,
          'List cannot be empty',
        );

  final List<SliverTabConfiguration> tabs;
  final Widget title;

  @override
  _SliverTabBarLayoutState createState() => _SliverTabBarLayoutState();
}

class _SliverTabBarLayoutState extends State<SliverTabBarLayout>
    with TickerProviderStateMixin {
  TabController _controller;

  AnimationController _animationControllerOn;

  AnimationController _animationControllerOff;

  Animation _colorTweenSelected;
  Animation _colorTweenDeselected;

  int _currentIndex = 0;
  int _previousControllerIndex = 0;

  double _animationValue = 0;
  double _previousAnimationValue = 0;

  final _textStyleSelected = TextStyles.lightInputTextRegular;
  final _textStyleDeselected = TextStyles.darkBodyBody2Regular;

  final _backgroundSelected = ColorStyles.primaryDark;
  final _backgroundDeselected = ColorStyles.white;

  final borderRadius = BorderRadius.circular(24);

  final _scrollController = ScrollController();
  final _nestedScrollController = ScrollController();

  bool _buttonTaped = false;

  static const double _tabBarHeight = 61;

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

    _colorTweenDeselected =
        ColorTween(begin: _backgroundSelected, end: _backgroundDeselected)
            .animate(_animationControllerOff);

    _animationControllerOn = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: animationDurationOn))
      ..value = 1;

    _colorTweenSelected =
        ColorTween(begin: _backgroundDeselected, end: _backgroundSelected)
            .animate(_animationControllerOn);

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
          child: NestedScrollView(
            controller: _nestedScrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
              SliverAppBar(
                brightness: Brightness.light,
                leading: const CustomBackButton(),
                backgroundColor: ColorStyles.white,
                elevation: 0,
                expandedHeight: 156 + _tabBarHeight,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.all(0),
                  centerTitle: false,
                  background: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        widget.title,
                        const SizedBox(height: 12),
                        // ignore: lines_longer_than_80_chars
                        //offsetting the height of the title with the size of the tab bar
                        const SizedBox(height: _tabBarHeight)
                      ],
                    ),
                  ),
                ),
                bottom: _buildTabBar(),
              ),
            ],
            body: _buildTabContent(),
          ),
        ),
      );

  Widget _buildTabContent() => TabBarView(
        controller: _controller,
        children: widget.tabs
            .map((tab) => KeepAliveContainer(tab.buildWidget()))
            .toList(),
      );

  Widget _buildTabBar() => PreferredSize(
        preferredSize: const Size.fromHeight(_tabBarHeight),
        child: Container(
          color: ColorStyles.white,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 45,
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.tabs.length,
              itemBuilder: (context, index) => _buildTab(index),
              separatorBuilder: (context, position) =>
                  const SizedBox(width: 12),
            ),
          ),
        ),
      );

  Widget _buildTab(int index) => Container(
        //this unusual way of setting padding is in order to have a nice margin when scrolling to first/last tab
        margin: EdgeInsets.only(
            left: index == 0 ? 24 : 0,
            right: index == widget.tabs.length - 1 ? 24 : 0),
        key: widget.tabs[index].globalKey,
        child: ButtonTheme(
          key: widget.tabs[index].tabKey,
          child: AnimatedBuilder(
            animation: _getAnimation(index),
            builder: (context, child) => Container(
              decoration: BoxDecoration(
                  color: _getBackgroundColor(index),
                  border: Border.all(color: ColorStyles.primaryDark, width: 2),
                  borderRadius: borderRadius),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius,
                ),
                onPressed: () => _onTabPressed(index),
                child: Text(
                  widget.tabs[index].title,
                  style: _getTabTextStyle(index),
                ),
              ),
            ),
          ),
        ),
      );

  Animation _getAnimation(int index) {
    if (index == _currentIndex) {
      return _colorTweenSelected;
    } else if (index == _previousControllerIndex) {
      return _colorTweenDeselected;
    } else {
      return _colorTweenDeselected;
    }
  }

  void _onTabPressed(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _buttonTaped = true;
      _controller.animateTo(index);
      _setCurrentIndex(index);
    });
  }

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
    var screenWidth = MediaQuery.of(context).size.width;

    RenderBox renderBox =
        widget.tabs[index].globalKey.currentContext.findRenderObject();
    var size = renderBox.size.width;
    var position = renderBox.localToGlobal(Offset.zero).dx;

    var offset = (position + size / 2) - screenWidth / 2;

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

  Color _getBackgroundColor(int index) {
    if (index == _currentIndex) {
      return _backgroundSelected;
    } else {
      return _backgroundDeselected;
    }
  }

  TextStyle _getTabTextStyle(int index) {
    if (index == _currentIndex) {
      return _textStyleSelected;
    } else {
      return _textStyleDeselected;
    }
  }
}

class SliverTabConfiguration {
  const SliverTabConfiguration({
    this.title,
    this.globalKey,
    this.tabKey,
    this.buildWidget,
    this.onScroll,
  });

  final String title;
  final GlobalKey globalKey;
  final Key tabKey;
  final Function buildWidget;
  final VoidCallback onScroll;
}
