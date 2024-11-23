import 'package:buffaloes_farm_management/components/CustomTextFormField.dart';
import 'package:buffaloes_farm_management/components/MessagesDialog.dart';
import 'package:buffaloes_farm_management/components/SlidingTimePicker.dart';
import 'package:buffaloes_farm_management/service/FarmService.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

enum FinancialType { income, expense }

class AddFinancialPage extends StatefulWidget {
  const AddFinancialPage({Key? key, required this.type}) : super(key: key);

  final FinancialType type;

  @override
  _AddFinancialPageState createState() => _AddFinancialPageState();
}

class _AddFinancialPageState extends State<AddFinancialPage> {
  static RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  Color primaryColor = Colors.teal;
  Color backgroundColor = const Color(0xFF050505);
  bool isSaving = false, isSaved = false;
  DateTime? pickedDatetime;

  String? inputType;

  FinancialInputModel? selectedFinancial;

  String get getTitle {
    if (widget.type == FinancialType.income) {
      return "เพิ่มรายรับ";
    } else {
      return "เพิ่มรายจ่าย";
    }
  }

  String get getTFDate {
    if (widget.type == FinancialType.income) {
      return "วันที่ขาย";
    } else {
      return "วันที่ซื้อ";
    }
  }

  double get getHeight {
    if (widget.type == FinancialType.income) {
      return 200;
    } else {
      return 260;
    }
  }

  List<FinancialInputModel> financialIncomeModel = [
    FinancialInputModel("รายได้จากการขายควาย",
        tfPriceText: "ราคา/บาท/ตัว", tfWeightText: "นํ้าหนักที่ขาย"),
    FinancialInputModel("รายได้จากการขายมูล", tfPriceText: "ราคา/บาท/ครั้ง"),
  ];

  List<FinancialInputModel> financialExpenseModel = [
    FinancialInputModel("ค่ายา/เวชภัณฑ์", tfPriceText: "ราคา/บาท"),
    FinancialInputModel("ค่าพันธุ์ควาย",
        tfPriceText: "ราคา/บาท/ตัว", tfWeightText: "นํ้าหนักที่ซื้อ"),
    FinancialInputModel("ค่าอาหาร", tfPriceText: "ราคา/บาท"),
  ];

  TextEditingController tfWeight = TextEditingController();
  TextEditingController tfPrice = TextEditingController();

  load() async {}

  onSubmit() async {
    setState(() {
      isSaving = true;
    });
    if (selectedFinancial != null && tfPrice.text.isNotEmpty && pickedDatetime !=null){
      bool? result;

      result = await FarmService.addFinancial(
        name: selectedFinancial?.name,
        price: tfPrice.text,
        weight: tfWeight.text,
        type: widget.type.name.toUpperCase(),
        date: DateFormat('yyyy-MM-dd').format(pickedDatetime!),
      );

      if (result != null) {
        if (result == true) {
          isSaved = true;

          if (!mounted) return;
          messageDialog(context, title: "แจ้งเตือน", message: "บันทึกเรียบร้อย",
              function: () {
                Navigator.of(context).pop(true);
              });
        } else {
          if (!mounted) return;
          messageDialog(context,
              title: "แจ้งเตือน",
              message: "เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง");
          setState(() {
            isSaving = false;
          });
        }
      }else {
        if (!mounted) return;
        messageDialog(context,
            title: "แจ้งเตือน",
            message: "เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง");
        setState(() {
          isSaving = false;
        });
      }
    }else {
      if (selectedFinancial == null) {
        messageDialog(context,
            title: "แจ้งเตือน", message: "กรุณาเลือกรูปแบบ");
      } else if (tfPrice.text.isEmpty) {
        messageDialog(context,
            title: "แจ้งเตือน", message: "กรุณาใส่ราคา");
      } else if (pickedDatetime == null) {
        messageDialog(context,
            title: "แจ้งเตือน", message: "กรุณาเลือกวันที่");
      }
      setState(() {
        isSaving = false;
      });
    }


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
                    getTitle,
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
                        backgroundColor: ColorHelper.darken(primaryColor, .1)
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
                        ),
                      )
                    : body(context),
              ),
            ),
          ),
        ),
      ),
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
              textField(
                hint: "รูปแบบ",
                value: selectedFinancial?.name,
                required: true,
                readOnly: true,
                onTap: () {
                  inputTypeBottomDialog();
                },
              ),
              const SizedBox(height: 16),
              textField(
                hint: selectedFinancial?.tfPriceText ?? "ราคา",
                controller: tfPrice,
                required: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              textHeader(title: getTFDate),
              const SizedBox(height: 8),
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
              if (selectedFinancial?.tfWeightText != null)
                const SizedBox(height: 16),
              if (selectedFinancial?.tfWeightText != null)
                textField(
                  hint: selectedFinancial?.tfWeightText ?? "",
                  controller: tfWeight,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                ),
              const SizedBox(
                height: 24,
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
            //sellNoteValue = value;
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
            //distributorValue = value;
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
            //characteristicsValue = value;
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

  inputTypeBottomDialog() {
    List<Widget> choice = [];

    if (widget.type == FinancialType.income) {
      financialIncomeModel.forEach((element) {
        choice.add(const SizedBox(height: 8));
        choice.add(button(
          element.name,
          icon: FontAwesomeIcons.circle,
          color: const Color(0xFF010101),
          onTap: () async {
            setState(() {
              selectedFinancial = element;
            });
            // setState(() {
            //   gender = key == "F" ? 1 : 0;
            //   buffTypeKey = key;
            // });
            // await Navigator.of(context).push(
            //     NavigatorHelper.slide(const DiseaseTreatmentPage()));
          },
        ));
      });
    }

    if (widget.type == FinancialType.expense) {
      financialExpenseModel.forEach((element) {
        choice.add(const SizedBox(height: 8));
        choice.add(button(
          element.name,
          icon: FontAwesomeIcons.circle,
          color: const Color(0xFF010101),
          onTap: () async {
            setState(() {
              selectedFinancial = element;
            });
          },
        ));
      });
    }

    bottomDialog(
      context,
      height: getHeight,
      backgroundColor: Colors.white,
      ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8, left: 6),
            child: Text(
              "เลือกรูปแบบ",
              style: GoogleFonts.itim(
                  color: ColorHelper.lighten(const Color(0xFF0C0C0C), .2)
                      .withOpacity(0.86),
                  fontSize: 28),
            ),
          ),
        ]
          ..addAll(choice)
          ..addAll([
            const SizedBox(height: 26),
          ]),
      ),
    );
  }
}

class FinancialInputModel {
  String name;
  String? tfPriceText;
  String? tfWeightText;

  FinancialInputModel(this.name, {this.tfPriceText, this.tfWeightText});
}
