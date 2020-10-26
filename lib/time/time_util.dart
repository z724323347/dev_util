import 'package:date_range_picker/date_range_picker.dart' as pick;
import 'package:dev_util/time/data_util.dart';
import 'package:flutter/material.dart';

/// 时间 utils
class TimeUtil {
  /// 日历时间选择
  ///
  /// day  默认选中多少天
  ///
  /// after  是否向后选日期 ，默认向后true ， 向前选日期 false
  ///
  ///firstDate 开始年月
  ///
  ///lastDate 结束年月
  ///
  ///timeInterval 已选择日期
  ///
  ///  return List<DateTime> picked
  Future<List<DateTime>> picked(
    BuildContext context, {
    int day,
    bool after = true,
    DateTime firstDate,
    DateTime lastDate,
    List<DateTime> timeInterval,
  }) async {
    final List<DateTime> picked = await pick.showDatePicker(
      context: context,
      initialFirstDate: timeInterval.isNotEmpty
          ? timeInterval[0]
          : after
              ? DateTime.now()
              : DateTime.now().subtract(Duration(days: day ?? 7)),
      initialLastDate: timeInterval.isNotEmpty
          ? timeInterval[1]
          : after
              ? DateTime.now().add(Duration(days: day ?? 7))
              : DateTime.now(),
      firstDate: firstDate ?? DateTime(2015),
      lastDate: lastDate ?? DateTime(2030),
    );
    // if (picked != null && picked.length == 2) {
    //   print( 'TimeUtil   ${picked}');
    // }
    return picked;
  }

  /// 选择 今天之后的多少天
  static List<DateTime> getDayList(int day) {
    List<DateTime> dl = [];
    for (var i = 0; i < day; i++) {
      DateTime d = DateTime.now().add(Duration(days: i));
      dl.add(d);
    }
    return dl;
  }

  /// 选择 今天之前的多少天
  static List<DateTime> getBeforeDayList(int day) {
    List<DateTime> dl = [];
    for (var i = 0; i < day; i++) {
      DateTime d = DateTime.now().subtract(Duration(days: i));
      dl.add(d);
    }
    return dl;
  }

  static String getDays(int hours) {
    String date;
    DateTime today = DateTime.now();
    DateTime _date = today.subtract(Duration(hours: hours));
    // date = new DateFormat('yyyy-MM-dd HH:mm:ss').format(_date).toString();
    date = DateUtil.getDateStrByTimeStr(_date.toString(),
        format: DateFormat.NORMAL);
    return date;
  }

  static Object getDateTimeList(int day) {
    if (day == 1) {
      return DateTime.now();
    } else if (day == 2) {
      return [DateTime.now().subtract(Duration(days: 1))];
    } else if (day == 7) {
      return [DateTime.now().subtract(Duration(days: 7)), DateTime.now()];
    } else {
      return DateTime.now();
    }
  }

  ///根据给定的日期得到format后的日期 (2012-02-27 13:27:00.123456789)
  static String getToDay(String dateOriginal, {bool showToday = false}) {
    //现在的日期
    var today = DateTime.now();
    //今天的23:59:59
    var standardDate = DateTime(today.year, today.month, today.day, 23, 59, 59);
    //传入的日期与今天的23:59:59秒进行比较
    Duration diff = standardDate.difference(DateTime.parse(dateOriginal));
    // print('日期比较结果${diff.inDays}');
    if (diff < Duration(days: 1)) {
      //今天
      // 09:20
      // return dateOriginal.substring(11, 16);
      if (showToday) {
        return dateOriginal.substring(11, 16);
      } else {
        return '今日';
      }
    } else if (diff >= Duration(days: 1) && diff < Duration(days: 2)) {
      //昨天
      //昨天09:20
      // return "昨天 " + dateOriginal.substring(11, 16);
      return "昨天";
    } else {
      //昨天之前
      // 2019-01-23 09:20
      return dateOriginal.substring(0, 10);
    }
  }
}
