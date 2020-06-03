import 'package:flutter/material.dart';

class FlowBarDelegate extends FlowDelegate {
  final int selectIndex;
  final double factor;
  final double height;
  FlowBarDelegate(
    this.selectIndex,
    this.factor,
    this.height,
  );

  @override
  void paintChildren(FlowPaintingContext context) {
    double ox = 0;
    double obx = 0;

    for (int i = 0; i < context.childCount / 2; i++) {
      var cSize = context.getChildSize(i);
      if (i == selectIndex) {
        context.paintChild(i,
            transform: Matrix4.translationValues(ox, 20.0 * factor - 20, 0.0));
        ox += cSize.width;
      } else {
        context.paintChild(i,
            transform: Matrix4.translationValues(ox, -20, 0.0));
        ox += cSize.width;
      }
    }
    for (int i = (context.childCount / 2).floor();
        i < context.childCount;
        i++) {
      if (i - (context.childCount / 2).floor() == selectIndex) {
        obx += context.getChildSize(0).width;
      } else {
        context.paintChild(i,
            transform: Matrix4.translationValues(
                obx + context.getChildSize(0).width / 2 - 5, height + 5, 0));
        obx += context.getChildSize(0).width;
      }
    }
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) => true;
}
