import 'package:buffaloes_farm_management/components/SlidingTimePicker.dart';
import 'package:flutter/material.dart';
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
import 'package:intl/intl.dart';

class SellingPage extends StatefulWidget {
  const SellingPage({super.key, required this.buffId});

  final String buffId;

  @override
  State<SellingPage> createState() => _SellingPageState();
}

class _SellingPageState extends State<SellingPage> {
  TextEditingController tfBuyerDetail = TextEditingController();
  TextEditingController tfDuration = TextEditingController();
  TextEditingController tfDistributor = TextEditingController();
  TextEditingController tfCharacteristics = TextEditingController();

  Color primaryColor = Colors.grey.shade500;
  Color backgroundColor = const Color(0xFF050505);
  Color tabColor = ColorHelper.darken(Colors.grey.shade500, .1);

  bool isSaving = false, isSaved = false;

  String? sellNoteValue, distributorValue, characteristicsValue;

  int notify = 0;

  DateTime? pickedDatetime;

  onSubmit() async {
    setState(() {
      isSaving = true;
    });
    // if (tfName.text.isNotEmpty) {
    //   String? response = await FarmService.addDeworming(
    //       buffId: widget.buffId,
    //       anthelminticDrugName: tfName.text,
    //       nextDewormingDuration: int.tryParse(tfDuration.text),
    //       date: DateTime.now());
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
    //   // if (tfBuyerDetail.text.isEmpty) {
    //   //   messageDialog(context,
    //   //       title: "แจ้งเตือน", message: "กรุณากรอกชื่อยาถ่ายพยาธิ");
    //   // }
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
                            "การจำหน่าย",
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
                                    ColorHelper.darken(primaryColor, .1)
                                        .withOpacity(0.7),
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
                                        color: Colors.white.withOpacity(0.99),
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
                      ))))),
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
        //height: 290,
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
              textHeader(title: "รายละเอียด"),
              const SizedBox(height: 12),
              textField(
                hint: "วัน/เดือน/ปี",
                required: true,
                readOnly: true,
                value: pickedDatetime != null
                    ? DateFormat('d MMMM y', 'th').format(pickedDatetime!)
                    : null,
                onTap: () async {
                  DateTime? selectdDateTime = await SlidingTimePicker(context,
                      dateTime: pickedDatetime);
                  if (selectdDateTime != null) {
                    setState(() {
                      pickedDatetime = selectdDateTime;
                    });
                    //x = "${DateFormat.Hm().format(selectdDateTime)}:00";
                  }
                },
              ),
              const SizedBox(height: 16),
              textField(
                hint: "สรุปจำนวนวันที่เลี้ยง",
                controller: tfDuration,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              textField(
                hint: "เหตุผลการจำหน่าย",
                value: sellNoteValue,
                readOnly: true,
                onTap: () {
                  sellNoteBottomDialog();
                },
              ),
              const SizedBox(height: 26),
              textField(
                  hint: "ข้อมูลผู้ซื้อ",
                  controller: tfBuyerDetail,
                  required: false),
              const SizedBox(height: 16),
              textField(
                hint: "ช่องทางการจำหน่าย",
                value: distributorValue,
                readOnly: true,
                onTap: () {
                  distributorBottomDialog();
                },
              ),
              if (distributorValue == "อื่น ๆ") const SizedBox(height: 8),
              if (distributorValue == "อื่น ๆ")
                textField(
                  hint: "ระบุ",
                  controller: tfDistributor,
                ),
              const SizedBox(height: 26),
              textField(
                hint: "ลักษณะการจำหน่าย",
                value: characteristicsValue,
                readOnly: true,
                onTap: () {
                  characteristicsBottomDialog();
                },
              ),
              if (characteristicsValue == "อื่น ๆ") const SizedBox(height: 8),
              if (characteristicsValue == "อื่น ๆ")
                textField(
                  hint: "ระบุ",
                  controller: tfCharacteristics,
                ),
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

  sellNoteBottomDialog() {
    List<String> buffSourceList = [
      "ขาย",
      "ทำลาย",
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
            sellNoteValue = value;
          });
          // await Navigator.of(context).push(
          //     NavigatorHelper.slide(const DiseaseTreatmentPage()));
        },
      ));
    });

    bottomDialog(
      context,
      //height: 360,
      backgroundColor: Colors.white,
      ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8, left: 6),
            child: Text(
              "เลือกแหล่งที่มา",
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


  distributorBottomDialog() {
    List<String> buffSourceList = [
      "พ่อค้าคนกลาง",
      "ชำแหละและจำหน่ายเอง",
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
            distributorValue = value;
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
              "เลือกแหล่งที่มา",
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

  characteristicsBottomDialog() {
    List<String> buffSourceList = [
      "ประมาณการด้วยสายตา",
      "ขายตามราคาน้ำหนักมีชีวิต",
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
            characteristicsValue = value;
          });
          // await Navigator.of(context).push(
          //     NavigatorHelper.slide(const DiseaseTreatmentPage()));
        },
      ));
    });

    bottomDialog(
      context,
      //height: 360,
      backgroundColor: Colors.white,
      ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8, left: 6),
            child: Text(
              "เลือกแหล่งที่มา",
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
