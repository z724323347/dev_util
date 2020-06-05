library dev_util;

import 'package:dev_util/generated/l10n.dart';
import 'package:dev_util/global/global_navigator.dart';
import 'package:dev_util/widget/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// toast
export 'package:dev_util/widget/toast/toast.dart';

/// util
// export 'package:dev_util/util/dev_util.dart';
export 'package:dev_util/util/log_util.dart';
export 'package:dev_util/util/regex_util.dart';
export 'package:dev_util/route/route_util.dart';
export 'package:dev_util/route/route_transition.dart';

/// time
export 'package:dev_util/time/data_util.dart';
export 'package:dev_util/time/time_util.dart';
export 'package:dev_util/time/timeline_util.dart';
export 'package:dev_util/time/timer_util.dart';

/// localizations
export 'package:dev_util/locale/cupertino_localizations_delegate.dart';

/// global
export 'package:dev_util/global/global_navigator.dart';
export 'package:dev_util/widget/screen/screen_fit.dart';



/// DevUtils
class DevUtils {
  /// Global Context
  static BuildContext context =
      GlobalNavigator.navigatorKey.currentState.overlay.context;

  /// Global overlay
  static OverlayState overlayState =
      GlobalNavigator.navigatorKey.currentState.overlay;

  /// Global globalKey
  static GlobalKey globalKey = GlobalNavigator.navigatorKey;

  /// toast
  void toast(String message, {int time,ToastPosition position,bool landscape}) {
    try {
      Toast.show(overlayState, message,time: time, position: position, landscape: landscape);
    } catch (e) {
      print(e);
    }
  }

  /// Notifiy
  void notifiy(String title, {String message, int time, Widget child}) {
    // Notifiy.show(overlayState, title, message, time: time, child: child);
  }

  /// copy 复制文本
  void copy({String text}) {
    Clipboard.setData(ClipboardData(text: text ?? ''));
    toast(S.of(context).copied ?? '');
  }

}
