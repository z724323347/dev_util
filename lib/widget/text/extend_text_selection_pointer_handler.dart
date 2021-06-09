import 'package:flutter/material.dart';

import 'extend_text_selection.dart';

///builder of textSelectionPointerHandler,you can use this to custom your selection behavior
typedef TextSelectionPointerHandlerWidgetBuilder = Widget Function(
    List<ExtendedTextSelectionState> state);

///help to handle multiple selectionable text on same page.
///
class ExtendedTextSelectionPointerHandler extends StatefulWidget {
  const ExtendedTextSelectionPointerHandler({this.child, this.builder})
      : assert(!(child == null && builder == null)),
        assert(!(child != null && builder != null));
  final Widget child;
  final TextSelectionPointerHandlerWidgetBuilder builder;
  @override
  ExtendedTextSelectionPointerHandlerState createState() =>
      ExtendedTextSelectionPointerHandlerState();
}

class ExtendedTextSelectionPointerHandlerState
    extends State<ExtendedTextSelectionPointerHandler> {
  final List<ExtendedTextSelectionState> _selectionStates =
      <ExtendedTextSelectionState>[];
  List<ExtendedTextSelectionState> get selectionStates => _selectionStates;

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder(_selectionStates);
    }
    return Listener(
      child: widget.child,
      behavior: HitTestBehavior.translucent,
      onPointerDown: (PointerDownEvent value) {
        for (final ExtendedTextSelectionState state in _selectionStates) {
          if (!state.containsPosition(value.position)) {
            //clear other selection
            state.clearSelection();
          }
        }
      },
      onPointerMove: (PointerMoveEvent value) {
        //clear other selection
        for (final ExtendedTextSelectionState state in _selectionStates) {
          state.clearSelection();
        }
      },
    );
  }
}
