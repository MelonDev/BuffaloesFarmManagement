import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmingPage extends StatefulWidget {
  const FarmingPage({Key? key}) : super(key: key);

  @override
  _FarmingPageState createState() => _FarmingPageState();
}

class _FarmingPageState extends State<FarmingPage> {

  static RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  Color primaryColor = Colors.teal;

  load() async {}

  onSubmit() async {}

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarDividerColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: Container(
          color: Colors.black,
          child: Scaffold(
            backgroundColor: primaryColor.withOpacity(0.14),
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
                child: Container(
                  height: 60 + statusBarHeight,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: AppBar(
                        backgroundColor: primaryColor,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: primaryColor,
                        elevation: 0.0,
                        centerTitle: true,
                        systemOverlayStyle: SystemUiOverlayStyle(
                            statusBarIconBrightness: Brightness.light,
                            systemNavigationBarColor: Colors.white,
                            statusBarBrightness: Brightness.dark,
                            statusBarColor: primaryColor),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(22),
                          ),
                        ),
                        leading: IconButton(
                          icon: const Icon(FontAwesomeIcons.xmark,
                              color: Colors.white, size: 24),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        title: Text(
                          "การทำฟาร์ม",
                          style: GoogleFonts.itim(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        //actions: actionsWidget(state),
                      ),
                    ),
                  ),
                )),
            // floatingActionButton: !isLandscapeMode()
            //     ? (isShowFab(state)
            //     ? FloatingActionButton(
            //   shape: const CircleBorder(),
            //   onPressed: () async {
            //     if (state is HomeFarmState) {
            //       // bool result = await Navigator.push(
            //       //   context,
            //       //   MaterialPageRoute(
            //       //       builder: (context) => const AddBuffPage(),
            //       //       fullscreenDialog: true),
            //       // );
            //     }
            //     if (state is HomeManagementState) {
            //       await Navigator.of(context).push(
            //         NavigatorHelper.slide(
            //           AddBuffPage(onComplete: (value){
            //             TabModel item = tabs[currentTab];
            //             item.onTap?.call();
            //           },),
            //         ),
            //       );
            //     }
            //   },
            //   elevation: 20,
            //   //heroTag: "${tabTag(state)}_TAG",
            //   backgroundColor: tabColor(state),
            //   child: const Icon(
            //     FontAwesomeIcons.plus,
            //     color: Colors.white,
            //   ),
            // )
            //     : null)
            //     : null,
            body: body(context),
          )),
    );
  }

  body(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        color: primaryColor,
        child: child(context),
        onRefresh: () async {
          //context.read<HomeCubit>().notification();
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
      padding: const EdgeInsets.only(left: 20, right: 20, top: 34, bottom: 20),
      children: [
        button(
          context,
          "ประสิทธิภาพการผลิต",
          icon: FontAwesomeIcons.gears,
          color: ColorHelper.lighten(primaryColor, .45).withOpacity(0.99),
          onTap: () async {

          },
        ),
        const SizedBox(height: 12),
        button(
          context,
          "สุขภาพและอัตราการตาย",
          icon: FontAwesomeIcons.leaf,
          color: ColorHelper.lighten(primaryColor, .45).withOpacity(0.99),
          onTap: () async {

          },
        ),
        const SizedBox(height: 12),
        button(
          context,
          "ประสิทธิภาพการผสมพันธุ์",
          icon: FontAwesomeIcons.percent,
          color: ColorHelper.lighten(primaryColor, .45).withOpacity(0.99),
          onTap: () async {

          },
        ),
        const SizedBox(height: 12),
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
