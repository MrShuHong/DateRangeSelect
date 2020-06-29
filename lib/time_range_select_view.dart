
import 'package:flutter/material.dart';

import 'utils/date_utils.dart';
import 'utils/log_utils.dart';
import 'utils/lunar_calendar.dart';


typedef OnTimeRangeCallback = void Function(
    DateTime startTime, DateTime endTime);

// ignore: must_be_immutable
class TimeRangeSelectView extends StatefulWidget {
  double _width;
  bool _lunar;
  OnTimeRangeCallback timeRangeChange;

  TimeRangeSelectView(
      {double width, bool lunar = false, OnTimeRangeCallback timeRangeChange}) {
    this._width = width;
    this._lunar = lunar;
    this.timeRangeChange = timeRangeChange;
    //LogUtil.e("_width = $_width");
  }

  @override
  _TimeRangeSelectViewState createState() {
    return _TimeRangeSelectViewState(_width, _lunar, timeRangeChange);
  }
}

class _TimeRangeSelectViewState extends State<TimeRangeSelectView> {
  DateTime dateTime = DateTime.now();
  final int maxPageCount = 10000;
  final int initialPage = 5000;
  int currentPage = 5000;
  OnTimeRangeCallback timeRangeChange;
  DateTime rangeStart;
  DateTime rangeEnd;
  double width;
  bool lunar;

  double textSize;
  double lunrTextSize;
  double itemWidth;

  _TimeRangeSelectViewState(
      double width, bool lunar, OnTimeRangeCallback timeRangeChange) {
    this.width = width;
    this.lunar = lunar;
    this.timeRangeChange = timeRangeChange;
    //LogUtil.e("width = $width");
  }

  String getCurrentMonthTime() {
    int diff = currentPage - initialPage;
    DateTime monthTime = DateTime(
        dateTime.year,
        dateTime.month + diff,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
        dateTime.millisecond);
    return "${monthTime.year}年${monthTime.month}月";
  }

