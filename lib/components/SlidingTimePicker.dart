import 'package:buffaloes_farm_management/constants/ColorConstants.dart';
import 'package:buffaloes_farm_management/constants/StyleConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<DateTime?> SlidingTimePicker(BuildContext context,{DateTime? dateTime}) async {
  return await showDialog<DateTime>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return mSlidingTimePicker(dateTime: dateTime,);
      });
}

class mSlidingTimePicker extends StatefulWidget {
  mSlidingTimePicker({Key? key,this.dateTime}) : super(key: key);

  DateTime? dateTime;

  @override
  _mSlidingTimePickerState createState() => _mSlidingTimePickerState();
}

class _mSlidingTimePickerState extends State<mSlidingTimePicker> {

  late DateTime initialDateTime;
  late DateTime value;

  @override
  void initState() {
    super.initState();
    value = widget.dateTime ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      height: 280,
      margin: const EdgeInsets.all(30),
      //constraints: maxHeightContain,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          )),
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
            child: const Text(
              'เลือกวันเดือนปี',
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: kTextBlack,
                  fontFamily: 'Itim'),
            ),
          ),
          Container(
            height: 162,

            //width: MediaQuery.of(context).size.width * 1,
            //margin: EdgeInsets.only(top: 0.03.sw, bottom: 0.05.sw),

            child: CupertinoTheme(
                data: const CupertinoThemeData(
                  brightness:  Brightness.light,
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(color: bgButtonColor,fontFamily: 'Itim',fontSize: 20),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  use24hFormat: true,
                  minimumYear: DateTime.now().year - 30,
                  maximumYear: DateTime.now().year,
                  dateOrder: DatePickerDateOrder.dmy,
                  onDateTimeChanged: (DateTime value) {
                    print(value);
                    setState(() {
                      this.value = value;
                    });
                  },
                  initialDateTime: value,
                )),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 1,
            height: 50,
            margin: EdgeInsets.only(top: 8, left: 20, right: 20),
            child: OutlinedButton(
              style: navyButtonStyle,
              onPressed: () {
                print("value ${value}");
                Navigator.pop(context, value);
              },
              child: Text(
                'ยืนยัน',
                style: whiteTextButton,
              ),
            ),
          ),
        ],
      ),
    ));
  }

}
