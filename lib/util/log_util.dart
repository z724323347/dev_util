import 'package:dev_util/time/data_util.dart';
import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';
import 'dart:developer' as dev;

void defaultLog(String value, {bool isError = false}) {
  if (isError || kDebugMode) dev.log(value, name: 'LOGS');
}

/// 日志
/// Log Util.
class LogUtil {
  static const String _TAG_DEF = "logs 💙 ";

  static bool debuggable = false; //是否是debug模式,false: log v 不输出.
  static String TAG = _TAG_DEF;

  /// 是否是debug模式,false: log v 不输出.
  static void init({bool isDebug = false, String tag = _TAG_DEF}) {
    debuggable = isDebug;
    TAG = tag;
  }

  /// debug 开发模式调用
  static void v(Object object, {String tag = _TAG_DEF}) {
    // release模式不打印
    if (kReleaseMode) {
      return;
    }
    var chain = Chain.current(); // Chain.forTrace(StackTrace.current);
    // 将 core 和 flutter 包的堆栈合起来（即相关数据只剩其中一条）
    chain =
        chain.foldFrames((frame) => frame.isCore || frame.package == "flutter");
    // 取出所有信息帧
    final frames = chain.toTrace().frames;
    // 找到当前函数的信息帧
    final idx = frames.indexWhere((element) => element.member == "LogUtil.v");
    if (idx == -1 || idx + 1 >= frames.length) {
      return;
    }
    // 调用当前函数的函数信息帧
    final frame = frames[idx + 1];

    /// time
    var d = DateUtil.getDateStrByDateTime(DateTime.now(),
        format: DateFormat.HOUR_MINUTE_SECOND);
    String sub = '${frame.uri.toString().split("/").last}(line: ${frame.line})';
    _printLog(tag, '$d $sub  =>   ', object);
  }

  /// 长于 512字节的信息，分段后全部输出
  static void _printLog(String tag, String stag, Object object) {
    String da = object.toString();
    String _tag = (tag == null || tag.isEmpty) ? TAG : tag;
    // log 长度切分
    while (da.isNotEmpty) {
      if (da.length > 512) {
        print("$_tag $stag ${da.substring(0, 512)}");
        da = da.substring(512, da.length);
        // log("$_tag $stag ${da.substring(0, 512)}");
      } else {
        print("$_tag $stag $da");
        // log("$_tag $stag $da");
        da = "";
      }
    }
  }
}

///logs 日志
void logs(Object msg, {bool dev = false}) {
  if (kReleaseMode) {
    // release模式不打印
    return;
  }
  var chain = Chain.current(); // Chain.forTrace(StackTrace.current);
  // 将 core 和 flutter 包的堆栈合起来（即相关数据只剩其中一条）
  chain =
      chain.foldFrames((frame) => frame.isCore || frame.package == "flutter");
  // 取出所有信息帧
  final frames = chain.toTrace().frames;
  // 找到当前函数的信息帧
  final idx = frames.indexWhere((element) => element.member == "logs");
  if (idx == -1 || idx + 1 >= frames.length) {
    return;
  }
  // 调用当前函数的函数信息帧
  final frame = frames[idx + 1];

  // time
  var d = DateUtil.getDateStrByDateTime(DateTime.now(),
      format: DateFormat.HOUR_MINUTE_SECOND);
  String str = msg.toString();

  // log 长度切分
  while (str.isNotEmpty) {
    if (str.length > 512) {
      if (dev) {
        defaultLog(
            "logs 💙  $d ${frame.uri.toString().split("/").last}(line: ${frame.line}) =>  ${str.substring(0, 512)}");
      } else {
        print(
            "logs 💙  $d ${frame.uri.toString().split("/").last}(line: ${frame.line}) =>  ${str.substring(0, 512)}");
      }
      str = str.substring(512, str.length);
    } else {
      if (dev) {
        defaultLog(
            "logs 💙  $d ${frame.uri.toString().split("/").last}(line: ${frame.line}) =>  $str");
      } else {
        print(
            "logs 💙  $d ${frame.uri.toString().split("/").last}(line: ${frame.line}) =>  $str");
      }

      str = "";
    }
  }
}
