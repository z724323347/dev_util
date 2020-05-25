import 'package:dev_util/global/global_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'route_transition.dart';

/// TransitionType
enum TransitionType {
  ///
  fade,

  ///大致效果:  屏幕中间放大缩小 展开
  scale,

  ///大致效果: 屏幕中间旋转放缩 展开
  rotate,

  ///
  transform,

  ///大致效果： 屏幕中间水平or垂直 方向展开
  size,

  ///大致效果: 屏幕中间旋转放缩 展开
  scale_rotate,

  ///大致效果:  屏幕右边到左边 right → left
  slide_left,

  ///大致效果: 屏幕底部到顶部 bottom → top
  slide_top,

  ///大致效果: 屏幕左边到右边 left → right
  slide_right,

  ///大致效果: 屏幕顶部到底部 top → bottom
  slide_bottom,

  ///大致效果: 结合 SlideDirection使用
  enter_exit
}

enum SlideDirection {
  bottom2top,
  right2left,
  top2bottom,
  left2right,
}

///  Animation RouterUtils
class RouterUtils {
  /// 带动画跳转
  static void pushWithAnimation(
    Widget toPage, {
    @required TransitionType type,
    Widget fromPage,
    Duration duration: const Duration(milliseconds: 500),
    Curve curve: Curves.fastOutSlowIn,
    SlideDirection direction: SlideDirection.right2left,
    Axis axis: Axis.vertical,
    Function(dynamic) callBack,
  }) {
    GlobalNavigator.push(RouteTransition(
      type: type,
      toPage: toPage,
      fromPage: fromPage,
      duration: duration,
      curve: curve,
      direction: direction,
      axis: axis,
    )).then((data) => callBack(data));
  }

  /// popAndPushNamed
  static void popAndPushNamed(String routeName) {
    GlobalNavigator.popAndPushNamed(routeName);
  }

  /// pushReplacement
  static void pushReplacement(Widget routePage) {
    GlobalNavigator.pushReplacement(
        MaterialPageRoute(builder: (context) => routePage));
  }

  ///pushReplacementName
  static void pushReplacementName(String routeName) {
    GlobalNavigator.pushReplacementNamed(routeName);
  }

  /// pushNewPageBack  路由带参数返回
  void pushNewPageBack(Widget routePage, {Function callBack}) {
    GlobalNavigator.push(CupertinoPageRoute(builder: (context) => routePage))
        .then((data) {
      if (data != null) {
        callBack(data);
      }
    });
  }
}
