library flutter_global_navigator;

import 'package:flutter/material.dart';

/// Mop导航类
/// 实现无Context跳转功能
class GlobalNavigator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// 输出一个弹窗
  ///
  /// @param barrierDismissible 是否点击其他区域消失
  /// @param barrierColor 背景色
  /// @param transitionDuration 弹出的过渡时长
  ///
  static Future<T> dialog<T>(
      {@required WidgetBuilder builder,
      bool barrierDismissible = true,
      Color barrierColor = Colors.black54,
      Duration transitionDuration = const Duration(milliseconds: 150)}) {
    assert(builder != null);
    final BuildContext _diglogCtx = navigatorKey.currentState.overlay.context;
    final ThemeData theme = Theme.of(_diglogCtx);
    return showGeneralDialog(
      context: _diglogCtx,
      barrierDismissible: barrierDismissible,
      barrierLabel:
          MaterialLocalizations.of(_diglogCtx).modalBarrierDismissLabel,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      transitionBuilder: _buildMaterialDialogTransitions,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = Builder(builder: builder);
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return theme != null
                ? Theme(data: theme, child: pageChild)
                : pageChild;
          }),
        );
      },
    );
  }

  /// Push a named route onto the navigator that most tightly encloses the given
  /// context.
  static Future<T> pushNamed<T>(String name, {Map<String, dynamic> arguments}) {
    return navigatorKey.currentState.pushNamed<T>(name, arguments: arguments);
  }

  /// Replace the current route of the navigator that most tightly encloses the
  /// given context by pushing the route named [routeName] and then disposing
  /// the previous route once the new route has finished animating in.
  static Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
    String routeName, {
    TO result,
    Object arguments,
  }) {
    return navigatorKey.currentState
        .pushReplacementNamed(routeName, result: result, arguments: arguments);
  }

  /// Pop the current route off the navigator that most tightly encloses the
  /// given context and push a named route in its place.
  static Future<T> popAndPushNamed<T extends Object, TO extends Object>(
    String routeName, {
    TO result,
    Object arguments,
  }) {
    return navigatorKey.currentState.popAndPushNamed<T, TO>(routeName,
        arguments: arguments, result: result);
  }

  /// Push the route with the given name onto the navigator that most tightly
  /// encloses the given context, and then remove all the previous routes until
  /// the `predicate` returns true.
  static Future<T> pushNamedAndRemoveUntil<T extends Object>(
    String newRouteName,
    RoutePredicate predicate, {
    Object arguments,
  }) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil<T>(
        newRouteName, predicate,
        arguments: arguments);
  }

  /// Push the given route onto the navigator that most tightly encloses the
  /// given context.
  static Future<T> push<T>(Route<T> route) {
    return navigatorKey.currentState.push(route);
  }

  /// Replace the current route of the navigator that most tightly encloses the
  /// given context by pushing the given route and then disposing the previous
  /// route once the new route has finished animating in.
  static Future<T> pushReplacement<T extends Object, TO extends Object>(
      Route<T> newRoute,
      {TO result}) {
    return navigatorKey.currentState
        .pushReplacement<T, TO>(newRoute, result: result);
  }

  /// Push the given route onto the navigator that most tightly encloses the
  /// given context, and then remove all the previous routes until the
  /// `predicate` returns true.
  static Future<T> pushAndRemoveUntil<T extends Object>(
      Route<T> newRoute, RoutePredicate predicate) {
    return navigatorKey.currentState.pushAndRemoveUntil<T>(newRoute, predicate);
  }

  /// Replaces a route on the navigator that most tightly encloses the given
  /// context with a new route.
  static void replace<T extends Object>(
      {@required Route<dynamic> oldRoute, @required Route<T> newRoute}) {
    return navigatorKey.currentState
        .replace<T>(oldRoute: oldRoute, newRoute: newRoute);
  }

  /// Replaces a route on the navigator that most tightly encloses the given
  /// context with a new route. The route to be replaced is the one below the
  /// given `anchorRoute`.
  static void replaceRouteBelow<T extends Object>(
      {@required Route<dynamic> anchorRoute, Route<T> newRoute}) {
    return navigatorKey.currentState
        .replaceRouteBelow<T>(anchorRoute: anchorRoute, newRoute: newRoute);
  }

  /// Whether the navigator that most tightly encloses the given context can be
  /// popped.
  static bool canPop() {
    return navigatorKey.currentWidget != null &&
        navigatorKey.currentState.canPop();
  }

  /// Returns the value of the current route's [Route.willPop] method for the
  /// navigator that most tightly encloses the given context.
  static Future<bool> maybePop<T extends Object>([T result]) {
    return navigatorKey.currentState.maybePop<T>(result);
  }

  /// Pop the top-most route off the navigator that most tightly encloses the
  /// given context.
  static void pop<T extends Object>([T result]) {
    navigatorKey.currentState.pop<T>(result);
  }

  /// Calls [pop] repeatedly on the navigator that most tightly encloses the
  /// given context until the predicate returns true.
  static void popUntil(RoutePredicate predicate) {
    navigatorKey.currentState.popUntil(predicate);
  }

  /// Immediately remove `route` from the navigator that most tightly encloses
  /// the given context, and [Route.dispose] it.
  static void removeRoute(Route<dynamic> route) {
    return navigatorKey.currentState.removeRoute(route);
  }

  /// Immediately remove a route from the navigator that most tightly encloses
  /// the given context, and [Route.dispose] it. The route to be replaced is the
  /// one below the given `anchorRoute`.
  static void removeRouteBelow(Route<dynamic> anchorRoute) {
    return navigatorKey.currentState.removeRouteBelow(anchorRoute);
  }
}

Widget _buildMaterialDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}
