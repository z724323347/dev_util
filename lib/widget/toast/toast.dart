import 'package:dev_util/widget/toast/toast_overlay.dart';
import 'package:dev_util/widget/toast/toast_view.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

//Toast 显示位置控制
enum ToastPosition {
  top,
  center,
  bottom,
}

// Toast
class Toast {
  static ToastView preToast;
  // 显示位置
  static ToastPosition _p;
  // 是否横屏
  static bool _landscape = false;
  static void show(OverlayState context, String msg,
      {int time, bool landscape = false, ToastPosition position}) {
    preToast?.dismiss();
    preToast = null;
    _p = position ?? ToastPosition.bottom;
    _landscape = landscape ?? false;
    OverlayState overlayState = context;

    var controllerShowAnim = AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 250),
    );
    var controllerShowOffset = AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 350),
    );
    var controllerHide = AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 250),
    );
    var opacityAnim1 =
        new Tween(begin: 0.0, end: 1.0).animate(controllerShowAnim);
    var controllerCurvedShowOffset = CurvedAnimation(
        parent: controllerShowOffset, curve: _BounceOutCurve._());
    var offsetAnim =
        new Tween(begin: 30.0, end: 0.0).animate(controllerCurvedShowOffset);
    var opacityAnim2 = Tween(begin: 1.0, end: 0.0).animate(controllerHide);

    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return ToastOverlay(
        opacityAnim1: opacityAnim1,
        opacityAnim2: opacityAnim2,
        offsetAnim: offsetAnim,
        child: buildToastLayout(msg, _p, _landscape),
      );
    });
    var toastView = ToastView();
    toastView.overlayEntry = overlayEntry;
    toastView.controllerShowAnim = controllerShowAnim;
    toastView.controllerShowOffset = controllerShowOffset;
    toastView.controllerHide = controllerHide;
    toastView.overlayState = overlayState;
    preToast = toastView;
    toastView.show(Duration(milliseconds: time ?? 1000));
  }

  static LayoutBuilder buildToastLayout(
      String msg, ToastPosition p, bool landscape) {
    return LayoutBuilder(builder: (context, constraints) {
      return IgnorePointer(
        ignoring: true,
        child: Container(
          child: Material(
            color: Colors.white.withOpacity(0),
            child: Transform.rotate(
              angle: landscape ? math.pi / 2 : 0,
              child: Container(
                child: Container(
                  child: Text(
                    msg ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                margin: EdgeInsets.only(
                  top: p == ToastPosition.top
                      ? constraints.biggest.height * 0.15
                      : 0,
                  bottom: constraints.biggest.height * 0.15,
                  left: constraints.biggest.width * 0.2,
                  right: constraints.biggest.width * 0.2,
                ),
              ),
            ),
          ),
          alignment:
              landscape ? setAlignment(ToastPosition.center) : setAlignment(p),
        ),
      );
    });
  }

  /// 设置toast位置
  static AlignmentGeometry setAlignment(ToastPosition postion) {
    if (postion == ToastPosition.top) {
      return Alignment.topCenter;
    } else if (postion == ToastPosition.center) {
      return Alignment.center;
    } else {
      return Alignment.bottomCenter;
    }
  }
}

class _BounceOutCurve extends Curve {
  const _BounceOutCurve._();

  @override
  double transform(double t) {
    t -= 1.0;
    return t * t * ((2 + 1) * t + 2) + 1.0;
  }
}
