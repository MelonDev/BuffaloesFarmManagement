import 'package:buffaloes_farm_management/constants/ColorConstants.dart';
import 'package:flutter/material.dart';

final navyButtonStyle = OutlinedButton.styleFrom(
  primary: Colors.white,
  backgroundColor: bgButtonColor,
  textStyle: const TextStyle(fontSize: 20),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
  ),
);

final navyButtonDisabledStyle = OutlinedButton.styleFrom(
  primary: Colors.white,
  backgroundColor: bgButtonColor.withOpacity(0.5),
  textStyle: const TextStyle(fontSize: 20),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
  ),
);

const maxHeightContain = BoxConstraints(
  maxHeight: double.infinity,
);

const textFieldStyle = TextStyle(
    color: kTextBlack,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontFamily: 'Itim');

const textFieldDarkStyle = TextStyle(
    color: Color(0xCCFFFFFF),
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontFamily: 'Itim');

const textFieldErrorStyle = TextStyle(
    color: Colors.red,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Itim');

const textFieldHelperStyle = TextStyle(
    color: Color(0x989D9D9D),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Itim');

final announceText = TextStyle(
    decoration: TextDecoration.none,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: bgButtonColor.withOpacity(0.8),
    fontFamily: 'Itim');

const hintText = TextStyle(
    color: Color(0xFF9D9D9D),
    fontWeight: FontWeight.w400,
    fontSize: 18,
    fontFamily: 'Itim');

const hintDisabledText = TextStyle(
    color: Color(0x999D9D9D),
    fontWeight: FontWeight.w400,
    fontSize: 18,
    fontFamily: 'Itim');

const labelText = TextStyle(
    color: Color(0xFF9D9D9D),
    fontWeight: FontWeight.w400,
    fontSize: 16,
    fontFamily: 'Itim');

const textFieldInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Color(0xFFC1C1C1)));

const textFieldInputTransparentBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Colors.transparent));

const textFieldInputTransparentFocusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Color(0xFF676767)));

const textFieldDisabledInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Color(0xFF858585)));

const textFieldErrorInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(
      color: Colors.red,
      width: 2,
    ));

const textFieldInputError = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(
      color: Colors.red,
      width: 2,
    ));

const textFieldBuffInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: buffMenuBGDarkColor));

const fieldSearchPadding =
    EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0);

const whiteTextButton = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontFamily: 'Itim');

const blackTextButton = TextStyle(
    color: kTextBlack,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontFamily: 'Kanit');
