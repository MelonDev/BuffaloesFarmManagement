import 'package:buffaloes_farm_management/constants/ColorConstants.dart';
import 'package:buffaloes_farm_management/constants/StyleConstants.dart';
import 'package:buffaloes_farm_management/cubit/authentication/authentication_cubit.dart';
import 'package:buffaloes_farm_management/pages/loading/authenticate_loading_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  Color bgColor = bgButtonColor;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (ct, state) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: kBGColor,
          systemNavigationBarDividerColor: kBGColor,
        ),
        child: widgetState(ct, state),
      );
    });
  }

  Widget widgetState(BuildContext context, AuthenticationState state) {
    if (state is AuthenticatedState) {
      return Container();
    }
    if (state is AuthenticatingState) {
      return const AuthenticateLoadingPage();
    } else if (state is UnauthenticationState) {
      return Material(child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            // here the desired height
            child: AppBar(
              elevation: 0,
              backgroundColor: bgColor,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.light,
                  systemNavigationBarColor: Colors.white,
                  statusBarBrightness: Brightness.dark,
                  statusBarColor: bgColor),
            )),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: bgColor,
          child: Center(
            child:SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 800,
                      ),
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).viewPadding.top,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                color: bgColor,
                                child: Center(
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    child: Image.asset("assets/logo.png"),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 400),
                              decoration:  const BoxDecoration(
                                  color: kBGColor,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(22),
                                    bottom: Radius.circular(kIsWeb ? 22 : 0)
                                  )),
                              padding:
                              const EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: SingleChildScrollView(
                                  child: Column(children: [
                                    Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "การจัดการฟาร์มกระบือ",
                                            style: TextStyle(
                                                color: kTextBlack,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 26),
                                          ),
                                          Container(height: 0),
                                          Text(
                                            "Buffaloes Farm Management",
                                            style: GoogleFonts.itim(
                                              color: Colors.black.withOpacity(0.4),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ]),
                                    Container(
                                      //height: 48,
                                        margin: const EdgeInsets.only(top: 24),
                                        child: TextFormField(
                                          controller: numberController,
                                          style: textFieldStyle,
                                          textInputAction: TextInputAction.done,
                                          //maxLength: 10,
                                          autovalidateMode:
                                          AutovalidateMode.always,
                                          inputFormatters: [
                                            MaskedInputFormatter('###-###-####')
                                          ],
                                          validator: (value) {
                                            return null;
                                          },
                                          keyboardType: TextInputType.phone,
                                          decoration: const InputDecoration(
                                            labelText: 'เบอร์โทรศัพท์',
                                            fillColor: Colors.white,
                                            filled: true,
                                            helperText: "กรุณากรอกให้ครบ 10 หลัก",
                                            helperStyle: textFieldHelperStyle,
                                            hintStyle: hintText,
                                            labelStyle: hintText,
                                            floatingLabelStyle: labelText,
                                            contentPadding: fieldSearchPadding,
                                            enabledBorder: textFieldInputBorder,
                                            focusedBorder: textFieldInputBorder,
                                            errorBorder: textFieldErrorInputBorder,
                                            focusedErrorBorder: textFieldErrorInputBorder,
                                            errorStyle: textFieldErrorStyle,
                                          ),
                                        )),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 1,
                                      height: 40,
                                      margin: const EdgeInsets.only(top: 20),
                                      child: OutlinedButton(
                                        style: navyButtonStyle,
                                        onPressed: () {
                                          if (numberController.text.length == 12) {
                                            String x =
                                            numberController.text.replaceAll("-", "");
                                            String number = x.replaceRange(0, 1, "+66");
                                            context
                                                .read<AuthenticationCubit>()
                                                .signin(context, number);
                                          } else {}
                                        },
                                        child: const Text(
                                          'เข้าสู่ระบบ',
                                          style: whiteTextButton,
                                        ),
                                      ),
                                    ),
                                    Container(height: 12),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    Container(height: 12),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 20),
                                        child: const Text(
                                          "พบปัญหาการเข้าสู่ระบบ",
                                          //style: blackTextButton,
                                        ),
                                      ),
                                    ),
                                  ])),
                            )
                          ]))),
            )
          ),)
        ),
      ));
    } else {
      return const AuthenticateLoadingPage();
    }
  }
}
