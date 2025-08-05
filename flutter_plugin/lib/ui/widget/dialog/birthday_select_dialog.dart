// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';

typedef ValueChangeCallback<Dynamic> = void Function(Dynamic value);

/// 内容，取消按钮，登录按钮
class BirthdaySelectDialog extends StatefulWidget {
  String cancelContent;
  String confirmContent; //current Time
  DateTime defaultDate;
  DateTime? minimumDate = DateTime(1970, 1, 1, 0, 0, 0);
  DateTime? maximumDate = DateTime.now();
  VoidCallback? cancelCallback;
  ValueChangeCallback? confirmCallback;
  BuildContext context;

  BirthdaySelectDialog({
    super.key,
    required this.context,
    required this.cancelContent,
    required this.confirmContent,
    required this.confirmCallback,
    required this.defaultDate,
    this.minimumDate,
    this.maximumDate,
    this.cancelCallback,
  });

  @override
  BirthdaySelectDialogState createState() => BirthdaySelectDialogState();
}

class BirthdaySelectDialogState extends State<BirthdaySelectDialog> {
  late FixedExtentScrollController _yearController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;

  int get defaultSelectedYearIndex => !_years.contains(widget.defaultDate.year)
      ? 0
      : _years.indexOf(widget.defaultDate.year);

  int get defaultSelectedMonthIndex =>
      !_months.contains(widget.defaultDate.month)
          ? 0
          : _months.indexOf(widget.defaultDate.month);

  int get defaultSelectedDayIndex => !_days.contains(widget.defaultDate.day)
      ? 0
      : _days.indexOf(widget.defaultDate.day);

  late List<int> _years = [];
  late List<int> _months = [];
  late List<int> _days = [];

  /// 临时变量
  late int _selectedYear = 0;
  late int _selectedMoth = 0;
  late int _selectedDay = 0;

  late int _selectedYearIndex = defaultSelectedYearIndex;
  late int _selectedMonthIndex = defaultSelectedMonthIndex;
  late int _selectedDayIndex = defaultSelectedDayIndex;

  @override
  void initState() {
    super.initState();

    // 初始化默认选中的 年/月/日 的数组
    _years = getYearArray(widget.minimumDate!, widget.maximumDate!);
    _months = getMothArray(endDate: widget.maximumDate!);
    _days = getDaysArray(
        widget.defaultDate.year, widget.defaultDate.month, widget.maximumDate);

    // 设置默认选中的controller 的初始值
    _yearController =
        FixedExtentScrollController(initialItem: defaultSelectedYearIndex);
    _monthController =
        FixedExtentScrollController(initialItem: defaultSelectedMonthIndex);
    _dayController =
        FixedExtentScrollController(initialItem: defaultSelectedDayIndex);

    // 设置默认选中的 年/月/日
    _selectedYear = _years[defaultSelectedYearIndex];
    _selectedMoth = _months[defaultSelectedMonthIndex];
    _selectedDay = _days[defaultSelectedDayIndex];
  }

  void dismiss() {
    Navigator.of(widget.context).pop();
  }

