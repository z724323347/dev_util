import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'widget_observer.dart';

const double _kInspectButtonMargin = 10.0;
const double _kErrorReminderButtonMargin = 40.0;
OverlayState overlayState;

class WidgetInspector extends StatefulWidget {
  /// 展示性能监控数据
  static bool debugShowPerformanceMonitor = true;

  /// Creates a widget that enables inspection for the child.
  ///
  /// The [child] argument must not be null.
  const WidgetInspector({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  /// The widget that is being inspected.
  final Widget child;

  @override
  _WidgetInspectorState createState() => _WidgetInspectorState();
}

class _WidgetInspectorState extends State<WidgetInspector> {
  /// Distance from the edge of the bounding box for an element to consider
  /// as selecting the edge of the bounding box.
  final GlobalKey rootGlobalKey = GlobalKey();
  final InspectorSelection selection =
      WidgetInspectorService.instance.selection;

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;

    //release模式不打开FPS监控
    if (bool.fromEnvironment("dart.vm.product")) return child;

    Widget widgetObserver = Container();

    if (WidgetInspector.debugShowPerformanceMonitor) {
      widgetObserver = WidgetObserver();
    }

    if (WidgetInspector.debugShowPerformanceMonitor) {
      child = Stack(
        alignment: AlignmentDirectional.topStart,
        children: <Widget>[
          IgnorePointer(
            ignoring: false,
            key: rootGlobalKey,
            child: child,
          ),
          Positioned(
            right: _kInspectButtonMargin,
            bottom: _kErrorReminderButtonMargin,
            child: widgetObserver,
          )
        ],
      );
    }
    return child;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
