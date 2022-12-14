import 'dart:async';

import 'package:buffaloes_farm_management/constants/ColorConstants.dart';
import 'package:buffaloes_farm_management/cubit/authentication/authentication_cubit.dart';
import 'package:buffaloes_farm_management/pages/loading/authenticate_loading_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:ionicons/ionicons.dart';

class SMSPinPage extends StatelessWidget {
  SMSPinPage({Key? key, required this.phoneNumber}) : super(key: key);

  String phoneNumber;

  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  StreamController<ErrorAnimationType>? errorController =
      StreamController<ErrorAnimationType>();
  final formKey = GlobalKey<FormState>();
  bool hasError = false;

  String? timestamp;

  snackBar(BuildContext context, String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? "",style: GoogleFonts.itim(fontSize: 16)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          print(state.toString());
      String? message;
      if (state is ErrorSMSState) {
        if(timestamp != state.timestamp){
          focusNode.requestFocus();
          textEditingController.clear();
          errorController =
              StreamController<ErrorAnimationType>();
          errorController!.add(ErrorAnimationType.shake);
          hasError = true;
          message = state.message;
          timestamp = state.timestamp;
        }

      } else {
        message = null;
      }
      if(state is AuthenticatingState){
        if(state.loading == false){
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: kBGColor,
              systemNavigationBarDividerColor: kBGColor,
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              //systemNavigationBarContrastEnforced: true,
            ),
            child: Material(
                child: Scaffold(
                  backgroundColor: bgButtonColor,
                  appBar: PreferredSize(
                      preferredSize: const Size.fromHeight(50.0),
                      // here the desired height
                      child:AppBar(
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
                          "ยืนยันตัวตน",
                          style: GoogleFonts.itim(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                        titleSpacing: 0,
                        leading: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            context.read<AuthenticationCubit>().signOut(context);
                          },
                        ),
                      )),
                  // floatingActionButtonLocation:
                  //     FloatingActionButtonLocation.centerFloat,
                  // floatingActionButton: FloatingActionButton.extended(
                  //   onPressed: () {
                  //     print("FloatingActionButton");
                  //     formKey.currentState!.validate();
                  //     if (textEditingController.text.length != 6) {
                  //       errorController!.add(ErrorAnimationType.shake);
                  //       hasError = true;
                  //     } else {
                  //       hasError = false;
                  //       if (state is WaitSMSState) {
                  //         context.read<AuthenticationCubit>().pining(
                  //             context: context,
                  //             code: textEditingController.text,
                  //             verificationId: state.verificationId,
                  //             resendToken: state.resendToken);
                  //       }
                  //       //snackBar(context, "OTP Verified!!");
                  //     }
                  //   },
                  //   heroTag: null,
                  //   backgroundColor: bgButtonColor,
                  //   extendedPadding: const EdgeInsets.only(left: 94, right: 94),
                  //   extendedIconLabelSpacing: 12,
                  //   elevation: 0,
                  //   splashColor: bgButtonColor.withOpacity(0.4),
                  //   shape: const RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(14))),
                  //   label: Text("ยืนยัน",
                  //       style: GoogleFonts.itim(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 18)),
                  //   icon: Icon(Ionicons.checkmark_outline, color: Colors.white),
                  // ),
                  body: Center(
                    child: Container(
                        decoration:  const BoxDecoration(
                            color: kBGColor,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(22),
                                bottom: Radius.circular(kIsWeb ? 22 : 0)

                            )),
                        constraints: BoxConstraints(
                            maxHeight: kIsWeb ? 400 : MediaQuery.of(context).size.height,
                            maxWidth: 400
                        ),
                        height: MediaQuery.of(context).size.height,
                        child: ListView(
                          //padding: const EdgeInsets.only(bottom: 30),
                          children: <Widget>[
                            const SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 8),
                              child: RichText(
                                text: TextSpan(
                                    text: "รหัสถูกส่งไปที่เบอร์  ",
                                    children: [
                                      TextSpan(
                                          text: phoneNumber.replaceAll("+66", "0"),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ],
                                    style: GoogleFonts.itim(
                                        color: Colors.black54, fontSize: 15)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Form(
                              key: formKey,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 30),
                                  child: PinCodeTextField(
                                    autoDisposeControllers: false,
                                    appContext: context,
                                    pastedTextStyle: TextStyle(
                                      color: Colors.green.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    length: 6,
                                    autoFocus: true,
                                    focusNode: focusNode,
                                    obscureText: true,
                                    obscuringCharacter: '•',
                                    blinkWhenObscuring: true,
                                    animationType: AnimationType.fade,
                                    validator: (v) {},
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 40,
                                      activeFillColor: Colors.transparent,
                                      inactiveColor: Colors.red,
                                      selectedColor: bgButtonColor,
                                      selectedFillColor: Colors.transparent,
                                      inactiveFillColor: Colors.transparent,
                                    ),
                                    cursorColor: Colors.black,
                                    animationDuration: const Duration(milliseconds: 300),
                                    enableActiveFill: true,
                                    errorAnimationController: errorController,
                                    controller: textEditingController,
                                    keyboardType: TextInputType.number,
                                    boxShadows: const [
                                      BoxShadow(
                                        offset: Offset(0, 1),
                                        color: Colors.transparent,
                                        blurRadius: 0,
                                      )
                                    ],
                                    onCompleted: (v) {
                                      print("onCompleted");
                                      print(state);
                                      if (state is WaitSMSState) {
                                        context.read<AuthenticationCubit>().pining(
                                            context: context,
                                            code: textEditingController.text,
                                            verificationId: state.verificationId,
                                            phoneNumber: phoneNumber,
                                            resendToken: state.resendToken);
                                      } else if (state is ErrorSMSState) {
                                        context.read<AuthenticationCubit>().pining(
                                            context: context,
                                            code: textEditingController.text,
                                            verificationId: state.verificationId,
                                            phoneNumber: phoneNumber,
                                            resendToken: state.resendToken);
                                      }
                                    },
                                    // onTap: () {
                                    //   print("Pressed");
                                    // },
                                    onChanged: (value) {
                                      debugPrint(value);
                                    },
                                    beforeTextPaste: (text) {
                                      debugPrint("Allowing to paste $text");
                                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                      return true;
                                    },
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text(
                                hasError
                                    ? (message != null
                                    ? "*$message"
                                    : "*กรุณากรอกรหัสให้ครบทุกช่อง")
                                    : "",
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "ไม่ได้รับรหัสยืนยันตัวตน? ",
                                  style: TextStyle(color: Colors.black54, fontSize: 15),
                                ),
                                Container(width: 10),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: bgButtonColor,
                                    side: const BorderSide(
                                        width: 2.0, color: bgButtonColor),
                                  ),
                                  onPressed: () {
                                    context.read<AuthenticationCubit>().resend(context,phoneNumber);
                                    snackBar(context,"ส่ง SMS ใหม่เรียบร้อย");
                                  },
                                  child: const Text(
                                    "ส่งอีกครั้ง",
                                    style: TextStyle(
                                        color: bgButtonColor,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                          ],
                        )),
                  ),
                )),
          );
        }
      }
      return const AuthenticateLoadingPage();

    });
  }
}
