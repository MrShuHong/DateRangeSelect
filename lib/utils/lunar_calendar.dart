
import 'lunar_util.dart';
import 'solar_term_util.dart';

class LunarCalendar {
   static final int MIN_YEAR = 1900;

  /// 农历月份第一天转写
  static List<String> _MONTH_STR = [
    "春节",
    "二月",
    "三月",
    "四月",
    "五月",
    "六月",
    "七月",
    "八月",
    "九月",
    "十月",
    "冬月",
    "腊月"
  ];

  /// 传统农历节日
  static List<String> _TRADITION_FESTIVAL_STR = [
    "除夕",
    "0101春节",
    "0115元宵",
    "0505端午",
    "0707七夕",
    "0815中秋",
    "0909重阳"
  ];

  /// 农历大写
  static List<String> _DAY_STR = [
    "初一",
    "初二",
    "初三",
    "初四",
    "初五",
    "初六",
    "初七",
    "初八",
    "初九",
    "初十",
    "十一",
    "十二",
    "十三",
    "十四",
    "十五",
    "十六",
    "十七",
    "十八",
    "十九",
    "二十",
    "廿一",
    "廿二",
    "廿三",
    "廿四",
    "廿五",
    "廿六",
    "廿七",
    "廿八",
    "廿九",
    "三十"
  ];

  /// 特殊节日的数组
  static List<String> _SPECIAL_FESTIVAL_STR = ["母亲节", "父亲节", "感恩节"];

  /// 特殊节日、母亲节和父亲节,感恩节等
  static final Map<int, List<String>> _SPECIAL_FESTIVAL = Map();

  /// 公历节日
  static List<String> _SOLAR_CALENDAR = [
    "0101元旦",
    "0214情人节",
    "0308妇女节",
    "0312植树节",
    "0315消权日",
    "0401愚人节",
    "0422地球日",
    "0501劳动节",
    "0504青年节",
    "0601儿童节",
    "0701建党节",
    "0801建军节",
    "0910教师节",
    "1001国庆节",
    "1031万圣节",
    "1111光棍节",
    "1224平安夜",
    "1225圣诞节"
  ];

  /// 保存每年24节气
  static final Map<int, List<String>> _SOLAR_TERMS = Map();

  /// 返回传统农历节日
  /// @param year  农历年
  /// @param month 农历月
  /// @param day   农历日
  /// @return 返回传统农历节日
  static String _getTraditionFestival(int year, int month, int day) {
     if (month == 12) {
        int count = daysInLunarMonth(year, month);
        if (day == count) {
           return _TRADITION_FESTIVAL_STR[0];//除夕
        }
     }
     String text = getString(month, day);
     String festivalStr = "";
     for (String festival in _TRADITION_FESTIVAL_STR) {
        if (festival.contains(text)) {
           festivalStr = festival.replaceAll(text, "");
           break;
        }
     }
     return festivalStr;
  }


  /**
   * 数字转换为汉字月份
   *
   * @param month 月
   * @param leap  1==闰月
   * @return 数字转换为汉字月份
   */
   static String numToChineseMonth(int month, int leap) {
     if (leap == 1) {
        return "闰" + _MONTH_STR[month - 1];
     }
     return _MONTH_STR[month - 1];
  }

  /// 数字转换为农历节日或者日期
  /// @param month 月
  /// @param day   日
  /// @param leap  1==闰月
  /// @return 数字转换为汉字日
   static String numToChinese(int month, int day, int leap) {
     if (day == 1) {
        return numToChineseMonth(month, leap);
     }
     print("$day");
     if(_DAY_STR == null || _DAY_STR.length == 0){
       print("_DAY_STR = null");
     }
     return _DAY_STR[day - 1];
  }

  /// 用来表示1900年到2099年间农历年份的相关信息，共24位bit的16进制表示，其中：
  /// 1. 前4位表示该年闰哪个月；
  /// 2. 5-17位表示农历年份13个月的大小月分布，0表示小，1表示大；
  /// 3. 最后7位表示农历年首（正月初一）对应的公历日期。
  /// <p/>
  /// 以2014年的数据0x955ABF为例说明：
  /// 1001 0101 0101 1010 1011 1111
  /// 闰九月 农历正月初一对应公历1月31号
  static final List<int> LUNAR_INFO = [
  0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,//1900-1909
  0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,//1910-1919
  0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,//1920-1929
  0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,//1930-1939
  0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,//1940-1949
  0x06ca0,0x0b550,0x15355,0x04da0,0x0a5b0,0x14573,0x052b0,0x0a9a8,0x0e950,0x06aa0,//1950-1959
  0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,//1960-1969
  0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b6a0,0x195a6,//1970-1979
  0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,//1980-1989
  0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,//1990-1999
  0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,//2000-2009
  0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,//2010-2019
  0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,//2020-2029
  0x05aa0,0x076a3,0x096d0,0x04afb,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,//2030-2039
  0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0,//2040-2049
  0x14b63,0x09370,0x049f8,0x04970,0x064b0,0x168a6,0x0ea50, 0x06b20,0x1a6c4,0x0aae0,//2050-2059
  0x0a2e0,0x0d2e3,0x0c960,0x0d557,0x0d4a0,0x0da50,0x05d55,0x056a0,0x0a6d0,0x055d4,//2060-2069
  0x052d0,0x0a9b8,0x0a950,0x0b4a0,0x0b6a6,0x0ad50,0x055a0,0x0aba4,0x0a5b0,0x052b0,//2070-2079
  0x0b273,0x06930,0x07337,0x06aa0,0x0ad50,0x14b55,0x04b60,0x0a570,0x054e4,0x0d160,//2080-2089
  0x0e968,0x0d520,0x0daa0,0x16aa6,0x056d0,0x04ae0,0x0a9d4,0x0a2d0,0x0d150,0x0f252,//2090-2099
  0x0d520
  ];


