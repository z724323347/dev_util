import 'package:flutter/material.dart';

import 'drop_controller.dart';

class DropMenuBuilder {
  final Widget dropDownWidget;
  final double dropDownHeight;

  DropMenuBuilder(
      {@required this.dropDownWidget, @required this.dropDownHeight});
}

class DropMenu extends StatefulWidget {
  final DropMenuController controller;
  final List<DropMenuBuilder> menus;
  final int animationMilliseconds;
  final Color maskColor;

  const DropMenu(
      {Key key,
      @required this.controller,
      @required this.menus,
      this.animationMilliseconds = 500,
      this.maskColor = const Color.fromRGBO(0, 0, 0, 0.5)})
      : super(key: key);

  @override
  _DropMenuState createState() => _DropMenuState();
}

class _DropMenuState extends State<DropMenu>
    with SingleTickerProviderStateMixin {
  bool _isShowDropDownItemWidget = false;
  bool _isShowMask = false;
  bool _isControllerDisposed = false;
  Animation<double> _animation;
  AnimationController _controller;

  double _maskColorOpacity;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      _showDropDownItemWidget();
    });
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.animationMilliseconds),
        vsync: this);
  }

  @override
  Widget build(BuildContext context) {
//    print('_DropMenuState.build');
    _controller.duration = Duration(milliseconds: widget.animationMilliseconds);
    return _buildDropDownWidget();
  }

  dispose() {
    _controller.dispose();
    _isControllerDisposed = true;
    super.dispose();
  }

  void _showDropDownItemWidget() {
    int menuIndex = widget.controller.menuIndex;
    if (menuIndex >= widget.menus.length || widget.menus[menuIndex] == null) {
      return;
    }

    _isShowDropDownItemWidget = !_isShowDropDownItemWidget;
    _isShowMask = !_isShowMask;

    var dropDownHeight2 = widget.menus[menuIndex].dropDownHeight;
    _animation =
        new Tween(begin: 0.0, end: dropDownHeight2).animate(_controller)
          ..addListener(() {
//        print('${_animation.value}');
            var heightScale = _animation.value / dropDownHeight2;
            _maskColorOpacity = widget.maskColor.opacity * heightScale;
//        print('$_maskColorOpacity');
            //这行如果不写，没有动画效果
            setState(() {});
          });

    if (_isControllerDisposed) return;

//    print('${widget.controller.isShow}');

    if (widget.controller.isShow) {
      _controller.forward();
    } else if (widget.controller.isShowHideAnimation) {
      _controller.reverse();
    } else {
      _controller.value = 0;
    }
  }

  Widget _mask() {
    if (_isShowMask) {
      return GestureDetector(
        onTap: () {
          widget.controller.hide();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: widget.maskColor.withOpacity(_maskColorOpacity),
//          color: widget.maskColor,
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget _buildDropDownWidget() {
    int menuIndex = widget.controller.menuIndex;

    if (menuIndex >= widget.menus.length) {
      return Container();
    }

    return Positioned(
        width: MediaQuery.of(context).size.width,
        // top: widget.controller.dropDownHeaderHeight,
        top: 0,
        left: 0,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: _animation == null ? 0 : _animation.value,
              child: widget.menus[menuIndex].dropDownWidget,
            ),
            _mask()
          ],
        ));
  }
}
