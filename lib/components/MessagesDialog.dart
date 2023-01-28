import 'package:buffaloes_farm_management/constants/ColorConstants.dart';
import 'package:buffaloes_farm_management/constants/StyleConstants.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
as modal_bottom_sheet;

void messageDialog(BuildContext context,
    {required String title,
    String? message,
    String? buttonText,
    Color? buttonColor,
    Function? function}) {
  showDialog<Widget>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          constraints: maxHeightContain,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              )),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 10, top: 20),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 12, right: 12),
                    child: Text(
                      title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: bgButtonColor,
                          fontFamily: 'Itim'),
                    ),
                  ),
                  message != null
                      ? Container(
                          margin: const EdgeInsets.only(
                              left: 12, top: 6, right: 12),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            message,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                                color: bgButtonColor.withOpacity(0.7),
                                fontFamily: 'Itim'),
                          ),
                        )
                      : Container(),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 46,
                    margin: const EdgeInsets.only(
                        top: 30, left: 10, right: 10, bottom: 4),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: buttonColor ?? bgButtonColor,
                        textStyle: const TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        function?.call();
                      },
                      child: Text(
                        buttonText ?? 'รับทราบ',
                        style: whiteTextButton,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

void bottomDialog(BuildContext context, Widget child,{double? height,Color? backgroundColor}) {
  modal_bottom_sheet.showMaterialModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24)),
    ),
    context: context,
    expand: false,
    //backgroundColor: const Color(0xFF0C0C0C),
    backgroundColor: backgroundColor ?? const Color(0xFF060606),
    barrierColor: Colors.black.withOpacity(0.96),
    builder: (context) =>  SizedBox(height: height,child: child),
  ).whenComplete(() {
    FocusManager.instance.primaryFocus?.unfocus();
  });
}
