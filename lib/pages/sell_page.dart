import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  Color primaryColor = const Color(0xFFDCDCDC);
  Color textOuterColor = const Color(0xFF2A2A2A);

  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery
        .of(context)
        .viewPadding
        .top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarColor: primaryColor,
            systemNavigationBarDividerColor: primaryColor,
            systemNavigationBarIconBrightness: Brightness.dark,
            //statusBarIconBrightness: Brightness.dark,
            //statusBarBrightness: Brightness.light,
            statusBarColor: primaryColor
          //systemNavigationBarContrastEnforced: true,
        ),
        child: Container(
            color: primaryColor,
            child: Center(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      child: Scaffold(
                        backgroundColor: primaryColor,
                        appBar: PreferredSize(
                            preferredSize: const Size.fromHeight(50.0),
                            child: Container(
                                height: 60 + statusBarHeight,
                                child: Center(
                                    child: Container(
                                        constraints:
                                        const BoxConstraints(maxWidth: 500),
                                        child: AppBar(
                                          backgroundColor: Colors
                                              .white.withOpacity(0.0),
                                          shadowColor: Colors.transparent,
                                          elevation: 0.0,
                                          surfaceTintColor: primaryColor,
                                          systemOverlayStyle:
                                          SystemUiOverlayStyle(
                                              statusBarIconBrightness:
                                              Brightness.dark,
                                              statusBarBrightness: Brightness.light,
                                              statusBarColor: primaryColor,
                                              systemNavigationBarColor: primaryColor,
                                              systemNavigationBarIconBrightness: Brightness.dark
                                          ),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .vertical(
                                              bottom: Radius.circular(22),
                                            ),
                                          ),
                                          centerTitle: true,
                                          title: Text(
                                            "การจำหน่าย",
                                            style: GoogleFonts.itim(
                                              color: textOuterColor,
                                              fontSize: 24,
                                            ),
                                          ),
                                          titleSpacing: 0,
                                          leading: IconButton(
                                            icon: Icon(
                                                FontAwesomeIcons.xmark,
                                                color: textOuterColor,
                                                size: 24),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ))))),
                        body: body(),
                      ),
                    ))))
    );
  }

  Widget loading() {
    return const Center(
        child: SpinKitThreeBounce(
          color: Colors.white,
          size: 50.0,
        ));
  }

  Widget body() {
    return Container(
      child: RefreshIndicator(
        color: primaryColor,
        child: Container(),
        //child: child(context, state),
        onRefresh: () async {
          //context.read<HomeCubit>().management(code: code);
        },
      ),
    );
  }

  // Widget child(BuildContext context, HomeManagementState state) {
  //   if (state.data != null) {
  //     if (state.data!.isNotEmpty) {
  //       return listView(state);
  //     }
  //   }
  //   return empty(context);
  // }

  Widget mapIndicator({required Color color,
    required String text,
    int? value,
    String? surfix}) {
    return Container(
      margin: EdgeInsets.only(bottom: value == null ? 4 : 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 20,
                height: 20),
            const SizedBox(width: 8),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: 17, color: Colors.black.withOpacity(0.8)),
                  ),
                  value != null
                      ? Text(
                    "$value ${surfix ?? ""}",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.5)),
                  )
                      : Container()
                ])
          ]),
    );
  }

  Widget empty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "ไม่พบข้อมูล",
            style: GoogleFonts.itim(
                color: ColorHelper.lighten(primaryColor, .3).withOpacity(0.8),
                fontSize: 26),
          ),
          Container(height: 6),
          ElevatedButton(
            onPressed: () {
              //context.read<HomeCubit>().management(code: code);
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                  ColorHelper.lighten(primaryColor, .4).withOpacity(0.1)),
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(
                  ColorHelper.lighten(primaryColor, .2).withOpacity(0.1)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.rotateRight,
                  color: ColorHelper.lighten(primaryColor, .4).withOpacity(0.8),
                  size: 18,
                ),
                Container(width: 12),
                Text(
                  "รีเฟรส",
                  style: TextStyle(
                      fontSize: 16,
                      color: ColorHelper.lighten(primaryColor, .4)
                          .withOpacity(0.8)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }


}

class IndicatorModel {
  String name;
  int amount;
  Color color;

  IndicatorModel(
      {required this.name, required this.amount, required this.color});
}