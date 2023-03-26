import 'package:calendar/time_dialog.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  DateTime? curDate;
  int? curDay;
  int? startDayInFirstWeek;
  int? curMonth;
  int? curYear;
  int count = 1;
  int? preMonth;
  int? postMonth;
  int? startDayOfPreMonth;
  int startDayOfPostMonth = 1;

  AnimationController? _controller;
  Animation<double>? _animation;

  final List<String> weekdays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  //month, number of day
  Map<int, int> dayOfMonth = {
    1: 31,
    2: 28,
    3: 31,
    4: 30,
    5: 31,
    6: 30,
    7: 31,
    8: 31,
    9: 30,
    10: 31,
    11: 30,
    12: 31
  };

  //month, name of month
  Map<int, String> monthMap = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December'
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _animation =
        CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn);

    curDate = DateTime.now();
    curDay = curDate!.day;
    curMonth = curDate!.month;
    curYear = curDate!.year;
    setup(getPattern());
  }

  String getPattern() {
    String pattern = "";
    if (curMonth!.toString().length == 1) {
      pattern = "$curYear-0$curMonth-01";
    } else {
      pattern = "$curYear-$curMonth-01";
    }
    return pattern;
  }

  void setup(String pattern) {
    DateTime tempDate = DateTime.parse(pattern);
    // startDayInFirstWeek = curDay! % 7;
    startDayInFirstWeek = tempDate.weekday - 1;
    if (isLeapYear(curYear!)) {
      dayOfMonth[2] = 29;
    }

    if (curMonth == 1) {
      preMonth = 12;
      postMonth = curMonth! + 1;
      startDayOfPreMonth = 31 - startDayInFirstWeek!;
    } else if (curMonth == 12) {
      preMonth = curMonth! - 1;
      postMonth = 1;
      startDayOfPreMonth = dayOfMonth[preMonth]! - startDayInFirstWeek!;
    } else {
      preMonth = curMonth! - 1;
      postMonth = curMonth! + 1;
      startDayOfPreMonth = dayOfMonth[preMonth]! - startDayInFirstWeek!;
    }
  }

  bool isLeapYear(int year) {
    return year % 400 == 0 || (year % 4 == 0 && year % 100 != 0);
  }

  List<Widget> getWeekdays() {
    return weekdays.map<Widget>((e) => Text(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: size.width / 2,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async {
                            _controller!.forward();
                            String? pattern = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                return ScaleTransition(
                                  scale: _animation!,
                                  child: TimeDialog(
                                    width: size.width / 2,
                                    height: size.height / 3,
                                    date: DateTime.parse(getPattern()),
                                    curDate: curDate,
                                  ),
                                );
                              },
                            );
                            _controller!.reverse();
                            if (pattern != null) {
                              DateTime tempDate = DateTime.parse(pattern);
                              setState(() {
                                curMonth = tempDate.month;
                                curYear = tempDate.year;
                                startDayOfPostMonth = 1;
                                count = 1;
                                setup(getPattern());
                              });
                            }
                          },
                          child: Text("${monthMap[curMonth]} $curYear"))),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (preMonth == 12) {
                            curYear = curYear! - 1;
                          }
                          curMonth = preMonth;
                          startDayOfPostMonth = 1;
                          count = 1;
                          setup(getPattern());
                        });
                      },
                      icon: const Icon(Icons.arrow_back)),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (curMonth == 12) {
                            curYear = curYear! + 1;
                          }
                          curMonth = postMonth;
                          startDayOfPostMonth = 1;
                          count = 1;
                          setup(getPattern());
                        });
                      },
                      icon: const Icon(Icons.arrow_forward))
                ],
              ),
              GridView.builder(
                shrinkWrap: true,
                itemCount: 7,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1),
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.amber.shade50,
                    child: Align(child: Text(weekdays[index])),
                  );
                },
              ),
              Container(
                color: Colors.amber.shade50,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: 42,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1),
                  itemBuilder: (context, index) {
                    if (index >= startDayInFirstWeek! &&
                        count <= dayOfMonth[curMonth]!) {
                      if (count == curDate!.day &&
                          curMonth == curDate!.month &&
                          curYear == curDate!.year) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.amber.shade900,
                              shape: BoxShape.circle),
                          child: Align(
                              child: Text("${count++}",
                                  style: const TextStyle(color: Colors.white))),
                        );
                      }
                      return Align(child: Text("${count++}"));
                    } else if (index < startDayInFirstWeek!) {
                      startDayOfPreMonth = startDayOfPreMonth! + 1;
                      return Align(
                          child: Text(
                        "$startDayOfPreMonth",
                        style: const TextStyle(color: Colors.grey),
                      ));
                    }
                    return Align(
                        child: Text(
                      "${startDayOfPostMonth++}",
                      style: const TextStyle(color: Colors.grey),
                    ));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
