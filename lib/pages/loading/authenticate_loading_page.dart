import 'package:buffaloes_farm_management/constants/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AuthenticateLoadingPage extends StatelessWidget {
  const AuthenticateLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: bgButtonColor,
          systemNavigationBarDividerColor: bgButtonColor,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          statusBarColor: bgButtonColor
          //systemNavigationBarContrastEnforced: true,
          ),
      child: Material(
        child: Scaffold(
          backgroundColor: bgButtonColor,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              // here the desired height
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: bgButtonColor,
                  statusBarIconBrightness: Brightness.light,
                ),
              )),
          body: Container(
            decoration: const BoxDecoration(
              color: bgButtonColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: const Center(
              child: SpinKitThreeBounce(
                color: Colors.white,
                size: 50.0,
              )
            )
          ),
        ),
      ),
    );
  }
}
