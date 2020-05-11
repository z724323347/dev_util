import 'package:dev_util/time/data_util.dart';

/// 日志
/// Log Util.
class LogUtil {
  static const String _TAG_DEF = "Flutter Log   ";

  static bool debuggable = false; //是否是debug模式,false: log v 不输出.
  static String TAG = _TAG_DEF;

  /// 是否是debug模式,false: log v 不输出.
  static void init({bool isDebug = false, String tag = _TAG_DEF}) {
    debuggable = isDebug;
    TAG = tag;
  }
  /// 
  static void e(Object object, {String tag}) {
    var d = DateUtil.getDateStrByDateTime(DateTime.now(),format: DateFormat.HOUR_MINUTE_SECOND);
    _printLog(tag, '${d}  =>   ', object);
  }

  /// debug 开发模式调用
  static void v(Object object, {String tag}) {
    var d = DateUtil.getDateStrByDateTime(DateTime.now(),format: DateFormat.HOUR_MINUTE_SECOND);
    if (debuggable) {
      _printLog(tag, '${d}  =>   ', object);
    }
  }
  /// 长于 512字节的信息，分段后全部输出
  static void _printLog(String tag, String stag, Object object) {
    String da = object.toString();
    String _tag = (tag == null || tag.isEmpty) ? TAG : tag;
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