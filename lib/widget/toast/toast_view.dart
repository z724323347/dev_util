import 'package:flutter/material.dart';

/// Toast layout
class ToastView {
  OverlayEntry overlayEntry;
  AnimationController controllerShowAnim;
  AnimationController controllerShowOffset;
  AnimationController controllerHide;
  OverlayState overlayState;
  bool dismissed = false;

  show([time]) async {
    overlayState.insert(overlayEntry);
    controllerShowAnim.forward();
    controllerShowOffset.forward();
    await Future.delayed(Duration(milliseconds: time == null ? 2000 : time));
    this.dismiss();
  }

  dismiss() async {
    if (dismissed) {
      return;
    }
    this.dismissed = true;
    controllerHide.forward();
    await Future.delayed(Duration(milliseconds: 250));
    overlayEntry?.remove();
  }
}