  void _comfirmFunc() {
    if (widget.confirmCallback != null) {
      DateTime selectDataTime =
          DateTime(_selectedYear, _selectedMoth, _selectedDay);
      widget.confirmCallback?.call(selectDataTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (_, style, resource) {
      List<Widget> temArray = [];
      temArray.add(Expanded(
          flex: 4,
          child: Container(
              // color: Colors.red,
              child: VerticalListView(
                  dataSource: _years,
                  selectIndex: _selectedYearIndex,
                  controller: _yearController,
                  styleModel: style,
                  selectChanged: (index) {
                    _yearChanged(_selectedYear, _years[index]);
                    _selectedYearIndex = index;
                    _selectedYear = _years[index];
                  }))));
      temArray.add(Text('-',
          style: TextStyle(
              fontSize: style.head,
              fontWeight: FontWeight.bold,
              color: style.textMainBlack)));
      temArray.add(Expanded(
          flex: 3,
          child: Container(
              // color: Colors.yellow,
              child: VerticalListView(
                  styleModel: style,
                  dataSource: _months,
                  selectIndex: _selectedMonthIndex,
                  controller: _monthController,
                  selectChanged: (index) {
                    _monthChanged(_selectedMoth, _months[index]);
                    _selectedMonthIndex = index;
                    _selectedMoth = _months[index];
                  }))));
      temArray.add(Text('-',
          style: TextStyle(
              fontSize: style.head,
              fontWeight: FontWeight.bold,
              color: style.textMainBlack)));
      temArray.add(Expanded(
          flex: 3,
          child: Container(
              // color: Colors.blue,
              child: VerticalListView(
                  styleModel: style,
                  dataSource: _days,
                  selectIndex: _selectedDayIndex,
                  controller: _dayController,
                  selectChanged: (index) {
                    _dayChanged(_selectedDay, _days[index]);
                    _selectedDayIndex = index;
                    _selectedDay = _days[index];
                  }))));

      return Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(style.circular20),
                color: style.bgWhite),
            margin: const EdgeInsets.symmetric(horizontal: 35),
            padding:
                const EdgeInsets.only(top: 28, left: 20, right: 20, bottom: 20)
                    .withRTL(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: 220,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                                color: style.bgGray,
                                borderRadius:
                                    BorderRadius.circular(style.cellBorder)),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: temArray,
                        )
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 24).withRTL(context),
                  child: Row(
                    children: [
                      Expanded(
                        child: DMButton(
                            height: 48,
                            borderRadius: style.buttonBorder,
                            width: double.infinity,
                            textColor: style.lightDartBlack,
                            backgroundGradient: style.cancelBtnGradient,
                            text: widget.cancelContent,
                            onClickCallback: (_) {
                              dismiss();
                              widget.cancelCallback?.call();
                            }),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: DMButton(
                            height: 48,
                            borderRadius: style.buttonBorder,
                            textColor: style.enableBtnTextColor,
                            backgroundGradient: style.confirmBtnGradient,
                            text: widget.confirmContent,
                            width: double.infinity,
                            onClickCallback: (_) {
                              _comfirmFunc();
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _yearChanged(int oldYear, int newYear) {
    var dateNow = DateTime.now();
    List<int> newMoths =
        getMothArray(endDate: dateNow.year == newYear ? dateNow : null);
    if (_months.length != newMoths.length) {
      setState(() {
        setState(() {
          _months = newMoths;
        });
      });
    }
    if (_selectedMonthIndex > (newMoths.length - 1)) {
      _selectedMonthIndex = (newMoths.length - 1);
      _selectedMoth = newMoths[_selectedMonthIndex];
      _monthController.animateToItem(_selectedMonthIndex,
          duration: const Duration(microseconds: 10), curve: Curves.ease);
    }
    _setDaysByYearAndMonth(newYear, _selectedMoth);
  }

  void _monthChanged(int oldMonth, int newMonth) {
    _setDaysByYearAndMonth(_selectedYear, newMonth);
    var newDays = _days;
    if (_selectedDayIndex > (newDays.length - 1)) {
      _selectedDayIndex = (newDays.length - 1);
      _selectedDay = newDays[_selectedDayIndex];
      _dayController.animateToItem(_selectedDayIndex,
          duration: const Duration(microseconds: 10), curve: Curves.ease);
    }
  }

  void _dayChanged(int oldDay, int newDay) {}

  void _setDaysByYearAndMonth(int year, int month) {
    var dateNow = DateTime.now();
    var currentEndDay = year == dateNow.year && month == dateNow.month;
    List<int> newDays =
        getDaysArray(year, month, currentEndDay ? dateNow : null);
    if (_days.length != newDays.length) {
      setState(() {
        _days = newDays;
      });
    }
  }
}

/// 扩展方法
extension BirthdaySelectDialogFunc on BirthdaySelectDialogState {
  List<int> getYearArray(DateTime start, DateTime end) {
    List<int> array = [];
    for (int i = start.year; i <= end.year; i++) {
      array.add(i);
    }
    return array;
  }

  List<int> getMothArray({DateTime? endDate}) {
    List<int> array = [];
    for (int i = 1; i <= (endDate != null ? endDate.month : 12); i++) {
      array.add(i);
    }
    return array;
  }

  List<int> getDaysArray(int year, int moth, DateTime? time) {
    int days = 0;
    if (time != null) {
      days = _daysInMonth(time.year, time.month);
      var dateNow = DateTime.now();
      if (dateNow.year == time.year && dateNow.month == time.month) {
        days = time.day;
      }
    } else {
      days = _daysInMonth(year, moth);
    }
    List<int> array = [];
    for (int i = 1; i <= days; i++) {
      array.add(i);
    }
    return array;
  }

  int _daysInMonth(final int year, final int monthNum) {
    if (monthNum > 12) {
      return 0;
    }
    List<int> monthLength = List.filled(12, 0);
    monthLength[0] = 31;
    monthLength[2] = 31;
    monthLength[3] = 30;
    monthLength[4] = 31;
    monthLength[5] = 30;
    monthLength[6] = 31;
    monthLength[7] = 31;
    monthLength[8] = 30;
    monthLength[9] = 31;
    monthLength[10] = 30;
    monthLength[11] = 31;

    if (leapYear(year) == true) {
      monthLength[1] = 29;
    } else {
      monthLength[1] = 28;
    }
    return monthLength[monthNum - 1];
  }

  bool leapYear(int year) {
    bool leapYear = false;
    bool leap = ((year % 100 == 0) && (year % 400 != 0));
    if (leap == true) {
      leapYear = false;
    } else if (year % 4 == 0) {
      leapYear = true;
    }

    return leapYear;
  }
}

class VerticalListView extends StatefulWidget {
  double? height;
  List<dynamic> dataSource;
  int? selectIndex;
  ValueChanged<int> selectChanged;
  Widget? rightWidget;
  FixedExtentScrollController? controller;
  final StyleModel styleModel;

  VerticalListView({
    super.key,
    this.height,
    required this.dataSource,
    required this.selectIndex,
    required this.selectChanged,
    required this.controller,
    required this.styleModel,
  });

  @override
  State<VerticalListView> createState() => _VerticalListViewState();
}

class _VerticalListViewState extends State<VerticalListView> {
  @override
  Widget build(BuildContext context) {
    if ((widget.selectIndex ?? 0) > (widget.dataSource.length - 1)) {
      widget.selectChanged(widget.dataSource.length - 1);
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                // padding:const EdgeInsets.all(5),
                height: 220,
                child: ListWheelScrollView.useDelegate(
                  physics: const FixedExtentScrollPhysics(),
                  controller: widget.controller,
                  magnification: 1.5,
                  overAndUnderCenterOpacity: 0.4,
                  onSelectedItemChanged: (index) {
                    widget.selectChanged(index);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        return Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.dataSource[index]}',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: widget.styleModel.textMainBlack),
                          ),
                        );
                      },
                      childCount: widget.dataSource.length),
                  itemExtent: 34.0,
                ),
              ))
        ]);
  }
}
