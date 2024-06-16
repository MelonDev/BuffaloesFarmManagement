import 'package:buffaloes_farm_management/components/CustomTextFormField.dart';
import 'package:buffaloes_farm_management/components/MessagesDialog.dart';
import 'package:buffaloes_farm_management/components/SlidingTimePicker.dart';
import 'package:buffaloes_farm_management/constants/ColorConstants.dart';
import 'package:buffaloes_farm_management/constants/StyleConstants.dart';
import 'package:buffaloes_farm_management/service/FarmService.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DiseaseTreatmentPage extends StatefulWidget {
  DiseaseTreatmentPage({Key? key,required this.buffId}) : super(key: key);
  String buffId;

  @override
  _DiseaseTreatmentPageState createState() => _DiseaseTreatmentPageState();
}

class _DiseaseTreatmentPageState extends State<DiseaseTreatmentPage> {

  TextEditingController tfName = TextEditingController();
  TextEditingController tfSymptom = TextEditingController();
  TextEditingController tfDisease = TextEditingController();
  TextEditingController tfGroupSymptom = TextEditingController();
  TextEditingController tfHealer = TextEditingController();

  String? groupSymptomValue, diseaseValue,healerValue;

  DateTime? symptomDatetime, treatDatetime;

  Color primaryColor = Colors.green;
  Color backgroundColor = const Color(0xFF050505);
  Color tabColor = ColorHelper.darken(Colors.green,.1);

  bool isSaving = false, isSaved = false;
  bool enabledSpecify = false;


  int status = 0;

