import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;

class BaseRouter {
  BaseRouter(this._navigatorKey, this._bottomNavBarKey);

  final GlobalKey<NavigatorState> _navigatorKey;
  final GlobalKey _bottomNavBarKey;

  Future<T> pushPage<T>(
    Widget page, {
    String pageName,
    bool fullScreenDialog = false,
  }) =>
      _navigatorKey.currentState.push(
        MaterialPageRoute<T>(
          builder: (context) => page,
          settings: pageName != null ? RouteSettings(name: pageName) : null,
          fullscreenDialog: fullScreenDialog,
        ),
      );

  Future<T> pushPageForMultiPush<T>(
    Widget page, {
    String pageName,
    bool fullScreenDialog = false,
  }) =>
      _navigatorKey.currentState.push(
        InvisibleWhileRouteOnTopTransitionsMaterialPageRoute<T>(
          builder: (context) => page,
          settings: pageName != null ? RouteSettings(name: pageName) : null,
          fullscreenDialog: fullScreenDialog,
        ),
      );

  Future<T> pushRootPage<T>(
    Widget page, {
    String pageName,
    bool fullScreenDialog = false,
  }) {
    popDialog();
    return _navigatorKey.currentState.pushAndRemoveUntil(
        MaterialPageRoute<T>(
            builder: (context) => page,
            settings: pageName != null ? RouteSettings(name: pageName) : null,
            fullscreenDialog: fullScreenDialog),
        (r) => false);
  }

  Future<T> pushRootPageForMultiPush<T>(
    Widget page, {
    String pageName,
    bool fullScreenDialog = false,
  }) {
    popDialog();
    return _navigatorKey.currentState.pushAndRemoveUntil(
        InvisibleWhileRouteOnTopTransitionsMaterialPageRoute<T>(
            builder: (context) => page,
            settings: pageName != null ? RouteSettings(name: pageName) : null,
            fullscreenDialog: fullScreenDialog),
        (r) => false);
  }

  Future<T> replacePage<T>(
    Widget page, {
    String pageName,
    bool fullScreenDialog = false,
  }) =>
      _navigatorKey.currentState.pushReplacement(
        MaterialPageRoute<T>(
          builder: (context) => page,
          settings: pageName != null ? RouteSettings(name: pageName) : null,
          fullscreenDialog: fullScreenDialog,
        ),
      );

  void popToRoot() {
    popDialog();
    _navigatorKey.currentState.popUntil((r) => r.isFirst);
  }

  void pop<T>([T result]) => _navigatorKey.currentState.pop<T>(result);

  Future<bool> maybePop<T>([T result]) =>
      _navigatorKey.currentState.maybePop<T>(result);

  Future<T> showDialog<T>({Widget child, bool isDismissible = true}) =>
      material.showDialog(
        context: _navigatorKey.currentContext,
        barrierDismissible: isDismissible,
        builder: (_) => _DialogFrame(child: child),
      );

  void popDialog<T>([T result]) {
    if (!ModalRoute.of(_navigatorKey.currentContext).isCurrent) {
      Navigator.of(_navigatorKey.currentContext).pop<T>(result);
    }
  }

  void switchToTabAtIndex(int index) {
    if (_bottomNavBarKey == null || _bottomNavBarKey.currentWidget == null) {
      return;
    }
    try {
      final BottomNavigationBar bottomNavBar = _bottomNavBarKey.currentWidget;
      bottomNavBar.onTap(index);
    } catch (e) {
      //silently fail
      print('Could not switch to tab at index $index. Error: $e');
    }
  }
}

// TODO: Customise based on design, and move somewhere else at some point
class _DialogFrame extends StatelessWidget {
  const _DialogFrame({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          child: child,
        ),
      );
}

/// A special MaterialPageRoute that is invisible while another PageRoute is
/// pushed on top of it for the first time. Useful when we want to push multiple
/// routes at the same time(e.g. WelcomePage + LoginPage after logging out)
class InvisibleWhileRouteOnTopTransitionsMaterialPageRoute<T>
    extends MaterialPageRoute<T> {
  InvisibleWhileRouteOnTopTransitionsMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );

  bool shouldBeInvisible = true;

  @override
  void didPopNext(Route nextRoute) {
    /// We revert this to a normal MaterialPageRoute when the Route on top
    /// has been popped
    shouldBeInvisible = false;
    super.didPopNext(nextRoute);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      super.buildTransitions(
        context,
        animation,
        secondaryAnimation,
        Opacity(
          /// The secondaryAnimation is the transition animation of the Route
          /// that is on top of this one. While the secondaryAnimation is
          /// running forward(Route on top is transitioning IN) and the
          /// secondaryAnimation is not done, then this Route is invisible
          opacity: shouldBeInvisible &&
                  secondaryAnimation.status == AnimationStatus.forward &&
                  secondaryAnimation.value < 1.0
              ? 0
              : 1,
          child: child,
        ),
      );
}
