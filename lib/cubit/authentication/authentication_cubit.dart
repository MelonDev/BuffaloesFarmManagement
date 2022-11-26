import 'package:bloc/bloc.dart';
import 'package:buffaloes_farm_management/pages/add_buff_page.dart';
import 'package:buffaloes_farm_management/pages/home_page.dart';
import 'package:buffaloes_farm_management/pages/authentication/initial_farm_page.dart';
import 'package:buffaloes_farm_management/pages/authentication/login_page.dart';
import 'package:buffaloes_farm_management/pages/authentication/sms_pin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(UnauthenticationState());

  FirebaseAuth auth = FirebaseAuth.instance;
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  ConfirmationResult? confirmationResult;

  checking(BuildContext context, {bool useNavigator = true}) async{
    //signOut(context);
    String? uid = await currentUserUid();
    if (uid != null) {
      //emit(UnauthenticationState());
      emit(AuthenticatedState());
      if (useNavigator) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const InitialFarmPage()),
            (Route<dynamic> route) => false);
      }
    } else {
      //signOut(context);
    }
  }

  signin(BuildContext context, String number) async {
    emit(AuthenticatingState());
    print("signin");

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SMSPinPage(
                phoneNumber: number,
              ),
          fullscreenDialog: true),
    );

    if (kIsWeb) {
      await _sendWeb(context, number);
    } else {
      await _send(context, number);
    }
  }

  pining(
      {required BuildContext context,
      required String code,
      required String verificationId,
      required String phoneNumber,
      int? resendToken}) async {
    print("PINING");
    print(code);
    emit(WaitSMSState(
        verificationId: verificationId,
        resendToken: resendToken,
        loading: true));

    try {
      if (kIsWeb) {
        if (confirmationResult != null) {
          UserCredential credential = await confirmationResult!.confirm(code);
          print("B: ${credential.user?.uid}");
          FlutterSecureStorage storage = const FlutterSecureStorage();
          await storage.write(
              key: "phone_number".toUpperCase(), value: phoneNumber);
          await storage.write(
              key: "user_uid".toUpperCase(), value: credential.user?.uid);
          checking(context);
        }
      } else {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: code);
        await auth.signInWithCredential(credential).whenComplete(() async {
          FlutterSecureStorage storage = const FlutterSecureStorage();
          await storage.write(
              key: "phone_number".toUpperCase(), value: phoneNumber);
          checking(context);
        });
      }

    } catch (e) {
      print(e);
      var date = DateTime.now().millisecondsSinceEpoch;
      emit(ErrorSMSState(
          timestamp: date.toString(),
          verificationId: verificationId,
          message: "รหัสไม่ถูกต้อง",
          resendToken: resendToken,
          loading: false));
    }
    //checking(context);
  }

  _send(BuildContext context, String number) async {
    await auth.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        FlutterSecureStorage storage = const FlutterSecureStorage();
        await storage.write(key: "phone_number".toUpperCase(), value: number);
        emit(AuthenticatedState());
        checking(context);
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(UnauthenticationState());

        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        emit(WaitSMSState(
            verificationId: verificationId,
            resendToken: resendToken,
            loading: false));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        //checking(context);
      },
    );
  }

  _sendWeb(BuildContext context, String number) async {
    confirmationResult = await auth.signInWithPhoneNumber(number).then((value) {
      emit(WaitSMSState(
          verificationId: "",
          resendToken: null,
          loading: false));
      return value;
    });

    //UserCredential credential = await confirmationResult!.confirm("123456");

    //print("A: ${credential.user?.uid}");
  }

  resend(BuildContext context, String number) async {
    await _send(context, number);
  }

  resendWeb(BuildContext context, String number) async {
    await _sendWeb(context, number);
  }

  signOut(BuildContext context) async {
    await auth.signOut();
    await secureStorage.deleteAll();
    emit(UnauthenticationState());
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  Future<String?> currentUserUid() async{
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return await storage.read(key: "user_uid".toUpperCase());
  }
}
