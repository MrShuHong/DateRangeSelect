
class DateUtils {
  /// 获取一个月的开始时间
  static DateTime getMonthFirstTime({DateTime dateTime}) {
    DateTime nowDate = dateTime ?? DateTime.now();
    return DateTime(nowDate.year, nowDate.month, 1, 0, 0, 0, 0, 0);
  }

  ///获取一个月的结束时间
  static DateTime getMonthEndTime({DateTime dateTime}) {
    DateTime nowDate = dateTime ?? DateTime.now();
    return DateTime(nowDate.year, nowDate.month + 1, 1, 0, 0, 0, 0, 0)
        .add(Duration(microseconds: -1));
  }

  ///获取季度的开始时间
  static DateTime getQuarterFirstTime({DateTime dateTime}) {
    DateTime nowDate = dateTime ?? DateTime.now();
    int quarter;
    if (nowDate.month >= 1 && nowDate.month < 4) {
      quarter = 0;
    } else if (nowDate.month >= 4 && nowDate.month < 7) {
      quarter = 1;
    } else if (nowDate.month >= 7 && nowDate.month < 10) {
      quarter = 2;
    } else if (nowDate.month >= 10 && nowDate.month < 12) {
      quarter = 3;
    }

    //0 * 3 +1 = 1月
    return DateTime(nowDate.year, quarter * 3 + 1, 1, 0, 0, 0, 0, 0);
  }

  ///获取季度的结束时间
  static DateTime getQuarterEndTime({DateTime dateTime}) {
    DateTime nowDate = dateTime ?? DateTime.now();
    int quarter;
    if (nowDate.month >= 1 && nowDate.month < 4) {
      quarter = 0;
    } else if (nowDate.month >= 4 && nowDate.month < 7) {
      quarter = 1;
    } else if (nowDate.month >= 7 && nowDate.month < 10) {
      quarter = 2;
    } else if (nowDate.month >= 10 && nowDate.month < 12) {
      quarter = 3;
    }
    //(0+1)* 3 +1 = 4月
    return DateTime(nowDate.year, (quarter + 1) * 3 + 1, 1, 0, 0, 0, 0, 0)
        .add(Duration(microseconds: -1));
  }

  ///获取一年的开始时间
  static DateTime getYearFirstTime({DateTime dateTime}) {
    DateTime nowDate = dateTime ?? DateTime.now();
    return DateTime(nowDate.year, 1, 1, 0, 0, 0, 0, 0);
  }

  ///获取结束的开始时间
  static DateTime getYearEndTime({DateTime dateTime}) {
    DateTime nowDate = dateTime ?? DateTime.now();
    return DateTime(nowDate.year + 1, 1, 1, 0, 0, 0, 0, 0)
        .add(Duration(microseconds: -1));
  }

   /// 周第一天是星期天
  static DateTime getWeekFirstTime({DateTime dateTime}) {
    DateTime nowDate = dateTime ?? DateTime.now();
    int weekDay = nowDate.weekday;
    if (weekDay == 7) {
      weekDay = 0;
    }
    return nowDate.add(Duration(days: -weekDay));
  }

  // 周最后一天星期六
  static DateTime getWeekEndTime({DateTime dateTime}) {
    DateTime nowDate = dateTime ?? DateTime.now();
    int weekDay = nowDate.weekday;
    int weekDayEnd = 7 - weekDay;
    if (weekDay == 7) {
      weekDayEnd = 7;
    }
    return nowDate.add(Duration(days: weekDayEnd));
  }

  static bool isToday(DateTime dateTime1) {
    DateTime dateTime = DateTime.now();
    return dateTime1.year == dateTime.year &&
        dateTime1.month == dateTime.month &&
        dateTime1.day == dateTime.day;
  }

  static bool isSameToday(DateTime dateTime1,DateTime dateTime2) {
    return dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day;
  }
}