  /// 农历 year年month月的总天数，总共有13个月包括闰月
  ///
  /// @param year  将要计算的年份
  /// @param month 将要计算的月份
  /// @return 传回农历 year年month月的总天数
  static int daysInLunarMonth(int year, int month) {
     if ((LUNAR_INFO[year - MIN_YEAR] & (0x10000 >> month)) == 0)
        return 29;
     else
        return 30;
  }

  /**
   * 获取公历节日
   *
   * @param month 公历月份
   * @param day   公历日期
   * @return 公历节日
   */
  static String _gregorianFestival(int month, int day) {
     String text = getString(month, day);
     String solar = "";
     for (String aMSolarCalendar in _SOLAR_CALENDAR) {
        if (aMSolarCalendar.contains(text)) {
           solar = aMSolarCalendar.replaceAll(text, "");
           break;
        }
     }
     return solar;
  }

  static String getString(int month, int day) {
     return (month >= 10 ? month.toString() : "0$month") + (day >= 10 ? day.toString() : "0$day");
  }


  /// 返回24节气
  ///
  /// @param year  年
  /// @param month 月
  /// @param day   日
  /// @return 返回24节气
   static String _getSolarTerm(int year, int month, int day) {
     if (!_SOLAR_TERMS.containsKey(year)) {
        _SOLAR_TERMS[year]= SolarTermUtil.getSolarTerms(year);
     }
     List<String> solarTerm = _SOLAR_TERMS[year];
     String text = "$year${getString(month, day)}";
     String solar = "";
     assert (solarTerm != null);
     for (String solarTermName in solarTerm) {
        if (solarTermName.contains(text)) {
           solar = solarTermName.replaceAll(text, "");
           break;
        }
     }
     return solar;
  }


  /// 获取农历节日
  /// @return 农历节日
   static String getLunarText(DateTime dateTime) {
     int year = dateTime.year;
     int month = dateTime.month;
     int day = dateTime.day;
     String termText = LunarCalendar._getSolarTerm(year, month, day);
     String solar = LunarCalendar._gregorianFestival(month, day);
     if (solar.isNotEmpty)
        return solar;
     if (termText.isNotEmpty)
        return termText;
     List<int> lunar = LunarUtil.solarToLunar(year, month, day);
     String festival = _getTraditionFestival(lunar[0], lunar[1], lunar[2]);
     if (festival.isNotEmpty)
        return festival;
     return LunarCalendar.numToChinese(lunar[1], lunar[2], lunar[3]);
  }


  /// 获取特殊计算方式的节日
  /// 如：每年五月的第二个星期日为母亲节，六月的第三个星期日为父亲节
  /// 每年11月第四个星期四定为"感恩节"
  ///
  /// @param year  year
  /// @param month month
  /// @param day   day
  /// @return 获取西方节日
  static String _getSpecialFestival(int year, int month, int day) {
     if (!_SPECIAL_FESTIVAL.containsKey(year)) {
        _SPECIAL_FESTIVAL[year] = getSpecialFestivals(year);
     }
     List<String> specialFestivals =  _SPECIAL_FESTIVAL[year];
     String text = "$year${getString(month, day)}";
     String solar = "";
     assert(specialFestivals != null) ;

     for (String special in specialFestivals) {
        if (special.contains(text)) {

           solar = special.replaceAll(text, "");
           break;
        }
     }
     return solar;
  }


  /// 获取每年的母亲节和父亲节和感恩节
  /// 特殊计算方式的节日
  ///
  /// @param year 年
  /// @return 获取每年的母亲节和父亲节、感恩节
   static List<String> getSpecialFestivals(int year) {
      List<String> festivals = List<String>(3);
      DateTime date = DateTime(year,4,1);

     int week = date.weekday;
     int startDiff = 7 - week + 1;
     if (startDiff == 7) {
        festivals[0] = dateToString(year, 5, startDiff + 1) + _SPECIAL_FESTIVAL_STR[0];
     } else {
        festivals[0] = dateToString(year, 5, startDiff + 7 + 1) + _SPECIAL_FESTIVAL_STR[0];
     }
     date = DateTime(year,5,1);
     week =  date.weekday;
     startDiff = 7 - week + 1;
     if (startDiff == 7) {
        festivals[1] = dateToString(year, 6, startDiff + 7 + 1) + _SPECIAL_FESTIVAL_STR[1];
     } else {
        festivals[1] = dateToString(year, 6, startDiff + 7 + 7 + 1) + _SPECIAL_FESTIVAL_STR[1];
     }

     date = DateTime(year,10,1);
     week =  date.weekday;
     startDiff = 7 - week + 1;
     if (startDiff <= 2) {
        festivals[2] = dateToString(year, 11, startDiff + 21 + 5) + _SPECIAL_FESTIVAL_STR[2];
     } else {
        festivals[2] = dateToString(year, 11, startDiff + 14 + 5) + _SPECIAL_FESTIVAL_STR[2];
     }
     return festivals;
  }


  static String dateToString(int year, int month, int day) {
     return "$year${getString(month, day)}";
  }

}
