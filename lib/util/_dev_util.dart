// import 'package:dev_util/global/global_navigator.dart';
// import 'package:dev_util/widget/toast/toast.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class DevUtils {
//   static BuildContext context =
//       GlobalNavigator.navigatorKey.currentState.overlay.context;
//   static OverlayState overlayState =
//       GlobalNavigator.navigatorKey.currentState.overlay;

//   /// toast
//   void toast(String message,{int time, ToastPosition position, bool landscape,}) {
//     Toast.show(overlayState, message, time: time, position: position, landscape: landscape);
//   }

//   /// Notifiy
//   void notifiy(String title, {String message, int time, Widget child}) {
//     // Notifiy.show(overlayState, title, message, time: time, child: child);
//   }

//   /// copy 复制文本
//   void copy({String text}) {
//     Clipboard.setData(ClipboardData(text: text ?? ''));
//   }

//   /// 确认/取消  等自定义事件交互弹窗
//   Future showPopDialog(Widget child, {Color bgColor, int time}) async {
//     showGeneralDialog(
//         context: context,
//         transitionDuration: Duration(milliseconds: time ?? 200),
//         barrierDismissible: true,
//         barrierLabel: '',
//         barrierColor: bgColor ?? Colors.black.withOpacity(.5),
//         pageBuilder: (BuildContext context, Animation animation,
//             Animation secondaryAnimation) {
//           return ScaleTransition(
//             scale: animation,
//             child: child,
//           );
//         });
//   }
// }
