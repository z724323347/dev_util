import 'package:flutter/material.dart';

import 'flow_bar_delegate.dart';

/// FlowBar
class FlowBar extends StatefulWidget {
  final List<FlowBarData> datList;

  final Function(int) onItemClick;

  final Size preferredSize;

  final int selectIndex;

  final BorderRadius borderRadius;

  final TextStyle style;
  FlowBar({
    @required this.datList,
    this.onItemClick,
    this.preferredSize,
    this.selectIndex = 0,
    this.borderRadius,
    this.style,
  });

  @override
  _FlowBarState createState() => _FlowBarState();
}

class _FlowBarState extends State<FlowBar> with SingleTickerProviderStateMixin {
  double _width = 0;
  int _selectIndex = 0;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this)
      ..addListener(_render)
      ..addStatusListener(_listenStatus);
    _selectIndex = widget.selectIndex;
    super.initState();
  }

  void _render() {
    setState(() {});
  }

  void _listenStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {});
    }
  }

  // int get nextIndex => (_selectIndex + 1) % widget.datList.length;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width / widget.datList.length;

    return Container(
      alignment: Alignment.center,
      child: Flow(
          delegate: FlowBarDelegate(_selectIndex, _controller.value,
              (widget.preferredSize ?? Size.fromHeight(56)).height),
          children: widget.datList
              .map((v) => GestureDetector(
                    onTap: () {
                      _onTap(v);
                    },
                    child: _buildChild(v),
                  ))
              .toList()),
    );
  }

  /// child widget
  Widget _buildChild(FlowBarData d) => Container(
        alignment: const Alignment(0, 0.4),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: _selectIndex == d.id
                      ? Colors.transparent
                      : Theme.of(context).accentColor,
                  offset: Offset(1, 1),
                  blurRadius: 2)
            ],
            color: Theme.of(context).accentColor,
            borderRadius: widget.borderRadius),
        height: (widget.preferredSize.height + 20),
        width: _width,
        child: d.view ??
            Text(
              d.title,
              style: widget.style ??
                  TextStyle(color: Colors.white, shadows: [
                    const Shadow(
                        color: Colors.black,
                        offset: Offset(0.5, 0.5),
                        blurRadius: 0.5)
                  ]),
            ),
      );

  /// onTap event
  void _onTap(FlowBarData d) {
    setState(() {
      _controller.reset();
      _controller.forward();
      _selectIndex = d.id;
      if (widget.onItemClick != null) widget.onItemClick(_selectIndex);
    });
  }
}

class FlowBarData {
  /// id
  final int id;

  /// text
  final String title;

  /// color
  final Colors bgColor;

  /// 自定义widget
  final Widget view;

  FlowBarData({this.id, this.title, this.bgColor, this.view});
}
