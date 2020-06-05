import 'dart:math';

import 'package:flutter/material.dart';
import 'route_util.dart';

class RouteTransition extends PageRouteBuilder<PageRouteBuilder> {
  final Widget fromPage;
  final Widget toPage;
  final Duration duration;
  final Curve curve;
  final TransitionType type;
  final SlideDirection direction;
  final Axis axis;
  RouteTransition(
      {@required this.toPage,
      this.fromPage,
      this.direction,
      this.curve,
      this.duration,
      this.type,
      this.axis})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                toPage,
            transitionDuration: duration,
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              switch (type) {
                case TransitionType.fade: // 渐变透明路由动画
                  return FadeTransition(
                      opacity: Tween(begin: 0.1, end: 1.0).animate(
                          CurvedAnimation(parent: animation, curve: curve)),
                      child: child);
                  break;
                case TransitionType.rotate: // 旋转动画
                  return RotationTransition(
                      turns: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(parent: animation, curve: curve)),
                      child: child);
                  break;
                case TransitionType.scale: // 缩放路由动画
                  return ScaleTransition(
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(parent: animation, curve: curve)),
                      child: child);
                  break;
                case TransitionType.size: //
                  return Center(
                      child: SizeTransition(
                          sizeFactor: Tween<double>(begin: 0.0, end: 1.0)
                              .animate(CurvedAnimation(
                                  parent: animation, curve: curve)),
                          axis: axis,
                          child: child));
                  break;
                case TransitionType.scale_rotate: //
                  return ScaleTransition(
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(parent: animation, curve: curve)),
                      child: RotationTransition(
                          turns: Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(parent: animation, curve: curve)),
                          child: child));
                  break;
                case TransitionType.transform:
                  return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0001)
                        ..rotateX(animation.value * pi * 2)
                        ..rotateY(animation.value * pi * 2),
                      alignment: FractionalOffset.center,
                      child: child);
                  break;
                case TransitionType.enter_exit:
                  Offset begin, end;

                  switch (direction) {
                    case SlideDirection.left2right:
                      begin = Offset(-1.0, 0.0);
                      end = Offset(1.0, 0.0);
                      break;
                    case SlideDirection.right2left:
                      begin = Offset(1.0, 0.0);
                      end = Offset(-1.0, 0.0);
                      break;
                    case SlideDirection.bottom2top:
                      begin = Offset(0.0, 1.0);
                      end = Offset(0.0, -1.0);
                      break;
                    case SlideDirection.top2bottom:
                      begin = Offset(0.0, -1.0);
                      end = Offset(0.0, 1.0);
                      break;
                    default:
                      break;
                  }

                  return Stack(children: <Widget>[
                    SlideTransition(
                        position: Tween<Offset>(begin: Offset.zero, end: end)
                            .animate(CurvedAnimation(
                                parent: animation, curve: curve)),
                        child: fromPage),
                    SlideTransition(
                        position: Tween<Offset>(begin: begin, end: Offset.zero)
                            .animate(CurvedAnimation(
                                parent: animation, curve: curve)),
                        child: toPage)
                  ]);
                  break;
                case TransitionType.slide_left:
                  return SlideTransition(
                      position: Tween<Offset>(
                              begin: Offset(1.0, 0.0), end: Offset.zero)
                          .animate(
                              CurvedAnimation(parent: animation, curve: curve)),
                      child: child);
                  break;
                case TransitionType.slide_top:
                  return SlideTransition(
                      position: Tween<Offset>(
                              begin: Offset(0.0, 1.0), end: Offset.zero)
                          .animate(
                              CurvedAnimation(parent: animation, curve: curve)),
                      child: child);
                  break;
                case TransitionType.slide_right:
                  return SlideTransition(
                      position: Tween<Offset>(
                              begin: Offset(-1.0, 0.0), end: Offset.zero)
                          .animate(
                              CurvedAnimation(parent: animation, curve: curve)),
                      child: child);
                  break;
                case TransitionType.slide_bottom:
                  return SlideTransition(
                      position: Tween<Offset>(
                              begin: Offset(0.0, -1.0), end: Offset.zero)
                          .animate(
                              CurvedAnimation(parent: animation, curve: curve)),
                      child: child);
                  break;
                default:
                  return child;
              }
            });
}
