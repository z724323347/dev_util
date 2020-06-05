import 'package:flutter/material.dart';

import 'screen_fit.dart';

/// 响应式 widget
class ReactiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget mediumScreen;
  final Widget smallScreen;

  const ReactiveWidget(
      {Key key,
      @required this.largeScreen,
      this.mediumScreen,
      this.smallScreen})
      : super(key: key);

  /// 小屏幕
  static bool isSmallScreen() {
    return ScreenFit.width < 768;
  }

  /// 大屏幕
  static bool isLargeScreen() {
    return ScreenFit.width > 1200;
  }

  /// Medium
  static bool isMediumScreen() {
    return ScreenFit.width > 768 && ScreenFit.width < 1200;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return largeScreen;
        } else if (constraints.maxWidth < 1200 && constraints.maxWidth > 768) {
          return mediumScreen ?? largeScreen;
        } else {
          return smallScreen ?? largeScreen;
        }
      },
    );
  }
}
