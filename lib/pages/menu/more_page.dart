import 'package:buffaloes_farm_management/components/MessagesDialog.dart';
import 'package:buffaloes_farm_management/cubit/authentication/authentication_cubit.dart';
import 'package:buffaloes_farm_management/cubit/home/home_cubit.dart';
import 'package:buffaloes_farm_management/pages/menu/farming_page.dart';
import 'package:buffaloes_farm_management/pages/menu/financial_page.dart';
import 'package:buffaloes_farm_management/pages/menu/technical_support_page.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:buffaloes_farm_management/tools/NavigatorHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../authentication/login_page.dart';

class MorePage extends StatelessWidget {
  MorePage({Key? key}) : super(key: key);

  Color primaryColor = Colors.teal;
  ScrollController? scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  body(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        color: primaryColor,
        child: child(context),
        onRefresh: () async {
          context.read<HomeCubit>().notification();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) =>  LoginPage()),
                  (Route<dynamic> route) => false);
        },
      ),
    );
  }

  loading() {
    return Center(
      child: SpinKitThreeBounce(
        color: ColorHelper.lighten(primaryColor).withOpacity(0.7),
        size: 50.0,
      ),
    );
  }

  Widget child(BuildContext context) {
    return ListView(
      padding:
      const EdgeInsets.only(left: 20, right: 20, top: 34, bottom: 20),
      children: [
        button(
          context,
          "การทำฟาร์ม",
          icon: FontAwesomeIcons.leaf,
          color: ColorHelper.lighten(primaryColor, .45).withOpacity(0.99),
          onTap: () async {
            Navigator.of(context).push(
              NavigatorHelper.slide(
                  const FarmingPage()
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        button(
          context,
          "การเงินของฟาร์ม",
          icon: FontAwesomeIcons.institution,
          color: ColorHelper.lighten(primaryColor, .45).withOpacity(0.99),
          onTap: () async {
            Navigator.of(context).push(
              NavigatorHelper.slide(
                const FinancialPage()
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        button(
          context,
          "การสนับสนุนทางเทคนิค",
          icon: FontAwesomeIcons.solidEnvelope,
          color: ColorHelper.lighten(primaryColor, .45).withOpacity(0.99),
          onTap: () async {
            messageDialog(context, title: "การติดต่อ", message: "sureeporn.sa@up.ac.th",
                function: () {
                  //context.read<HomeCubit>().management();
                });
            // Navigator.of(context).push(
            //   NavigatorHelper.slide(
            //       const TechnicalSupportPage()
            //   ),
            // );
          },
        ),
        const SizedBox(height: 12),
        button(
          context,
          "ลงชื่อออก",
          icon: FontAwesomeIcons.doorOpen,
          color: ColorHelper.lighten(primaryColor, .45).withOpacity(0.99),
          onTap: () async {
            context.read<AuthenticationCubit>().signOut(context);
          },
        )
      ],
    );
  }

  Widget button(BuildContext context,String title, {Function? onTap, IconData? icon, Color? color}) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 64
      ),
        child: ElevatedButton(
          onPressed: () {
            onTap?.call();
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
                ColorHelper.lighten(color ?? primaryColor, .4)
                    .withOpacity(0.1)),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(
                ColorHelper.lighten(color ?? primaryColor, .45)
                    .withOpacity(0.15)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 0),
                  Icon(
                    icon ?? FontAwesomeIcons.ellipsis,
                    color: Colors.white.withOpacity(0.99),
                    size: 22,
                  ),
                  Container(width: 16),
                  Expanded(child: Container(
                    padding: EdgeInsets.only(top: 10,bottom: 10),
                    child: Text(
                      title,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white.withOpacity(0.99)),
                    ),
                  )),

                ],
              )),
        ));
  }
}
