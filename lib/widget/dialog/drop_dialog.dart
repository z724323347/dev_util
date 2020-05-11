import 'package:flutter/material.dart';
/// 下拉 dialog
///
/// 必须配合 Stack 使用
class DropDialog extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Function callBack;
  DropDialog({this.child, this.callBack, this.padding});
  @override
  _DropDialogState createState() => _DropDialogState();
}

class _DropDialogState extends State<DropDialog> with TickerProviderStateMixin {
  List<AnimationController> drawerWidgetControllerList = [];
  bool maskIsShow = false;
  AnimationController maskController;
  Animation<double> maskAnimation;

  final Duration animationDuration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    maskController =
        AnimationController(vsync: this, duration: animationDuration);
    maskAnimation = Tween<double>(begin: 0, end: 0.7)
        .animate(CurvedAnimation(parent: maskController, curve: Curves.linear));

    maskAnimation.addStatusListener((status) {
      /// 监听遮罩动画结束时
      if (status == AnimationStatus.dismissed) {
        setState(() {
          maskIsShow = false;
        });
      }
    });
  }

  @override
  void dispose() {
    maskController.dispose();
    super.dispose();
  }

  void maskOnClick() {
    setState(() {
      maskController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: widget.callBack,
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () {
                return maskOnClick();
              },
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: widget.padding ??
                        EdgeInsets.only(
                          top: 10,
                          bottom: 20,
                          left: 30,
                          right: 30,
                        ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    child: widget.child,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
