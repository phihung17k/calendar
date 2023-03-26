import 'package:flutter/material.dart';

class TimeDialog extends StatefulWidget {
  final double? width;
  final double? height;
  final DateTime? date;
  final DateTime? curDate;

  const TimeDialog(
      {super.key, this.width, this.height, this.date, this.curDate});

  @override
  State<TimeDialog> createState() => _TimeDialogState();
}

class _TimeDialogState extends State<TimeDialog> {
  int? selectedYear;

  //month, name of month
  Map<int, String> monthAbbreMap = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec'
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedYear = widget.date!.year;
  }

  String getPattern(DateTime date, int month) {
    String pattern = "";
    if (month.toString().length == 1) {
      pattern = "$selectedYear-0$month-01";
    } else {
      pattern = "$selectedYear-$month-01";
    }
    return pattern;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Choose time"),
      content: Container(
        width: widget.width!,
        height: widget.height!,
        child: Column(children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: InkWell(onTap: () {}, child: Text("$selectedYear"))),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectedYear = selectedYear! - 1;
                    });
                  },
                  icon: const Icon(Icons.arrow_back)),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      selectedYear = selectedYear! + 1;
                    });
                  },
                  icon: const Icon(Icons.arrow_forward))
            ],
          ),
          Container(
            color: Colors.amber.shade50,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, crossAxisSpacing: 1, mainAxisSpacing: 1),
              itemBuilder: (context, index) {
                DateTime date = widget.date!;
                int tempMonth = index + 1;
                if (tempMonth == widget.curDate!.month &&
                    selectedYear == widget.curDate!.year) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop(getPattern(date, tempMonth));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.amber.shade900, shape: BoxShape.circle),
                      child: Align(
                          child: Text("${monthAbbreMap[index + 1]}",
                              style: const TextStyle(color: Colors.white))),
                    ),
                  );
                }
                if (tempMonth == date.month && selectedYear == date.year) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop(getPattern(date, tempMonth));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.amber.shade900)),
                      child: Align(
                          child: Text("${monthAbbreMap[index + 1]}",
                              style: const TextStyle(color: Colors.white))),
                    ),
                  );
                }

                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop(getPattern(date, tempMonth));
                  },
                  child: Align(child: Text("${monthAbbreMap[index + 1]}")),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
