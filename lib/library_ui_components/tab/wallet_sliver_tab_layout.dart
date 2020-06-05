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

  final _nestedScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: widget.tabs.length);
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
                  style: TextStyles.lightHeaderTitle,
                ),
                brightness: Brightness.dark,
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
                  tabColor: ColorStyles.salmon,
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
}
