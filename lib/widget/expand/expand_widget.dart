import 'package:dev_util/widget/expand/expand_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Default animation duration
const Duration _kExpand = Duration(milliseconds: 300);

/// 折叠组件
/// This widget unfolds a hidden widget to the user, called [child].
/// This action is performed when the user clicks the 'expand' arrow.
class ExpandWidget extends StatefulWidget {
  /// Message used as a tooltip when the widget is minimized
  final String minMessage;

  /// Message used as a tooltip when the widget is maximazed
  final String maxMessage;

  /// Color of the arrow widget. Defaults to the caption text style color.
  final Color arrowColor;

  /// Size of the arrow widget. Default is 30.
  final double arrowSize;

  /// How long the expanding animation takes. Default is 300ms.
  final Duration animationDuration;

  /// This widget will be displayed if the user clicks the 'expand' arrow
  final Widget child;

  const ExpandWidget({
    Key key,
    this.minMessage = 'Show more',
    this.maxMessage = 'Show less',
    this.arrowColor,
    this.arrowSize = 30,
    this.animationDuration = _kExpand,
    @required this.child,
  }) : super(key: key);

  @override
  _ExpandWidgetState createState() => _ExpandWidgetState();
}

class _ExpandWidgetState extends State<ExpandWidget>
    with SingleTickerProviderStateMixin {
  /// Custom animation curve for arrow controll
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeInOutCubic);

  /// Controlls the rotation of the arrow widget
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  /// General animation controller
  AnimationController _controller;

  /// Animations for height control
  Animation<double> _heightFactor;

  /// Animations for arrow's rotation control
  Animation<double> _iconTurns;

  /// Auxiliary variable to controll expand status
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    // Initializing the animation controller with the [duration] parameter
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Initializing both animations, depending on the [_easeInTween] curve
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Method called when the user clicks on the expand arrow
  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  /// Builds the widget itself. If the [_isExpanded] parameter is 'true',
  /// the [child] parameter will contain the child information, passed to
  /// this instance of the object.
  Widget _buildChild(BuildContext context, Widget child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: _heightFactor.value,
            child: child,
          ),
        ),
        ExpandArrow(
          minMessage: widget.minMessage,
          maxMessage: widget.maxMessage,
          color: widget.arrowColor,
          size: widget.arrowSize,
          animation: _iconTurns,
          onTap: _handleTap,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChild,
      child: widget.child,
    );
  }
}

class ExpandArrow extends StatefulWidget {
  final String minMessage, maxMessage;
  final Animation<double> animation;
  final Function onTap;
  final Color color;
  final double size;

  const ExpandArrow({
    this.minMessage,
    this.maxMessage,
    @required this.animation,
    @required this.onTap,
    this.color,
    this.size,
  });

  @override
  _ExpandArrowState createState() => _ExpandArrowState();
}

class _ExpandArrowState extends State<ExpandArrow> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _message,
      child: InkResponse(
        child: RotationTransition(
          turns: widget.animation,
          child: Icon(
            Icons.expand_more,
            color: widget.color ?? Theme.of(context).textTheme.caption.color,
            size: widget.size,
          ),
        ),
        onTap: widget.onTap,
      ),
    );
  }

  /// Shows a tooltip message depending on the [animation] state.
  String get _message =>
      widget.animation.value == 0 ? widget.minMessage : widget.maxMessage;
}
