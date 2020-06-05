import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/library_ui_components/tab/keep_alive_container.dart';

const animationDurationOn = 50;
const animationDurationOff = 25;

class TabBarLayout extends StatefulWidget {
  const TabBarLayout({@required this.tabs})
      : assert(
          // isNotEmpty does not work since it is not constant
          // ignore: prefer_is_empty
          tabs != null && tabs.length != 0,
          'List cannot be empty',
        );

  final List<TabConfiguration> tabs;

  @override
  _TabBarLayoutState createState() => _TabBarLayoutState();
}

class _TabBarLayoutState extends State<TabBarLayout>
    with TickerProviderStateMixin {
  TabController _controller;

  AnimationController _animationControllerOn;

  AnimationController _animationControllerOff;

  Animation _colorTweenSelected;
  Animation _colorTweenDeselected;

  Animation<TextStyle> _textStyleTweenSelected;
  Animation<TextStyle> _textStyleTweenDeselected;

  int _currentIndex = 0;
  int _previousControllerIndex = 0;

  double _animationValue = 0;
  double _previousAnimationValue = 0;

  final _textStyleSelected = TextStyles.lightInputTextRegular;
  final _textStyleDeselected = TextStyles.darkBodyBody2Regular;

  final _backgroundSelected = ColorStyles.primaryDark;
  final _backgroundDeselected = ColorStyles.white;

  final _scrollController = ScrollController();

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

    _colorTweenDeselected =
        ColorTween(begin: _backgroundSelected, end: _backgroundDeselected)
            .animate(_animationControllerOff);
    _textStyleTweenDeselected =
        TextStyleTween(begin: _textStyleSelected, end: _textStyleDeselected)
            .animate(_animationControllerOff);

    _animationControllerOn = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: animationDurationOn))
      ..value = 1;

    _colorTweenSelected =
        ColorTween(begin: _backgroundDeselected, end: _backgroundSelected)
            .animate(_animationControllerOn);
    _textStyleTweenSelected =
        TextStyleTween(begin: _textStyleDeselected, end: _textStyleSelected)
            .animate(_animationControllerOn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _buildTabBar(),
          _buildTabContent(),
        ],
      );

  Widget _buildTabContent() => Expanded(
        child: TabBarView(
          controller: _controller,
          children: widget.tabs
              .map((tab) => KeepAliveContainer(tab.buildWidget()))
              .toList(),
        ),
      );

  Widget _buildTabBar() => Container(
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          height: 45,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.tabs.length,
            itemBuilder: (context, index) => _buildTab(index),
          ),
        ),
      );

  Widget _buildTab(int index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        key: widget.tabs[index].globalKey,
        child: ButtonTheme(
          key: widget.tabs[index].tabKey,
          child: AnimatedBuilder(
            animation: _getAnimation(index),
            builder: (context, child) => FlatButton(
              color: _getBackgroundColor(index),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: () => _onTabPressed(index),
              child: Text(
                widget.tabs[index].title,
                style: _getTabTextStyle(index),
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
      return _colorTweenSelected.value;
    } else if (index == _previousControllerIndex) {
      return _colorTweenDeselected.value;
    } else {
      return _backgroundDeselected;
    }
  }

  TextStyle _getTabTextStyle(int index) {
    if (index == _currentIndex) {
      return _textStyleTweenSelected.value;
    } else if (index == _previousControllerIndex) {
      return _textStyleTweenDeselected.value;
    } else {
      return _textStyleDeselected;
    }
  }
}

class TabConfiguration {
  const TabConfiguration({
    this.title,
    this.globalKey,
    this.tabKey,
    this.buildWidget,
  });

  final String title;
  final GlobalKey globalKey;
  final Key tabKey;
  final Function buildWidget;
}
