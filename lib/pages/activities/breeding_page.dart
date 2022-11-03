import 'package:buffaloes_farm_management/components/SlidingTimePicker.dart';
import 'package:buffaloes_farm_management/constants/ColorConstants.dart';
import 'package:buffaloes_farm_management/constants/StyleConstants.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BreedingPage extends StatefulWidget {
  const BreedingPage({Key? key}) : super(key: key);

  @override
  _BreedingPageState createState() => _BreedingPageState();
}

class _BreedingPageState extends State<BreedingPage> {
  TextEditingController tfName = TextEditingController();
  TextEditingController tfTag = TextEditingController();
  TextEditingController tfFather = TextEditingController();
  TextEditingController tfMother = TextEditingController();
  TextEditingController tfSource = TextEditingController();

  Color primaryColor = Colors.pink;
  Color backgroundColor = const Color(0xFF050505);
  Color tabColor = ColorHelper.darken(Colors.pink, .1);

  bool isSaving = false, isSaved = false;

  int notify = 0;
  int type = 0;
  int result = 0;

  DateTime? pickedDatetime;
  DateTime? pickedBirthDatetime;




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
            // Container(
            //   padding: const EdgeInsets.only(right: 6),
            //   child: IconButton(
            //     icon: const Icon(FontAwesomeIcons.penToSquare, color: Colors.white,size: 22),
            //     onPressed: () {
            //       if (isSaving == false) {
            //         Navigator.of(context).pop(false);
            //       }
            //     },
            //   ),
            // )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: submitButtonEnabled()
            ? FloatingActionButton.extended(
                onPressed: () {},
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
        height: 402,
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
                  0: buildSegment("ผสมเทียม", 0,type),
                  1: buildSegment("ผสมจริง", 1,type),
                },
                callback: (value) {
                  setState(() {
                    type = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              textHeader(title: "รายละเอียดน้ำเชื้อพ่อพันธุ์"),
              textField(hint: "ชื่อพ่อพันธุ์", controller: tfName),
              const SizedBox(height: 8),
              textField(hint: "เบอร์หูพ่อพันธุ์", controller: tfTag),
              const SizedBox(height: 14),
              divider(),
              const SizedBox(height: 6),

              textHeader(title: "การกลับสัด"),
              textField(
                hint: "วัน/เดือน/ปี",
                readOnly: true,
                value: pickedDatetime != null
                    ? DateFormat('d MMMM y', 'th').format(pickedDatetime!)
                    : null,
                onTap: () async {
                  DateTime? selectdDateTime = await SlidingTimePicker(
                      context,
                      dateTime: pickedDatetime);
                  if (selectdDateTime != null) {
                    setState(() {
                      pickedDatetime = selectdDateTime;
                    });
                    //x = "${DateFormat.Hm().format(selectdDateTime)}:00";
                  }
                },
              ),
              const SizedBox(height: 8),
              tabBar(
                initialValue: notify,
                children: {
                  0: buildSegment("แจ้งเตือน", 0,notify),
                  1: buildSegment("ไม่แจ้งเตือน", 1,notify),
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

  Widget divider(){
    return Container(
      width: double.infinity,
      height: 1,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.transparent,
              ColorHelper.lighten(primaryColor)
                  .withOpacity(0.2),
              ColorHelper.lighten(primaryColor)
                  .withOpacity(0.5),
              ColorHelper.lighten(primaryColor)
                  .withOpacity(0.2),
              Colors.transparent,
            ],
            begin:  Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.0,0.15 ,0.5,0.85,1.0],
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
      Function? onTap,
      bool enabled = true,
      TextAlign textAlign = TextAlign.start,
      required String hint}) {
    return Container(
        height: 44,
        margin: const EdgeInsets.only(top: 0),
        child: TextFormField(
          readOnly: readOnly,
          enabled: enabled,
          textInputAction: TextInputAction.next,
          textAlign: textAlign,

          controller: controller ?? TextEditingController(text: value),
          style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontFamily: 'Itim'),
          //maxLength: 10,
          // inputFormatters: [
          //   MaskedInputFormatter('###-###-####')
          // ],
          //initialValue: value,
          onEditingComplete: () {
            FocusScope.of(context).nextFocus();
            setState(() {});
          },

          onTap: () {
            onTap?.call();
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: enabled
                ? Colors.white.withOpacity(0.05)
                : bgDisabledTextFieldColor,
            filled: true,
            hintStyle: hintText,
            contentPadding: fieldSearchPadding,
            enabledBorder: textFieldInputBorder,
            disabledBorder: textFieldInputBorder,
            focusedBorder: textFieldInputBorder,
          ),
        ));
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
          color: ColorHelper.lighten(backgroundColor, .2),
          borderRadius: BorderRadius.circular(10),
        ),
        //thumbColor: Colors.white,
        thumbDecoration: BoxDecoration(
          color: ColorHelper.lighten(primaryColor, .1).withOpacity(0.6),
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

  Widget buildSegment(String text, int number,int selectedValue) {
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

  OutlineInputBorder textFieldInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Colors.transparent));
}
