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

class DiseaseTreatmentPage extends StatefulWidget {
  DiseaseTreatmentPage({Key? key,required this.buffId}) : super(key: key);
  String buffId;

  @override
  _DiseaseTreatmentPageState createState() => _DiseaseTreatmentPageState();
}

class _DiseaseTreatmentPageState extends State<DiseaseTreatmentPage> {

  TextEditingController tfName = TextEditingController();
  TextEditingController tfSymptom = TextEditingController();
  TextEditingController tfDrugs = TextEditingController();

  TextEditingController tfDuration = TextEditingController();



  Color primaryColor = Colors.green;
  Color backgroundColor = const Color(0xFF050505);
  Color tabColor = ColorHelper.darken(Colors.green,.1);

  bool isSaving = false, isSaved = false;
  bool enabledSpecify = false;


  int status = 0;

  onSubmit() async {
    setState(() {
      isSaving = true;
    });
    if (tfName.text.isNotEmpty && tfSymptom.text.isNotEmpty && tfDrugs.text.isNotEmpty) {
      String? response = await FarmService.addDiseaseTreatment(
          buffId: widget.buffId,
          diseaseName: tfName.text,
          symptom: tfSymptom.text,
          drug: tfDrugs.text,
          healedStatus: status == 0,
          duration: status == 1 ? int.tryParse(tfDuration.text) ?? 30 : null,
          date: DateTime.now());


      if (response != null) {
        if (response == "SUCCESS") {
          isSaved = true;

          if (!mounted) return;
          messageDialog(context, title: "แจ้งเตือน", message: "บันทึกเรียบร้อย",
              function: () {
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
    } else {
      if (tfName.text.isEmpty) {
        messageDialog(context,
            title: "แจ้งเตือน", message: "กรุณากรอกขื่อโรค");
      }else if (tfSymptom.text.isEmpty) {
        messageDialog(context,
            title: "แจ้งเตือน", message: "กรุณากรอกอาการของโรค");
      } else if (tfDrugs.text.isEmpty) {
        messageDialog(context,
            title: "แจ้งเตือน", message: "กรุณากรอกยาที่ใช้");
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
        height: enabledSpecify ? 504 :418 ,
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
              textField(hint: "ชื่อโรค", controller: tfName,required: true),
              const SizedBox(height: 22),

              textField(hint: "อาการของโรค",helperText: 'หากมีหลายอาการ กรุณาใช้เครื่องหมาย "จุลภาค"(,) แบ่งแต่ละอาการ', controller: tfSymptom,required: true),
              const SizedBox(height: 8),
              textField(hint: "ยาที่ใช้",helperText: 'หากใช้ยาหลายตัว กรุณาใช้เครื่องหมาย "จุลภาค"(,) แบ่งยาแต่ละตัว', controller: tfDrugs,required: true),
              const SizedBox(height: 16),
              textHeader(title: "สถานะการรักษา"),
              tabBar(),
              enabledSpecify ? const SizedBox(height: 8) : Container(),
              enabledSpecify
                  ? textField(
                hint: "ระยะเวลารักษา (วัน)",
                helperText: "ค่าเริ่มต้น = 30 วัน ",
                controller: tfDuration,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
              )
                  : Container(),
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
