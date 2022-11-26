import 'package:buffaloes_farm_management/components/CustomTextFormField.dart';
import 'package:buffaloes_farm_management/components/MessagesDialog.dart';
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

class VaccineInjectionPage extends StatefulWidget {
  VaccineInjectionPage({Key? key, required this.buffId}) : super(key: key);

  String buffId;

  @override
  _VaccineInjectionPageState createState() => _VaccineInjectionPageState();
}

class _VaccineInjectionPageState extends State<VaccineInjectionPage> {
  TextEditingController tfName = TextEditingController();
  TextEditingController tfSpecifyName = TextEditingController();
  TextEditingController tfSpecifyDuration = TextEditingController();

  List<VaccineMockModel> vaccineList = [
    VaccineMockModel(key: "Foot-mouth Disease", name: "ปากเท้าเปื่อย"),
    VaccineMockModel(key: "Swollen Neck Disease", name: "คอบวม"),
    VaccineMockModel(key: "Anthrax Disease", name: "แอนแทรกซ์"),
    VaccineMockModel(key: "Blackleg Disease", name: "แบลคเลก (ไข้ขา)"),
    VaccineMockModel(key: "Brucellosis Disease", name: "แท้งติดต่อ"),
    VaccineMockModel(
        key: "Other", name: "อื่น ๆ", icon: FontAwesomeIcons.ellipsis),
  ];

  bool enabledSpecify = false;
  VaccineMockModel? vaccine;

  Color primaryColor = Colors.blue;
  Color backgroundColor = const Color(0xFF050505);
  Color tabColor = ColorHelper.darken(Colors.blue, .1);

  bool isSaving = false, isSaved = false;

  int notify = 0;

  onSubmit() async {
    setState(() {
      isSaving = true;
    });
    if (vaccine != null) {
      String? response;
      bool initial = false;

      if (vaccine!.key != "Other") {
        initial = true;
        response = await FarmService.addVaccineInjection(
            buffId: widget.buffId,
            vaccine_name: vaccine!.key,
            date: DateTime.now());
      } else {
        if (tfSpecifyName.text.isEmpty) {
          messageDialog(
            context,
            title: "แจ้งเตือน",
            message: "กรุณากรอกชื่อวัคซีน",
          );
        } else {
          initial = true;
          response = await FarmService.addVaccineInjection(
              buffId: widget.buffId,
              vaccine_name: vaccine!.key,
              otherVaccineName: tfSpecifyName.text,
              otherVaccineDuration: int.tryParse(tfSpecifyDuration.text) ?? 0,
              date: DateTime.now());
        }
      }

      if (initial == true) {
        if (response != null) {
          if (response == "SUCCESS") {
            isSaved = true;

            if (!mounted) return;
            messageDialog(context,
                title: "แจ้งเตือน", message: "บันทึกเรียบร้อย", function: () {
              //context.read<HomeCubit>().management();
              Navigator.of(context).pop(true);
            });
          } else {
            if (!mounted) return;
            messageDialog(context, title: "แจ้งเตือน", message: response);
          }
        } else {
          if (!mounted) return;
          messageDialog(context,
              title: "แจ้งเตือน", message: "ไม่สามารถเชื่อมต่อได้");
        }
      }
    } else {
      if (tfName.text.isEmpty) {
        messageDialog(context,
            title: "แจ้งเตือน", message: "กรุณาเลือกวัคซีน");
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
                "เพิ่มการฉีดวัคซีน",
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
                        ColorHelper.lighten(primaryColor, .1).withOpacity(0.6),
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
        height: enabledSpecify ? 344 : 200,
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
              textHeader(title: "รายละเอียด"),
              textField(
                  hint: "ชนิดวัคซีน",
                  readOnly: true,
                  required: true,
                  controller: tfName,
                  onTap: () {
                    vaccineBottomDialog();
                  }),
              enabledSpecify ? const SizedBox(height: 8) : Container(),
              enabledSpecify
                  ? textField(
                      hint: "ชื่อวัคซีน",
                      controller: tfSpecifyName,
                      required: true)
                  : Container(),
              enabledSpecify ? const SizedBox(height: 8) : Container(),
              enabledSpecify
                  ? textField(
                      hint: "ระยะเวลาต้องฉีดซ้ำ (วัน)",
                      helperText: "ค่าเริ่มต้น = ไม่ฉีดซ้ำ (0 วัน) ",
                      controller: tfSpecifyDuration,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                    )
                  : Container(),
              const SizedBox(height: 16),
              textHeader(title: "สถานะการรักษา"),
              tabBar(),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ));
  }

  vaccineBottomDialog() {
    List<Widget> vaccines = [];
    for (var element in vaccineList) {
      vaccines.add(const SizedBox(height: 8));
      vaccines.add(button(
        element.name,
        icon: element.icon ?? FontAwesomeIcons.crutch,
        color: Colors.white,
        onTap: () async {
          if (element.name == "อื่น ๆ") {
            setState(() {
              enabledSpecify = true;
              tfName.text = "อื่น ๆ";
              vaccine = element;
            });
          } else {
            setState(() {
              enabledSpecify = false;
              tfName.text = element.name;
              vaccine = element;
            });
          }
          // await Navigator.of(context).push(
          //     NavigatorHelper.slide(const DiseaseTreatmentPage()));
        },
      ));
    }

    bottomDialog(
      context,
      height: 426,
      ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8, left: 6),
            child: Text(
              "เลือกวัคซีน",
              style: GoogleFonts.itim(
                  color:
                      ColorHelper.lighten(Colors.white, .2).withOpacity(0.86),
                  fontSize: 28),
            ),
          ),
        ]
          ..addAll(vaccines)
          ..addAll([
            const SizedBox(height: 26),
          ]),
      ),
    );
  }

  Widget button(String title, {Function? onTap, IconData? icon, Color? color}) {
    return SizedBox(
        height: 48, // <-- Your height
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 0),
                  Icon(
                    icon ?? FontAwesomeIcons.ellipsis,
                    color: ColorHelper.lighten(color ?? primaryColor, .4)
                        .withOpacity(0.8),
                    size: 18,
                  ),
                  Container(width: 16),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 20,
                        color: ColorHelper.lighten(color ?? primaryColor, .4)
                            .withOpacity(0.8)),
                  )
                ],
              )),
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

  Widget tabBar() {
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
        initialValue: notify,
        children: {
          0: buildSegment("แจ้งเตือน", 0),
          1: buildSegment("ไม่แจ้งเตือน", 1),
        },
        onValueChanged: (value) {
          setState(() {
            notify = value;
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
            fontSize: notify == number ? 18 : 16,
            color: notify == number
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

  OutlineInputBorder textFieldInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Colors.transparent));
}

class VaccineMockModel {
  String name;
  String key;
  IconData? icon;

  VaccineMockModel({required this.key, required this.name, this.icon});
}
