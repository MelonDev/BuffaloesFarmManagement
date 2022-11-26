import 'dart:io';

import 'package:buffaloes_farm_management/components/CustomTextFormField.dart';
import 'package:buffaloes_farm_management/components/MessagesDialog.dart';
import 'package:buffaloes_farm_management/constants/ColorConstants.dart';
import 'package:buffaloes_farm_management/constants/StyleConstants.dart';
import 'package:buffaloes_farm_management/components/SlidingTimePicker.dart';
import 'package:buffaloes_farm_management/cubit/home/home_cubit.dart';
import 'package:buffaloes_farm_management/service/FarmService.dart';
import 'package:buffaloes_farm_management/service/HttpService.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddBuffPage extends StatefulWidget {
  const AddBuffPage({Key? key}) : super(key: key);

  @override
  _AddBuffPage createState() => _AddBuffPage();
}

class _AddBuffPage extends State<AddBuffPage> {
  static RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  DateTime? pickedDatetime;

  TextEditingController tfName = TextEditingController();
  TextEditingController tfTag = TextEditingController();
  TextEditingController tfFather = TextEditingController();
  TextEditingController tfMother = TextEditingController();
  TextEditingController tfSource = TextEditingController();

  File? image;
  bool isSaving = false, isSaved = false;

  int gender = 0;

  Future pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        this.image = File(image.path);
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  onSubmit() async {
    setState(() {
      isSaving = true;
    });
    if (tfName.text.isNotEmpty &&
        tfTag.text.isNotEmpty &&
        pickedDatetime != null) {
      String? url;

      if (image != null) {
        url = await HttpService.uploadToFirebase(image!);

        if (url == null) {
          if (!mounted) return;
          messageDialog(context,
              title: "แจ้งเตือน", message: "เกิดข้อผิดพลาดในการอัปโหลต");
          return false;
        }
      }

      bool? result = await FarmService.addBuff(
          name: tfName.text,
          tag: tfTag.text,
          father: tfFather.text,
          mother: tfMother.text,
          source: tfSource.text,
          gender: gender == 0 ? "Male" : "Female",
          image: url,
          datetime: DateFormat('yyyy-MM-dd').format(pickedDatetime!));

      if (result != null) {
        if (result == true) {
          isSaved = true;

          if (!mounted) return;
          messageDialog(context, title: "แจ้งเตือน", message: "บันทึกเรียบร้อย",
              function: () {
            context.read<HomeCubit>().management();
            Navigator.of(context).pop(true);
          });
        } else {
          if (!mounted) return;
          messageDialog(context,
              title: "แจ้งเตือน",
              message: "เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง");
        }
      } else {
        if (!mounted) return;
        messageDialog(context,
            title: "แจ้งเตือน", message: "ไม่สามารถเชื่อมต่อได้");
      }
    } else {
      if (tfName.text.isEmpty) {
        messageDialog(context,
            title: "แจ้งเตือน", message: "กรุณากรอกชื่อให้ครบถ้วน");
      } else if (pickedDatetime != null) {
        messageDialog(context,
            title: "แจ้งเตือน", message: "กรุณาเลือกวันเดือนปีเกิด");
      } else if (tfTag.text.isEmpty) {
        messageDialog(context, title: "แจ้งเตือน", message: "กรุณาใส่เบอร์หู");
      }
    }
    setState(() {
      isSaving = false;
    });
  }

  bool submitButtonEnabled() {
    if (isSaving == true) {
      return false;
    } else {
      return tfName.text.isNotEmpty &&
          tfTag.text.isNotEmpty &&
          pickedDatetime != null;
    }
  }

  Color primaryColor = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return Hero(
        createRectTween: _createRectTween,
        tag: "MANAGEMENT_TAG",
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: primaryColor,
            systemNavigationBarDividerColor: primaryColor,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            //systemNavigationBarContrastEnforced: true,
          ),
    child: GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: primaryColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0.0,
              surfaceTintColor: primaryColor,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(22),
                ),
              ),
              centerTitle: true,
              title: Text(
                "เพิ่มกระบือ",
                style: GoogleFonts.itim(
                  color: Colors.white,
                  fontSize: 24,
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: submitButtonEnabled()
                ? FloatingActionButton.extended(
                    onPressed: () {
                      onSubmit();
                    },
                    heroTag: null,
                    backgroundColor: Colors.black.withOpacity(0.5),
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
                            color: Colors.white.withOpacity(0.96),
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    icon: Icon(FontAwesomeIcons.solidFloppyDisk,
                        color: Colors.white.withOpacity(0.96)),
                  )
                : null,
            body: isSaving == true || isSaved == true
                ? const Center(
                    child: SpinKitThreeBounce(
                    color: Colors.white,
                    size: 50.0,
                  ))
                : body(context),
          ),)
        ));
  }

  body(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: kBGColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(22),
            bottom: Radius.circular(22),
          ),
        ),
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
              imageArea(),
              const SizedBox(height: 8),
              textHeader(title: "รายละเอียด"),
              const SizedBox(height: 4),
              textField(hint: "ชื่อ", controller: tfName, required: true),
              const SizedBox(height: 8),
              textField(hint: "เบอร์หู", controller: tfTag, required: true),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: textField(
                      hint: "วัน/เดือน/ปี เกิด",
                      required: true,
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
                  ),
                  Container(width: 10),
                  Container(
                      width: 76,
                      child: textField(
                          hint: pickedDatetime != null
                              ? "${DateTime.now().year - pickedDatetime!.year} ปี"
                              : "0 ปี",
                          textAlign: TextAlign.center,
                          enabled: false))
                ],
              ),
              const SizedBox(height: 8),
              tabBar(),
              const SizedBox(height: 20),
              textHeader(title: "พันธุ์"),
              const SizedBox(height: 4),
              textField(hint: "ชื่อพ่อ", controller: tfFather),
              const SizedBox(height: 8),
              textField(hint: "ชื่อแม่", controller: tfMother),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              textField(hint: "แหล่งที่มา", controller: tfSource),
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

  Widget imageArea() {
    return GestureDetector(
      onTap: () {
        pickImage();
      },
      child: Container(
        height: 140,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFC1C1C1))),
        margin: const EdgeInsets.only(top: 0),
        child: Stack(
          children: [
            image != null
                ? Container(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(),
            image == null
                ? Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Icon(
                            FontAwesomeIcons.fileCirclePlus,
                            size: 46,
                            color: Color(0xFF9D9D9D),
                          ),
                          Container(height: 2),
                          Text(
                            "เลือกรูป..",
                            style: GoogleFonts.itim(
                                color: Color(0xFF9D9D9D), fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
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
        controller: controller,
        enabled: enabled,
        onTap: onTap,
        required: required,
        value: value,
        textAlign: textAlign);
  }

  Widget tabBar() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 0, right: 0),
      padding: const EdgeInsets.all(4),
      child: CustomSlidingSegmentedControl<int>(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(40),
        ),
        //thumbColor: Colors.white,
        thumbDecoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(40),
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
        initialValue: gender,
        children: {
          0: buildSegment("ผู้", 0),
          1: buildSegment("เมีย", 1),
        },
        onValueChanged: (value) {
          setState(() {
            gender = value;
          });
        },
      ),
    );
  }

  Widget buildSegment(String text, int number) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 4, bottom: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: gender == number ? 20 : 16,
            color: gender == number
                ? Colors.white
                : Colors.black.withOpacity(0.4)),
      ),
    );
  }
}
