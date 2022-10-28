import 'dart:io';

import 'package:buffaloes_farm_management/components/MessagesDialog.dart';
import 'package:buffaloes_farm_management/constants/ColorConstants.dart';
import 'package:buffaloes_farm_management/constants/StyleConstants.dart';
import 'package:buffaloes_farm_management/components/SlidingTimePicker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController tfFather = TextEditingController();
  TextEditingController tfMother = TextEditingController();
  TextEditingController tfSource = TextEditingController();

  File? image;

  Future pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        this.image = File(image.path);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  onSubmit() async {
    if (tfName.text.isNotEmpty && pickedDatetime != null) {

    }else {
      if(tfName.text.isEmpty){
        messageDialog(context,title: "แจ้งเตือน",message: "กรุณากรอกชื่อให้ครบถ้วน");
      }else if(pickedDatetime != null){
        messageDialog(context,title: "แจ้งเตือน",message: "กรุณาเลือกวันเดือนปีเกิด");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        createRectTween: _createRectTween,
        tag: "FARM_TAG",
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: buffMenuBGColor,
            systemNavigationBarDividerColor: buffMenuBGColor,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            //systemNavigationBarContrastEnforced: true,
          ),
          child: Scaffold(
            backgroundColor: buffMenuBGColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
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
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                onSubmit();
              },
              heroTag: null,
              backgroundColor: Colors.black.withOpacity(0.5),
              extendedPadding: const EdgeInsets.only(left: 44, right: 44),
              extendedIconLabelSpacing: 12,
              elevation: 0,
              //splashColor: Colors.greenAccent.withOpacity(0.4),
              splashColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              label: Text("บันทึก",
                  style: GoogleFonts.itim(
                      //color: buffMenuBGColor,
                    color: Colors.white.withOpacity(0.96),
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              icon: Icon(FontAwesomeIcons.solidFloppyDisk, color: Colors.white.withOpacity(0.96)),
            ),
            body: body(context),
          ),
        ));
  }

  body(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: kBGColor,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(22), bottom: Radius.circular(22))),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        //height: 460,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 90),
        //height: MediaQuery.of(context).size.height,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 0),
          children: <Widget>[
            const SizedBox(height: 20),
            imageArea(),
            const SizedBox(height: 8),
            textHeader(title: "รายละเอียด"),
            textField(hint: "ชื่อ",controller: tfName),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: textField(
                    hint: "วัน/เดือน/ปี เกิด",
                    readOnly: true,
                    value: pickedDatetime != null
                        ? DateFormat('d MMMM y', 'th').format(pickedDatetime!)
                        : null,
                    onTap: () async {
                      DateTime? selectdDateTime =
                          await SlidingTimePicker(context,dateTime: pickedDatetime);
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
                        hint: pickedDatetime != null ? "${DateTime.now().year - pickedDatetime!.year} ปี" : "0 ปี",
                        textAlign: TextAlign.center,
                        enabled: false))
              ],
            ),

            const SizedBox(height: 20),
            textHeader(title: "พันธุ์"),
            textField(hint: "ชื่อพ่อ"),
            const SizedBox(height: 8),
            textField(hint: "ชื่อแม่"),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            textField(hint: "แหล่งที่มา"),

            // const Padding(
            //   padding: EdgeInsets.only(left: 30, right: 30),
            //   child: Divider(
            //     color: Colors.grey,
            //   ),
            // ),
            // const SizedBox(height: 6),
            // //textHeader(title: "รายละเอียด"),
            // textField(hint: "ชื่อ",controller: firstNameController),
            // const SizedBox(height: 8),
            // textField(hint: "นามสกุล",controller: lastNameController),
            // const SizedBox(height: 12),
            // const Padding(
            //   padding: EdgeInsets.only(left: 30, right: 30),
            //   child: Divider(
            //     color: Colors.grey,
            //   ),
            // ),
            // const SizedBox(height: 6),
            // textHeader(title: "ที่อยู่"),
            // textField(hint: "",controller: addressController),
            // const SizedBox(height: 8),
            // textField(
            //     hint: "จังหวัด",
            //     value: province?.PROVINCE_NAME,
            //     readOnly: true,
            //     enabled: true,
            //     onTap: () {
            //       provinceDialog();
            //     }),
            // const SizedBox(height: 8),
            // textField(
            //     hint: "อำเภอ",
            //     value: district?.DISTRICT_NAME,
            //     readOnly: true,
            //     enabled: province != null,
            //     onTap: () {
            //       districtDialog();
            //     }),
            // const SizedBox(height: 8),
            // textField(
            //     hint: "ตำบล",
            //     value: subDistrict?.SUB_DISTRICT_NAME,
            //     readOnly: true,
            //     enabled: district != null,
            //     onTap: () {
            //       subDistrictDialog();
            //     }),
            // const SizedBox(height: 12),
            // const Padding(
            //   padding: EdgeInsets.only(left: 30, right: 30),
            //   child: Divider(
            //     color: Colors.grey,
            //   ),
            // ),
            // const SizedBox(height: 6),
            // button(
            //     enabled: isEnabledConfirmButton(),
            //     title: "ยืนยัน",
            //     function: () {
            //       onSubmit();
            //     }),
            const SizedBox(
              height: 20,
            ),
          ],
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
          style: textFieldStyle,
          //maxLength: 10,
          // inputFormatters: [
          //   MaskedInputFormatter('###-###-####')
          // ],
          //initialValue: value,

          onTap: () {
            onTap?.call();
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: enabled ? Colors.white : bgDisabledTextFieldColor,
            filled: true,
            hintStyle: hintText,
            contentPadding: fieldSearchPadding,
            enabledBorder: textFieldInputBorder,
            disabledBorder: textFieldInputBorder,
            focusedBorder: textFieldInputBorder,
          ),
        ));
  }
}
