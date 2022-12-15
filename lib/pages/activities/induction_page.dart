import 'package:buffaloes_farm_management/components/CustomTextFormField.dart';
import 'package:buffaloes_farm_management/components/MessagesDialog.dart';
import 'package:buffaloes_farm_management/components/SlidingTimePicker.dart';
import 'package:buffaloes_farm_management/service/FarmService.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class InductionPage extends StatefulWidget {
  InductionPage({Key? key, required this.buffId}) : super(key: key);

  String buffId;

  @override
  _InductionPageState createState() => _InductionPageState();
}

class _InductionPageState extends State<InductionPage> {
  TextEditingController tfName = TextEditingController();

  TextEditingController tfDateTime = TextEditingController();
  TextEditingController tfReturnDateTime = TextEditingController();

  Color primaryColor = Colors.pink;
  Color backgroundColor = const Color(0xFF050505);
  Color tabColor = ColorHelper.darken(Colors.pink, .1);

  bool isSaving = false, isSaved = false;

  int notify = 0;
  int type = 0;
  int result = 0;

  DateTime? pickedDatetime;
  DateTime? pickedReturnDatetime;

  @override
  void initState() {
    super.initState();

    tfDateTime.text = getCurrentDate();
    tfDateTime.text = getCurrentDate();
  }

