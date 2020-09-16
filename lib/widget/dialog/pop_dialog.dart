import 'package:dev_util/dev_util.dart';
import 'package:dev_util/global/global_navigator.dart';
import 'package:flutter/material.dart';

import 'slide_pop_dialog.dart';

/// diaolg  弹出窗
class PopDialog {
  /// 全局弹窗 AlertDialog
  static void showGlobalAlert(Widget child, bool dismiss) {
    GlobalNavigator.dialog<Route>(
        barrierDismissible: dismiss,
        builder: (_) {
          return GestureDetector(
            child: AlertDialog(
              actionsPadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              content: child,
            ),
          );
        });
  }

  /// 全局弹窗 MaterialDialog
  ///
  /// call 回调，部分需求的回调 (如，点击外部消失清空选中数据等)
  static void showGlobalMaterial(Widget child, bool dismiss, {Function call}) {
    GlobalNavigator.dialog<Route>(
        barrierDismissible: dismiss,
        builder: (_) {
          return GestureDetector(
            onTap: () {
              if (dismiss) {
                GlobalNavigator.pop();
                if (call != null) {
                  call();
                }
              } else {
                return null;
              }
            },
            child: Material(
              type: MaterialType.transparency,
              child: GestureDetector(onTap: () => null, child: child),
            ),
          );
        });
  }

  /// context 弹窗 AlertDialog
  static void showContextAlert(BuildContext ctx, Widget child, bool dismiss) {
    showDialog<Null>(
      context: ctx,
      barrierDismissible: dismiss,
      builder: (_) => GestureDetector(
        child: AlertDialog(
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          content: child,
        ),
      ),
    );
  }

  /// 确认/取消  等自定义事件交互弹窗
  static void popConfirmDialog(
    Widget child, {
    Color bgColor,
    Duration transitionDuration = const Duration(milliseconds: 200),
  }) {
    showGeneralDialog<Route>(
        context: DevUtils.context,
        transitionDuration: transitionDuration,
        barrierDismissible: true,
        barrierLabel: 'Confirm',
        barrierColor: bgColor ?? Colors.black.withOpacity(.5),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation secondaryAnimation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        });
  }

  /// silde 底部动画弹出自定义事件dialog
  static void showSlideDialog(
    Widget child, {
    Color barrierColor,
    bool barrierDismissible = true,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Color pillColor,
    Color backgroundColor,
    double height,
  }) {
    assert(child != null);
    showGeneralDialog<Route>(
      context: DevUtils.context,
      pageBuilder: (context, animation1, animation2) {},
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
      barrierDismissible: barrierDismissible,
      barrierLabel: "Slide",
      transitionDuration: transitionDuration,
      transitionBuilder: (context, animation1, animation2, widget) {
        final curvedValue = Curves.easeInOut.transform(animation1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * -300, 0.0),
          child: Opacity(
            opacity: animation1.value,
            child: SlideDialog(
              child: child,
              height: height,
              pillColor: pillColor ?? Colors.blueGrey[200],
              backgroundColor: backgroundColor ?? Theme.of(context).canvasColor,
            ),
          ),
        );
      },
    );
  }
}