  onSubmit() async {
    messageDialog(context, title: "แจ้งเตือน", message: "บันทึกเรียบร้อย",
        function: () {
          Navigator.of(context).pop(true);
        });
    setState(() {
      isSaving = true;
    });
    // if (tfName.text.isNotEmpty && tfSymptom.text.isNotEmpty && tfDrugs.text.isNotEmpty) {
    //   String? response = await FarmService.addDiseaseTreatment(
    //       buffId: widget.buffId,
    //       diseaseName: tfName.text,
    //       symptom: tfSymptom.text,
    //       drug: tfDrugs.text,
    //       healedStatus: status == 0,
    //       duration: status == 1 ? int.tryParse(tfDuration.text) ?? 30 : null,
    //       date: DateTime.now());
    //
    //
    //   if (response != null) {
    //     if (response == "SUCCESS") {
    //       isSaved = true;
    //
    //       if (!mounted) return;
    //       messageDialog(context, title: "แจ้งเตือน", message: "บันทึกเรียบร้อย",
    //           function: () {
    //             //context.read<HomeCubit>().management();
    //             Navigator.of(context).pop(true);
    //           });
    //     } else {
    //       if (!mounted) return;
    //       messageDialog(context, title: "แจ้งเตือน", message: response);
    //     }
    //   } else {
    //     if (!mounted) return;
    //     messageDialog(context,
    //         title: "แจ้งเตือน", message: "ไม่สามารถเชื่อมต่อได้");
    //   }
    // } else {
    //   if (tfName.text.isEmpty) {
    //     messageDialog(context,
    //         title: "แจ้งเตือน", message: "กรุณากรอกขื่อโรค");
    //   }else if (tfSymptom.text.isEmpty) {
    //     messageDialog(context,
    //         title: "แจ้งเตือน", message: "กรุณากรอกอาการของโรค");
    //   } else if (tfDrugs.text.isEmpty) {
    //     messageDialog(context,
    //         title: "แจ้งเตือน", message: "กรุณากรอกยาที่ใช้");
    //   }
    // }
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
    constraints: const BoxConstraints(maxWidth: 500),child: Scaffold(
      backgroundColor:backgroundColor,
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
          "เพิ่มการรักษาโรค",
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
        actions: [

        ],
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
      floatingActionButton: submitButtonEnabled()
          ? FloatingActionButton.extended(
        onPressed: () {
          onSubmit();
        },
        heroTag: null,
        backgroundColor: ColorHelper.lighten(primaryColor,.1).withOpacity(0.6),
        extendedPadding: const EdgeInsets.only(left: 74, right: 74),
        extendedIconLabelSpacing: 12,
        elevation: 0,
        //splashColor: Colors.greenAccent.withOpacity(0.4),
        splashColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
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
    ))))
      ),
    );
  }

  body(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color:  Color(0xFF171717),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(22),
            bottom: Radius.circular(22),
          ),
        ),
        //height: enabledSpecify ? 504 :418 ,
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
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 0),
            children: <Widget>[
              const SizedBox(height: 20),

              textHeader(title: "อาการ"),
              const SizedBox(height: 8),
              textField(
                hint: "วัน/เดือน/ปี ที่สังเกตเห็นอาการ",
                required: false,
                readOnly: true,
                value: symptomDatetime != null
                    ? DateFormat('d MMMM y', 'th').format(symptomDatetime!)
                    : null,
                onTap: () async {
                  DateTime? selectdDateTime = await SlidingTimePicker(context,
                      dateTime: symptomDatetime);
                  if (selectdDateTime != null) {
                    setState(() {
                      symptomDatetime = selectdDateTime;
                    });
                    //x = "${DateFormat.Hm().format(selectdDateTime)}:00";
                  }
                },
              ),
              const SizedBox(height: 12),
              textField(hint: "ลักษณะอาการเบื้องต้น", controller: tfName,required: false),
              const SizedBox(height: 12),
              textField(
                hint: "กลุ่มอาการ",
                value: groupSymptomValue,
                readOnly: true,
                onTap: () {
                  groupSymptomBottomDialog();
                },
              ),
              if (groupSymptomValue == "อื่น ๆ") const SizedBox(height: 8),
              if (groupSymptomValue == "อื่น ๆ")
                textField(
                  hint: "ระบุ",
                  controller: tfSymptom,
                ),

              const SizedBox(height: 12),
              textField(
                hint: "โรค",
                value: diseaseValue,
                readOnly: true,
                onTap: () {
                  diseaseBottomDialog();
                },
              ),
              if (diseaseValue == "อื่น ๆ") const SizedBox(height: 8),
              if (diseaseValue == "อื่น ๆ")
                textField(
                    hint: "ระบุ",
                    controller: tfDisease),
              const SizedBox(height: 22),


              textHeader(title: "การรักษา"),
              const SizedBox(height: 8),
              textField(
                hint: "วัน/เดือน/ปี ที่รักษา",
                required: false,
                readOnly: true,
                value: treatDatetime != null
                    ? DateFormat('d MMMM y', 'th').format(treatDatetime!)
                    : null,
                onTap: () async {
                  DateTime? selectdDateTime = await SlidingTimePicker(context,
                      dateTime: treatDatetime);
                  if (selectdDateTime != null) {
                    setState(() {
                      treatDatetime = selectdDateTime;
                    });
                    //x = "${DateFormat.Hm().format(selectdDateTime)}:00";
                  }
                },
              ),

              const SizedBox(height: 12),
              textField(
                hint: "ผู้รักษา",
                value: healerValue,
                readOnly: true,
                onTap: () {
                  healingBottomDialog();
                },
              ),
              if (healerValue == "อื่น ๆ") const SizedBox(height: 8),
              if (healerValue == "อื่น ๆ")
                textField(
                    hint: "ระบุ",
                    controller: tfHealer),
              const SizedBox(height: 12),

              textField(hint: "วิธีการรักษา", controller: tfName,required: false),
              const SizedBox(height: 22),

              textField(hint: "ยาที่ใช้", controller: tfSymptom,required: false),
              const SizedBox(height: 22),


              textHeader(title: "ผลการรักษา"),
              const SizedBox(height: 8),
              textField(
                hint: "วัน/เดือน/ปี ที่ตรวจอีกครั้ง",
                required: false,
                readOnly: true,
                value: treatDatetime != null
                    ? DateFormat('d MMMM y', 'th').format(treatDatetime!)
                    : null,
                onTap: () async {
                  DateTime? selectdDateTime = await SlidingTimePicker(context,
                      dateTime: treatDatetime);
                  if (selectdDateTime != null) {
                    setState(() {
                      treatDatetime = selectdDateTime;
                    });
                    //x = "${DateFormat.Hm().format(selectdDateTime)}:00";
                  }
                },
              ),
              const SizedBox(height: 12),

              //textField(hint: "ยาที่ใช้",helperText: 'หากใช้ยาหลายตัว กรุณาใช้เครื่องหมาย "จุลภาค"(,) แบ่งยาแต่ละตัว', controller: tfDrugs,required: true),
              textHeader(title: "ผลการรักษา"),
              tabBar(),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ));
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
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
        String? helperText,
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
        keyboardType: keyboardType,
        isTransparentBorder: true,
        darkMode: true,
        inputFormatters: inputFormatters ?? [],
        onEditingComplete: () {
          FocusScope.of(context).nextFocus();
          setState(() {});
        },
        enabledColor: Colors.white.withOpacity(0.05),
        disabledColor: Colors.black.withOpacity(0.3),
        helper: helperText,
        textAlign: textAlign);
  }

  groupSymptomBottomDialog() {
    List<String> buffSourceList = [
      "อาการทางระบบหมันเวียนโลหิต",
      "อาการทางระบบทางเดินหายใจ",
      "อาการที่ระบบสืบพันธุ์และทางเดินปัสสาวะ",
      "อาการทางเดินอาหาร",
      "อาการที่เกี่ยวกับระบบประสาท",
      "อาการทางผิวหนัง",

      "อื่น ๆ",
    ];

    List<Widget> buffSource = [];
    buffSourceList.forEach((value) {
      buffSource.add(const SizedBox(height: 8));
      buffSource.add(button(
        value,
        icon: FontAwesomeIcons.circle,
        color: const Color(0xFF010101),
        onTap: () async {
          setState(() {
            groupSymptomValue = value;
          });
          // await Navigator.of(context).push(
          //     NavigatorHelper.slide(const DiseaseTreatmentPage()));
        },
      ));
    });

    bottomDialog(
      context,
      backgroundColor: Colors.white,
      ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8, left: 6),
            child: Text(
              "เลือกกลุ่มอาการ",
              style: GoogleFonts.itim(
                  color: ColorHelper.lighten(const Color(0xFF0C0C0C), .2)
                      .withOpacity(0.86),
                  fontSize: 28),
            ),
          ),
        ]
          ..addAll(buffSource)
          ..addAll([
            const SizedBox(height: 26),
          ]),
      ),
    );
  }

  diseaseBottomDialog() {
    List<String> buffSourceList = [
      "ปากและเท้าเปื่อย",
      "แท้งติดต่อ",
      "คอบวม",
      "วัณโรค",
      "แอนแทรกซ์",
      "อื่น ๆ",
    ];

    List<Widget> buffSource = [];
    buffSourceList.forEach((value) {
      buffSource.add(const SizedBox(height: 8));
      buffSource.add(button(
        value,
        icon: FontAwesomeIcons.circle,
        color: const Color(0xFF010101),
        onTap: () async {
          setState(() {
            diseaseValue = value;
          });
          // await Navigator.of(context).push(
          //     NavigatorHelper.slide(const DiseaseTreatmentPage()));
        },
      ));
    });

    bottomDialog(
      context,
      backgroundColor: Colors.white,
      ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8, left: 6),
            child: Text(
              "เลือกโรค",
              style: GoogleFonts.itim(
                  color: ColorHelper.lighten(const Color(0xFF0C0C0C), .2)
                      .withOpacity(0.86),
                  fontSize: 28),
            ),
          ),
        ]
          ..addAll(buffSource)
          ..addAll([
            const SizedBox(height: 26),
          ]),
      ),
    );
  }

  healingBottomDialog() {
    List<String> buffSourceList = [
      "สัตวแพทย์",
      "รักษาเอง",
      "เจ้าหน้าที่กรมปศุสัตว์",
      "อื่น ๆ",
    ];

    List<Widget> buffSource = [];
    buffSourceList.forEach((value) {
      buffSource.add(const SizedBox(height: 8));
      buffSource.add(button(
        value,
        icon: FontAwesomeIcons.circle,
        color: const Color(0xFF010101),
        onTap: () async {
          setState(() {
            diseaseValue = value;
          });
          // await Navigator.of(context).push(
          //     NavigatorHelper.slide(const DiseaseTreatmentPage()));
        },
      ));
    });

    bottomDialog(
      context,
      backgroundColor: Colors.white,
      ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8, left: 6),
            child: Text(
              "เลือกโรค",
              style: GoogleFonts.itim(
                  color: ColorHelper.lighten(const Color(0xFF0C0C0C), .2)
                      .withOpacity(0.86),
                  fontSize: 28),
            ),
          ),
        ]
          ..addAll(buffSource)
          ..addAll([
            const SizedBox(height: 26),
          ]),
      ),
    );
  }


  Widget tabBar() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 0, right: 0),
      padding: const EdgeInsets.all(4),
      child: CustomSlidingSegmentedControl<int>(
        decoration: BoxDecoration(
          color: ColorHelper.lighten(backgroundColor,.14),
          borderRadius: BorderRadius.circular(10),
        ),
        //thumbColor: Colors.white,
        thumbDecoration: BoxDecoration(
          color: ColorHelper.lighten(primaryColor,.0).withOpacity(0.7),
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
        initialValue: status,
        children: {
          0: buildSegment("หาย", 0),
          1: buildSegment("ไม่หาย", 1),
        },
        onValueChanged: (value) {
          setState(() {
            enabledSpecify = value == 1;
            status = value;
          });
        },
      ),
    );
  }

  Widget buildSegment(String text, int number) {
    return Container(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 4, bottom: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: status == number ? 18 : 16,
            color: status == number
                ? Colors.white
                : Colors.white.withOpacity(0.4)),
      ),
    );
  }

  Widget button(String title, {Function? onTap, IconData? icon, Color? color}) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 48
      ),
        //height: 48,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onTap?.call();
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
                ColorHelper.lighten(color ?? primaryColor, .4)
                    .withOpacity(0.1)),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(
                ColorHelper.lighten(color ?? primaryColor, .2)
                    .withOpacity(0.1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(width: 0),
                  Icon(
                    icon ?? FontAwesomeIcons.ellipsis,
                    color: ColorHelper.lighten(color ?? primaryColor, .4)
                        .withOpacity(0.8),
                    size: 18,
                  ),
                  Container(width: 16),
                  Expanded(child: SizedBox(
                    child: Text(
                      title,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 20,
                          color: ColorHelper.lighten(color ?? primaryColor, .4)
                              .withOpacity(0.8)),
                    ),
                  ))
                ],
              )),
        ));
  }


  bool submitButtonEnabled() {
    if (isSaving == true) {
      return false;
    } else {
      return true;
    }
  }

  OutlineInputBorder textFieldInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Colors.transparent));
}