  onSubmit() async {
    setState(() {
      isSaving = true;
    });
    if (tfName.text.isNotEmpty) {
      String? result = await FarmService.addInducting(
          buffId: widget.buffId,
          induction: type == 0 ? true : false,
          method: tfName.text,
          date: pickedReturnDatetime ?? DateTime.now());

      if (result != null) {
        if (result == "SUCCESS") {
          isSaved = true;

          if (!mounted) return;
          messageDialog(context, title: "แจ้งเตือน", message: "บันทึกเรียบร้อย",
              function: () {
            //context.read<HomeCubit>().management();
            Navigator.of(context).pop(true);
          });
        } else {
          if (!mounted) return;
          messageDialog(context, title: "แจ้งเตือน", message: result);
        }
      } else {
        if (!mounted) return;
        messageDialog(context,
            title: "แจ้งเตือน", message: "ไม่สามารถเชื่อมต่อได้");
      }
    } else {
      if (tfName.text.isEmpty) {
        messageDialog(context,
            title: "แจ้งเตือน", message: "กรุณากรอกวิธีเหนี่ยวนำ");
      }
    }
    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: backgroundColor,
        systemNavigationBarDividerColor: backgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        //systemNavigationBarContrastEnforced: true,
      ),
      child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            color: backgroundColor,
            child: Center(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Scaffold(
                      backgroundColor: backgroundColor,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0.0,
                        surfaceTintColor: backgroundColor,
                        systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarIconBrightness: Brightness.light,
                          statusBarColor: backgroundColor,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(22),
                          ),
                        ),
                        centerTitle: true,
                        title: Text(
                          "เพิ่มการเหนี่ยวนำ",
                          style: GoogleFonts.itim(
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        ),
                        titleSpacing: 0,
                        leading: IconButton(
                          icon: const Icon(FontAwesomeIcons.xmark,
                              color: Colors.white, size: 24),
                          onPressed: () {
                            if (isSaving == false) {
                              Navigator.of(context).pop(false);
                            }
                          },
                        ),
                        actions: [],
                      ),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerFloat,
                      floatingActionButton: submitButtonEnabled()
                          ? FloatingActionButton.extended(
                              onPressed: () {
                                onSubmit();
                              },
                              heroTag: null,
                              backgroundColor:
                                  ColorHelper.lighten(primaryColor, .1)
                                      .withOpacity(0.6),
                              extendedPadding:
                                  const EdgeInsets.only(left: 74, right: 74),
                              extendedIconLabelSpacing: 12,
                              elevation: 0,
                              //splashColor: Colors.greenAccent.withOpacity(0.4),
                              splashColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14))),
                              label: Text("บันทึก",
                                  style: GoogleFonts.itim(
                                      //color: primaryColor,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              icon: Icon(FontAwesomeIcons.solidFloppyDisk,
                                  color: Colors.white.withOpacity(0.9)),
                            )
                          : null,
                      body: isSaving == true || isSaved == true
                          ? const Center(
                              child: SpinKitThreeBounce(
                              color: Colors.white,
                              size: 50.0,
                            ))
                          : body(context),
                    ))),
          )),
    );
  }

  body(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF171717),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(22),
            bottom: Radius.circular(22),
          ),
        ),
        height: type == 0
            ? 422 : 262,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        //height: 460,
        margin: EdgeInsets.only(
            left: 16, right: 16, bottom: submitButtonEnabled() ? 90 : 16),
        //height: MediaQuery.of(context).size.height,
        child: Form(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 0),
            children: <Widget>[
              const SizedBox(height: 20),
              tabBar(
                initialValue: type,
                children: {
                  0: buildSegment("เหนื่ยวนำ", 0, type),
                  1: buildSegment("ไม่เหนื่ยวนำ", 1, type),
                },
                callback: (value) {
                  setState(() {
                    type = value;
                  });
                },
              ),
              type == 0
                  ? const SizedBox(height: 20) : Container(),
              type == 0
                  ? textField(
                      hint: "วิธีที่ใช้เหนี่ยวนำ",
                      controller: tfName,
                      required: true)
                  : Container(),
              type == 0 ? const SizedBox(height: 6) : Container(),
              type == 0 ? const SizedBox(height: 8) : Container(),
              type == 0
                  ? textHeader(title: "วัน/เดือน/ปี ที่เหนี่ยวนำ")
                  : Container(),
              type == 0
                  ? textField(
                      enabled: true,
                      hint: "",
                      //hint: "วัน/เดือน/ปี",
                      readOnly: true,
                      controller: tfDateTime,
                      onTap: () async {
                        DateTime? selectdDateTime = await SlidingTimePicker(
                            context,
                            dateTime: pickedDatetime);
                        if (selectdDateTime != null) {
                          setState(() {
                            pickedReturnDatetime = selectdDateTime;
                            pickedDatetime = selectdDateTime;
                            tfDateTime.text = dateTimeToString(selectdDateTime);
                          });
                          //x = "${DateFormat.Hm().format(selectdDateTime)}:00";
                        }
                      },
                    )
                  : Container(),
               const SizedBox(height: 14),
              divider(),
              const SizedBox(height: 6),
              textHeader(title: "วัน/เดือน/ปี ที่แสดงการกลับสัด"),
              textField(
                enabled: true,
                hint: "",
                value: getReturnDate(days: 21),
                //hint: "วัน/เดือน/ปี",
                readOnly: true,
                //controller: tfReturnDateTime,
              ),
              const SizedBox(height: 16),
              tabBar(
                initialValue: notify,
                children: {
                  0: buildSegment("แจ้งเตือน", 0, notify),
                  1: buildSegment("ไม่แจ้งเตือน", 1, notify),
                },
                callback: (value) {
                  setState(() {
                    notify = value;
                  });
                },
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ));
  }

  Widget divider() {
    return Container(
      width: double.infinity,
      height: 1,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.transparent,
              ColorHelper.lighten(primaryColor).withOpacity(0.2),
              ColorHelper.lighten(primaryColor).withOpacity(0.5),
              ColorHelper.lighten(primaryColor).withOpacity(0.2),
              Colors.transparent,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.0, 0.15, 0.5, 0.85, 1.0],
            tileMode: TileMode.repeated),
      ),
    );
  }

  Widget textHeader({required String title}) {
    return Container(
        height: 20,
        margin: const EdgeInsets.only(
          top: 0,
          bottom: 6,
          left: 6,
        ),
        child: Text(title,
            style: GoogleFonts.itim(
                fontSize: 16, color: const Color(0xFF8F8F8F))));
  }

  Widget textField(
      {TextEditingController? controller,
      String? value,
      bool readOnly = false,
      VoidCallback? onTap,
      bool enabled = true,
      bool required = false,
      TextAlign textAlign = TextAlign.start,
      required String hint}) {
    return CustomTextFormField.create(
        hint: hint,
        readOnly: readOnly,
        textInputAction: TextInputAction.next,
        controller: controller,
        enabled: enabled,
        onTap: onTap,
        required: required,
        value: value,
        darkMode: true,
        isTransparentBorder: true,
        onEditingComplete: () {
          FocusScope.of(context).nextFocus();
          setState(() {});
        },
        enabledColor: Colors.white.withOpacity(0.05),
        disabledColor: Colors.black.withOpacity(0.3),
        textAlign: textAlign);
  }

  Widget tabBar(
      {required Map<int, Widget> children,
      required int initialValue,
      required Function(int) callback}) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 0, right: 0),
      padding: const EdgeInsets.all(4),
      child: CustomSlidingSegmentedControl<int>(
        decoration: BoxDecoration(
          color: ColorHelper.lighten(backgroundColor, .14),
          borderRadius: BorderRadius.circular(10),
        ),
        //thumbColor: Colors.white,
        thumbDecoration: BoxDecoration(
          color: ColorHelper.lighten(primaryColor, .0).withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.0),
              blurRadius: 1.0,
              spreadRadius: 1.0,
              offset: const Offset(
                0.0,
                2.0,
              ),
            ),
          ],
        ),
        innerPadding: const EdgeInsets.all(0),
        initialValue: initialValue,
        children: children,
        onValueChanged: callback,
      ),
    );
  }

  Widget buildSegment(String text, int number, int selectedValue) {
    return Container(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 4, bottom: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: selectedValue == number ? 18 : 16,
            color: selectedValue == number
                ? Colors.white
                : Colors.white.withOpacity(0.4)),
      ),
    );
  }

  bool submitButtonEnabled() {
    if (isSaving == true) {
      return false;
    } else {
      return true;
    }
  }

  String getCurrentDate({DateTime? tempDate}) {
    tempDate ??= DateTime.now();
    tempDate = tempDate.add(const Duration(days: 21));
    pickedDatetime = tempDate;

    return dateTimeToString(tempDate);
  }

  String getReturnDate({int days = 21}) {
    DateTime tempDate = pickedDatetime!.add(Duration(days: days));
    pickedReturnDatetime = tempDate;

    return "${tempDate.day} ${getMonthName(tempDate.month - 1)} ${tempDate.year + 543}";
  }

  String dateTimeToString(DateTime datetime) {
    return "${datetime.day} ${getMonthName(datetime.month - 1)} ${datetime.year + 543}";
  }

  String getMonthName(int month) {
    List<String> MONTHS = const [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม'
    ];
    return MONTHS[month];
  }

  OutlineInputBorder textFieldInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Colors.transparent));
}