  @override
  void initState() {
    super.initState();
    LogUtil.e("width = $width");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    TextStyle titleStyle;
    TextStyle subTitleStyle;

    if (width != null && width <= screenWidth * 3 / 4) {
      subTitleStyle = TextStyle(
        color: Colors.black87,
        fontSize: 10,
      );
      titleStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
      textSize = 12;
      lunrTextSize = 8;
      itemWidth = 25;
    } else {
      subTitleStyle = TextStyle(
        color: Colors.black87,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );
      titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
      textSize = 14;
      lunrTextSize = 10;
      itemWidth = 40;
    }

    return Material(
      child: Container(
        width: width,
        color: Colors.white,
        //padding: EdgeInsets.only(left: 8,right: 8),
        child: Column(
          children: <Widget>[
            Container(
              //padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                getCurrentMonthTime(),
                style: titleStyle,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("周日", textAlign: TextAlign.center, style: subTitleStyle),
                Text("周一", textAlign: TextAlign.center, style: subTitleStyle),
                Text("周二", textAlign: TextAlign.center, style: subTitleStyle),
                Text("周三", textAlign: TextAlign.center, style: subTitleStyle),
                Text("周四", textAlign: TextAlign.center, style: subTitleStyle),
                Text("周五", textAlign: TextAlign.center, style: subTitleStyle),
                Text("周六", textAlign: TextAlign.center, style: subTitleStyle)
              ],
            ),
            //Flexible(
            Container(
                height: width == null ? 240 : width * 0.7,
                child: PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    controller: PageController(initialPage: initialPage),
                    itemCount: maxPageCount,
                    itemBuilder: (context, index) {
                      return _buildMonthPageView(context, index, dateTime);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _buildMonthPageView(
      BuildContext context, int index, DateTime nowTime) {
    int diff = index - initialPage;
    DateTime monthTime = DateTime(
        nowTime.year,
        nowTime.month + diff,
        nowTime.day,
        nowTime.hour,
        nowTime.minute,
        nowTime.second,
        nowTime.millisecond);
    DateTime monthFirstTime = DateUtils.getMonthFirstTime(dateTime: monthTime);
    DateTime monthEndTime = DateUtils.getMonthEndTime(dateTime: monthTime);
    //LogUtil.e("firstTime $monthFirstTime  endTime $monthEndTime");
    DateTime pageStartTime =
        DateUtils.getWeekFirstTime(dateTime: monthFirstTime);
    DateTime pageEndTime = DateUtils.getWeekEndTime(dateTime: monthEndTime);
    int days = pageEndTime.difference(pageStartTime).inDays;
//    LogUtil.e(
//        "pageStartTime= $pageStartTime ; pageEndTime= $pageEndTime ; days= $days");
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, childAspectRatio: 1.2),
        itemCount: days,
        itemBuilder: (context, index) {
          DateTime indexTime = pageStartTime.add(Duration(days: index));

          bool isToday = false;
          bool isSameDay = false;
          int day = indexTime.day;
          TextStyle textStyle;
          TextStyle lunrTextStyle;
          Color color = Colors.transparent;
          BoxDecoration boxDecoration = BoxDecoration(color: color);
          // 加1秒 原因起始时间可能跟monthFirstTime相等
          if (indexTime.add(Duration(seconds: 1)).isAfter(monthFirstTime) &&
              indexTime.isBefore(monthEndTime)) {
            textStyle = TextStyle(color: Colors.black87, fontSize: textSize);
            lunrTextStyle =
                TextStyle(color: Colors.black87, fontSize: lunrTextSize);
            isSameDay = monthTime.day == day;
            isToday = DateUtils.isToday(indexTime);
            if (rangeStart != null && rangeEnd != null) {
              if (indexTime.add(Duration(seconds: 1)).isAfter(rangeStart) &&
                  indexTime.isBefore(rangeEnd.add(Duration(seconds: 1)))) {
                boxDecoration = BoxDecoration(color: Colors.lightBlue[200]);
              }
            } else {
              if (rangeStart != null) {
                if (DateUtils.isSameToday(rangeStart, indexTime)) {
                  color = Color(0xffdddddd);
                }
              } else {
                color = isToday
                    ? Colors.lightBlue
                    : (isSameDay ? Color(0xffdddddd) : Colors.transparent);
              }
              boxDecoration = BoxDecoration(
                  borderRadius: BorderRadius.circular(itemWidth / 2),
                  color: color);
            }
          } else {
            textStyle = TextStyle(color: Colors.black38, fontSize: textSize);
            lunrTextStyle =
                TextStyle(color: Colors.black38, fontSize: lunrTextSize);
          }
          return Material(
            child: InkWell(
              onTap: () {
                updateSateByRangeTime(indexTime, monthFirstTime, monthEndTime);
              },
              child: Center(
                child: Container(
                  width: (rangeStart != null && rangeEnd != null)
                      ? null
                      : itemWidth,
                  height: itemWidth,
                  decoration: boxDecoration,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "$day",
                        style: textStyle,
                      ),
                      lunar
                          ? Text(
                              "${LunarCalendar.getLunarText(indexTime)}",
                              style: lunrTextStyle,
                            )
                          : SizedBox(
                              height: 0,
                            )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void updateSateByRangeTime(
      DateTime indexTime, DateTime monthFirstTime, DateTime monthEndTime) {
    if (indexTime.add(Duration(seconds: 1)).isAfter(monthFirstTime) &&
        indexTime.isBefore(monthEndTime)) {
      setState(() {
        if (rangeStart == null) {
          rangeStart = indexTime;
        } else if (rangeEnd == null) {
          if (DateUtils.isSameToday(indexTime, rangeStart)) {
            rangeStart = indexTime;
          } else {
            if (rangeStart.isAfter(indexTime)) {
              rangeEnd = rangeStart;
              rangeStart = indexTime;
            } else {
              rangeEnd = indexTime;
            }
          }
        } else {
          rangeStart = indexTime;
          rangeEnd = null;
        }
        if (timeRangeChange != null) {
          timeRangeChange(rangeStart, rangeEnd);
        }
      });
    }
  }
}
