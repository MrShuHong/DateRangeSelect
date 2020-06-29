/// 干支纪年算法
/// Created by huanghaibin on 2019/2/12.
class TrunkBranchAnnals {

  /// 天干字符串
  static List<String> _TRUNK_STR = [
    "辛",
    "壬",
    "癸",
    "甲",
    "乙",
    "丙",
    "丁",
    "戊",
    "己",
    "庚",
  ];

  /// 地支字符串
  static List<String> BRANCH_STR = [
    "酉",
    "戌",
    "亥",
    "子",
    "丑",
    "寅",
    "卯",
    "辰",
    "巳",
    "午",
    "未",
    "申"
  ];


  /// 获取某一年对应天干文字
  ///
  /// @param year 年份
  /// @return 天干由甲到癸，每10一轮回
  static String getTrunkString(int year) {
    return _TRUNK_STR[getTrunkInt(year)];
  }

  /// 获取某一年对应天干，
  ///
  /// @param year 年份
  /// @return 4 5 6 7 8 9 10 1 2 3
  static

  int getTrunkInt(int year) {
    int trunk = year % 10;
    return trunk == 0 ? 9 : trunk - 1;
  }

  /// 获取某一年对应地支文字
  ///
  /// @param year 年份
  /// @return 地支由子到亥，每12一轮回
  static String getBranchString(int year) {
    return BRANCH_STR[getBranchInt(year)];
  }

  /// 获取某一年对应地支
  ///
  /// @param year 年份
  /// @return 4 5 6 7 8 9 10 11 12 1 2 3
  static int getBranchInt(int year) {
    int branch = year % 12;
    return branch == 0 ? 11 : branch - 1;
  }

  /// 获取干支纪年
  ///
  /// @param year 年份
  /// @return 干支纪年
   static String getTrunkBranchYear(int year) {
    return "${getTrunkString(year)}${getBranchString(year)}";
  }
}
