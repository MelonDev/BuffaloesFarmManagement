import 'package:age_calculator/age_calculator.dart';
import 'package:buffaloes_farm_management/components/MessagesDialog.dart';
import 'package:buffaloes_farm_management/constants/ColorConstants.dart';
import 'package:buffaloes_farm_management/models/activity/ActivityFunctionModel.dart';
import 'package:buffaloes_farm_management/models/activity/BaseActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/BreedingActivityModel.dart';
import 'package:buffaloes_farm_management/models/BuffModel.dart';
import 'package:buffaloes_farm_management/models/activity/DewormingActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/DiseaseTreatmentActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/ReturnEstrusActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/VaccineInjectionActivityModel.dart';
import 'package:buffaloes_farm_management/pages/activities/induction_page.dart';
import 'package:buffaloes_farm_management/service/FarmService.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:buffaloes_farm_management/tools/NavigatorHelper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'activities/breeding_page.dart';
import 'activities/deworming_page.dart';
import 'activities/disease_treatment_page.dart';
import 'activities/return_estrus_page.dart';
import 'activities/vaccine_injection_page.dart';

class BuffDetailPage extends StatefulWidget {
  BuffDetailPage({Key? key, required this.id, this.buff}) : super(key: key);

  String id;
  BuffModel? buff;

  @override
  _BuffDetailPageState createState() => _BuffDetailPageState();
}

class _BuffDetailPageState extends State<BuffDetailPage> {
  Color primaryColor = Colors.pink;
  Color backgroundPrimaryColor = const Color(0xFF050505);

  BuffModel? buff;
  bool initialLoading = true;


  @override
  void initState() {
    super.initState();
    if (widget.buff != null) {
      buff = widget.buff;
    }
    onLoad();
  }

  onLoad() async {
    BuffModel? buff = await FarmService.buff(widget.id);
    setState(() {
      initialLoading = false;
      this.buff = buff;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: backgroundPrimaryColor,
        systemNavigationBarDividerColor: backgroundPrimaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        //systemNavigationBarContrastEnforced: true,
      ),
      child: Container(
        color: backgroundPrimaryColor,
        child: Center(
          child: Container(
              constraints:
              const BoxConstraints(maxWidth: 500),
            child: Scaffold(
              backgroundColor: backgroundPrimaryColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0.0,
                surfaceTintColor: Colors.transparent,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.light,
                    statusBarColor: backgroundPrimaryColor),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(22),
                  ),
                ),
                centerTitle: true,
                title: Text(
                  "รายละเอียด",
                  style: GoogleFonts.itim(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                titleSpacing: 0,
                leading: IconButton(
                  icon: const Icon(FontAwesomeIcons.xmark,
                      color: Colors.white, size: 24),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                actions: [
                  Container(
                    padding: const EdgeInsets.only(right: 6),
                    child: IconButton(
                      icon: const Icon(FontAwesomeIcons.penToSquare,
                          color: Colors.white, size: 22),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () async {
                  bottomDialog(
                    context,
                    height: 320,
                    Container(
                      child: Center(
                        child: Container(
                            constraints:
                            const BoxConstraints(maxWidth: 500),
                          child: ListView(
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 16, left: 6),
                                child: Text(
                                  "เลือกการจัดการ",
                                  style: GoogleFonts.itim(
                                      color: ColorHelper.lighten(Colors.white, .2)
                                          .withOpacity(0.86),
                                      fontSize: 28),
                                ),
                              ),
                              Row(children: [
                                Expanded(
                                  flex: 49,
                                  child: largeButton(
                                    "การเหนี่ยวนำ",
                                    icon: FontAwesomeIcons.venusMars,
                                    color: primaryColor,
                                    onTap: () async {
                                      await Navigator.of(context)
                                          .push(NavigatorHelper.slide(InductionPage(
                                        buffId: widget.id,
                                      )));
                                      onLoad();
                                    },
                                  ),
                                ),
                                Expanded(flex: 2, child: Container()),
                                Expanded(
                                  flex: 49,
                                  child: largeButton(
                                    "การฉีดวัคซีน",
                                    icon: FontAwesomeIcons.crutch,
                                    color: Colors.blue,
                                    onTap: () async {
                                      await Navigator.of(context)
                                          .push(NavigatorHelper.slide(VaccineInjectionPage(
                                        buffId: widget.id,
                                      )));
                                      onLoad();
                                    },
                                  ),
                                )
                              ]),
                              const SizedBox(height: 8),
                              Row(children: [
                                Expanded(
                                  flex: 49,
                                  child: largeButton(
                                    "การถ่ายพยาธิ",
                                    icon: FontAwesomeIcons.prescriptionBottleMedical,
                                    color: Colors.amber,
                                    onTap: () async {
                                      await Navigator.of(context)
                                          .push(NavigatorHelper.slide(DewormingPage(
                                        buffId: widget.id,
                                      )));
                                      onLoad();
                                    },
                                  ),
                                ),
                                Expanded(flex: 2, child: Container()),
                                Expanded(
                                  flex: 49,
                                  child: largeButton(
                                    "การรักษาโรค",
                                    icon: FontAwesomeIcons.virusCovid,
                                    color: Colors.green,
                                    onTap: () async {
                                      await Navigator.of(context)
                                          .push(NavigatorHelper.slide(DiseaseTreatmentPage(
                                        buffId: widget.id,
                                      )));
                                      onLoad();
                                    },
                                  ),
                                )
                              ]),
                              const SizedBox(height: 26),
                            ],
                          )
                        )
                      ),
                    ),
                  );
                },
                elevation: 20,
                backgroundColor: const Color(0xFFF0F0F0),
                child: Icon(FontAwesomeIcons.plus, color: backgroundPrimaryColor),
              ),
              body: buff == null
                  ? const Center(
                  child: SpinKitThreeBounce(
                    color: Colors.white,
                    size: 50.0,
                  ))
                  : body(context, buff!),
            )
          )
        ),
      ),
    );
  }

  Widget largeButton(String title,
      {Function? onTap, IconData? icon, Color? color}) {
    return SizedBox(
        height: 100, // <-- Your height
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onTap?.call();
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
                ColorHelper.lighten(color ?? primaryColor, .4)
                    .withOpacity(0.1)),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(
                ColorHelper.lighten(color ?? primaryColor, .05)
                    .withOpacity(0.6)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    width: 0,
                    height: 10,
                  ),
                  Icon(
                    icon ?? FontAwesomeIcons.ellipsis,
                    color: ColorHelper.lighten(color ?? primaryColor, .52)
                        .withOpacity(0.8),
                    size: 34,
                  ),
                  const SizedBox(
                    width: 16,
                    height: 14,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 20,
                        color: ColorHelper.lighten(color ?? primaryColor, .52)
                            .withOpacity(0.8)),
                  )
                ],
              )),
        ));
  }

  Widget button(String title, {Function? onTap, IconData? icon, Color? color}) {
    return SizedBox(
        height: 48, // <-- Your height
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onTap?.call();
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
                ColorHelper.lighten(color ?? primaryColor, .4)
                    .withOpacity(0.1)),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(
                ColorHelper.lighten(color ?? primaryColor, .12)
                    .withOpacity(0.3)),
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
                    color: ColorHelper.lighten(color ?? primaryColor, .42)
                        .withOpacity(0.8),
                    size: 18,
                  ),
                  Container(width: 16),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 20,
                        color: ColorHelper.lighten(color ?? primaryColor, .42)
                            .withOpacity(0.8)),
                  )
                ],
              )),
        ));
  }

  card(BuildContext context,
      {String? message,
      String? subMessage,
      bool active = false,
      BuffActivityLog log = BuffActivityLog.unknown,
      ActivityFunctionModel? function}) {
    IconData icon = active ? getActivityLogIcon(log) : FontAwesomeIcons.check;
    Color color = getActivityLogColor(log);

    return GestureDetector(
      child: Material(
          color: Colors.transparent,
          child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.only(bottom: 12, top: 4, left: 2),
              decoration: BoxDecoration(
                  // color: ColorHelper.lighten(primaryColor, .5)
                  //     .withOpacity(0.1),
                  color: active
                      ? ColorHelper.lighten(color, .1).withOpacity(0.65)
                      : ColorHelper.lighten(color, .3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18)),
              //width: 10,
              //height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.only(
                        bottom: 0, top: 0, left: 0, right: 0),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    decoration: BoxDecoration(
                      color: active
                          ? ColorHelper.lighten(color, .36).withOpacity(0.7)
                          : ColorHelper.lighten(color, .1).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      size: 19,
                      color: active
                          ? ColorHelper.darken(color, .26).withOpacity(0.8)
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 0, left: 12, right: 12),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getActivityLogTitle(log),
                            style: GoogleFonts.itim(
                                color: active
                                    ? ColorHelper.lighten(color, .46)
                                        .withOpacity(0.9)
                                    : ColorHelper.lighten(color, .2)
                                        .withOpacity(0.7),
                                fontSize: 24),
                          ),
                          const SizedBox(width: 0, height: 0),
                          Row(
                            children: [
                              Text(
                                message ?? "",
                                style: GoogleFonts.itim(
                                    color: active
                                        ? ColorHelper.lighten(color, .46)
                                            .withOpacity(0.7)
                                        : ColorHelper.lighten(color, .46),
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(width: 0, height: 1),
                          Row(
                            children: [
                              Text(
                                subMessage ?? "",
                                style: GoogleFonts.itim(
                                    color: active
                                        ? ColorHelper.lighten(color, .46)
                                            .withOpacity(0.7)
                                        : ColorHelper.lighten(color, .46),
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(
                              width: 0,
                              height: active && (function != null) ? 12 : 2),
                          active && function != null
                              ? ElevatedButton(
                                  onPressed: function.function,
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        ColorHelper.darken(color, .4)
                                            .withOpacity(0.1)),
                                    elevation: MaterialStateProperty.all(0),
                                    backgroundColor: MaterialStateProperty.all(
                                        ColorHelper.darken(color, .4)
                                            .withOpacity(0.5)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        function.icon,
                                        color: ColorHelper.lighten(
                                            color, .4)
                                            .withOpacity(0.8),
                                        size: 18,
                                      ),
                                      Container(width: 12),
                                      Text(
                                        function.name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: ColorHelper.lighten(
                                                color, .4)
                                                .withOpacity(0.8)),
                                      )
                                    ],
                                  ),
                                )
                              : Container()
                        ]),
                  )
                ],
              ))),
      onTap: () {},
    );
  }

  Widget body(BuildContext context, BuffModel model) {
    print("body");
    List<Widget> activeWidget = [];
    List<Widget> activities = [];
    for (var item in model.history) {
      Widget? w = getActivityLogWidget(context, item, active: false);
      Widget? wA = getActivityLogWidget(context, item, active: true);
      if (w != null) {
        activities.add(w);
      }
      if (wA != null) {
        activeWidget.add(wA);
      }
    }

    return Container(
      child: RefreshIndicator(
        color: primaryColor,
        child: Container(
          decoration: const BoxDecoration(
            //color: kBGColor.withOpacity(0.04),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(22),
              bottom: Radius.circular(22),
            ),
          ),
          padding: const EdgeInsets.only(
            left: 0,
            right: 0,
          ),
          //height: 460,
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
          //height: MediaQuery.of(context).size.height,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 72, top: 12),
            children: <Widget>[
              imageArea(),
              const SizedBox(width: 0, height: 12),
              titleArea(model),
              const SizedBox(width: 0, height: 8),
              columnBody(context, model),
              //card(context, model, log: BuffActivityLog.breeding),
              //card(context, model, log: BuffActivityLog.returnEstrus),
              //card(context, model, log: BuffActivityLog.vaccineInjection),
              //card(context, model, log: BuffActivityLog.deworming),
              //card(context, model, log: BuffActivityLog.diseaseTreatment),
            ]
              ..addAll([
                initialLoading
                    ? const SizedBox(width: 0, height: 8)
                    : Container(),
                initialLoading
                    ? Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(22),
                          ),
                        ),
                        height: 180,
                        child: const Center(
                            child: SpinKitThreeBounce(
                          color: Colors.white,
                          size: 40.0,
                        )))
                    : Container()
              ])
              ..addAll([
                activeWidget.isNotEmpty
                    ? const SizedBox(width: 0, height: 8)
                    : Container(),
                activeWidget.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(left: 6),
                        child: Text(
                          "สถานะปัจจุบัน",
                          style: GoogleFonts.itim(
                              color: Colors.white.withOpacity(0.96),
                              fontSize: 24),
                        ),
                      )
                    : Container(),
                activeWidget.isNotEmpty
                    ? const SizedBox(width: 0, height: 4)
                    : Container(),
              ])
              ..addAll(activeWidget)
              ..addAll([
                activities.isNotEmpty
                    ? const SizedBox(width: 0, height: 8)
                    : Container(),
                activities.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(left: 6),
                        child: Text(
                          "ประวัติ",
                          style: GoogleFonts.itim(
                              color: Colors.white.withOpacity(0.96),
                              fontSize: 24),
                        ),
                      )
                    : Container(),
                activities.isNotEmpty
                    ? const SizedBox(width: 0, height: 4)
                    : Container(),
              ])
              ..addAll(activities),
          ),
        ),
        onRefresh: () async {
          await onLoad();
          //context.read<HomeCubit>().management();
        },
      ),
    );
  }

  Widget columnBody(BuildContext context, BuffModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          flex: 90, // 20%
          child: Container(
            margin: const EdgeInsets.only(left: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                titleHeader("เบอร์หู:", model.tag ?? "ไม่ทราบ"),
                const SizedBox(width: 0, height: 6),
                titleHeader("พ่อ:", model.father_name ?? "-"),
                const SizedBox(width: 0, height: 6),
                titleHeader("แม่:", model.mother_name ?? "-"),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1, // 60%
          child: Container(
            height: 140,
            width: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    ColorHelper.lighten(primaryColor, .2).withOpacity(0.4),
                    Colors.transparent
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 1.5),
                  stops: const [0.2, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
        ),
        Expanded(
          flex: 100, // 20%
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                titleHeader("วันเดือนปีเกิด:", getBirthDate(model.birth_date)),
                const SizedBox(width: 0, height: 6),
                titleHeader("อายุ:", getAge(model.birth_date)),
                const SizedBox(width: 0, height: 6),
                titleHeader("แหล่งที่มา:", model.source ?? "-"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget titleHeader(String title, String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: GoogleFonts.itim(
              color: ColorHelper.lighten(primaryColor, .2).withOpacity(0.86),
              fontSize: 13),
        ),
        Container(
          height: 0,
        ),
        Text(
          message,
          style: GoogleFonts.itim(
              color: Colors.white.withOpacity(0.96), fontSize: 16),
        ),
      ],
    );
  }

  Widget titleArea(BuffModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 6, height: 0),
        Text(
          model.name ?? "",
          style: GoogleFonts.itim(
              color: Colors.white.withOpacity(0.96), fontSize: 36),
        ),
        const SizedBox(width: 12, height: 0),
        Container(
            decoration: BoxDecoration(
              color: ColorHelper.lighten(primaryColor).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.only(left: 0, right: 0, top: 6, bottom: 0),
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
            child: Text(
              getGenderName(model.gender),
              style: GoogleFonts.itim(
                  color: ColorHelper.lighten(primaryColor, .42), fontSize: 16),
            )),
      ],
    );
  }

  Widget imageArea() {
    return buff?.image_url != null
        ? Hero(
            tag: "${widget.id}_IMAGE",
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(24)),
              ),
              margin: const EdgeInsets.only(top: 0),
              child: Stack(
                children: [
                  buff?.image_url != null
                      ? image(buff?.id ?? "", buff?.image_url)
                      : Container(),
                ],
              ),
            ),
          )
        : Container();
  }

  Widget image(String id, String? url) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: CachedNetworkImage(
          imageUrl: url ?? "",
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                //colorFilter: const ColorFilter.mode(Colors.red, BlendMode.colorBurn)
              ),
            ),
          ),
          placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
                  color: ColorHelper.lighten(primaryColor).withOpacity(0.2))),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              color: ColorHelper.lighten(primaryColor).withOpacity(0.4),
            ),
            child: Center(
                child: Icon(FontAwesomeIcons.fileImage,
                    size: 34, color: Colors.white.withOpacity(0.5))),
          ),
        ));
  }

  String getBirthDate(String? birthDate) {
    if (birthDate != null) {
      DateTime tempDate = DateFormat("yyyy-MM-dd").parse(birthDate);
      DateFormat format = DateFormat("dd MMMM yyyy");
      var formattedDate = format.format(tempDate);
      return "${tempDate.day} ${getMonthName(tempDate.month - 1)} ${tempDate.year + 543}";
    }
    return "ไม่ระบุ";
  }

  String getAge(String? birthDate) {
    if (birthDate != null) {
      DateTime tempDate = DateFormat("yyyy-MM-dd").parse(birthDate);
      DateDuration duration =
          AgeCalculator.age(tempDate, today: DateTime.now());
      if (duration.years == 0 && duration.months == 0) {
        return "วันนี้";
      } else if (duration.years == 0 && duration.months != 0) {
        return "${duration.months} เดือน";
      } else if (duration.years != 0 && duration.months == 0) {
        return "${duration.years} ปี";
      } else {
        return "${duration.years} ปี ${duration.months} เดือน";
      }
    }
    return "ไม่ระบุ";
  }

  Widget? getActivityLogWidget(BuildContext context, BaseActivityModel item,
      {bool active = false}) {
    if (item is BreedingActivityModel) {
      return item.status == active
          ? card(context,
              message: "กลับสัด: ${getBirthDate(item.date)}",
              subMessage:
                  "รูปแบบ: ${item.artificial_insemination! ? "ผสมเทียม" : "ผสมจริง"}",
              active: active,
              log: BuffActivityLog.breeding,
              function: ActivityFunctionModel(
                  name: "เริ่มต้นกลับสัด",
                  icon: FontAwesomeIcons.stethoscope,
                  function: () async {
                    await Navigator.of(context)
                        .push(NavigatorHelper.slide(ReturnEstrusPage(
                      buffId: widget.id,
                    )));
                    onLoad();
                  }))
          : null;
    } else if (item is ReturnEstrusActivityModel) {
      return item.status == active
          ? card(context,
              message:
              "คาดว่าจะคลอด: ${getBirthDate(item.date)}",
              subMessage: item.end_date != null ? "ถึง: ${getBirthDate(item.end_date)}" : null,
              active: active,
              log: BuffActivityLog.returnEstrus)
          : null;
    } else if (item is VaccineInjectionActivityModel) {
      return item.status == active
          ? card(context,
              message: "ชนิด: ${getVaccineName(item)}",
              subMessage:
                  "ครั้งต่อไป: ${item.date != null ? getBirthDate(item.date) : "-"}",
              active: active,
              log: BuffActivityLog.vaccineInjection)
          : null;
    } else if (item is DewormingActivityModel) {
      return item.status == active
          ? card(context,
              message: "ชนิด: ${item.name}",
              subMessage:
                  "ครั้งต่อไป: ${item.next_deworming_date != null ? getBirthDate(item.next_deworming_date) : "-"}",
              active: active,
              log: BuffActivityLog.deworming)
          : null;
    } else if (item is DiseaseTreatmentActivityModel) {
      return item.status == active
          ? card(context,
              message: "อาการ: ${item.symptom}",
              subMessage: "ยาที่ใช้: ${item.drugs ?? "-"}",
              active: active,
              log: BuffActivityLog.diseaseTreatment,
          function: ActivityFunctionModel(
          name: "อัปเดตสถานะ",
          icon: FontAwesomeIcons.stethoscope,
          function: () async {

            //onLoad();
          })
      )
          : null;
    } else {
      return null;
    }
  }

  String getGenderName(String? gender) {
    if (gender != null) {
      if (gender == "MALE") {
        return "เพศผู้";
      }
      if (gender == "FEMALE") {
        return "เพศเมีย";
      }
    }
    return "";
  }

  String getMonthName(int month) {
    List<String> MONTHS = const [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม'
    ];
    return MONTHS[month];
  }

  IconData getActivityLogIcon(BuffActivityLog log) {
    switch (log) {
      case BuffActivityLog.breeding:
        {
          return FontAwesomeIcons.venusMars;
        }
      case BuffActivityLog.returnEstrus:
        {
          return FontAwesomeIcons.stethoscope;
        }
      case BuffActivityLog.vaccineInjection:
        {
          return FontAwesomeIcons.crutch;
        }
      case BuffActivityLog.deworming:
        {
          return FontAwesomeIcons.prescriptionBottleMedical;
        }
      case BuffActivityLog.diseaseTreatment:
        {
          return FontAwesomeIcons.virusCovid;
        }
      default:
        {
          return FontAwesomeIcons.ellipsis;
        }
    }
  }

  Color getActivityLogColor(BuffActivityLog log) {
    switch (log) {
      case BuffActivityLog.breeding:
        {
          return Colors.pink;
        }
      case BuffActivityLog.returnEstrus:
        {
          return Colors.indigo;
        }
      case BuffActivityLog.vaccineInjection:
        {
          return Colors.blue;
        }
      case BuffActivityLog.deworming:
        {
          return Colors.yellow;
        }
      case BuffActivityLog.diseaseTreatment:
        {
          return Colors.green;
        }
      default:
        {
          return Colors.blueGrey;
        }
    }
  }

  String getActivityLogTitle(BuffActivityLog log) {
    switch (log) {
      case BuffActivityLog.breeding:
        {
          return "ผสมพันธุ์";
        }
      case BuffActivityLog.returnEstrus:
        {
          return "ตั้งท้อง";
        }
      case BuffActivityLog.vaccineInjection:
        {
          return "ฉีดวัคซีน";
        }
      case BuffActivityLog.deworming:
        {
          return "ถ่ายพยาธิ";
        }
      case BuffActivityLog.diseaseTreatment:
        {
          return "รักษาโรค";
        }
      default:
        {
          return "ไม่พบชื่อ";
        }
    }
  }

  String getVaccineName(VaccineInjectionActivityModel model) {
    switch (model.vaccine_name) {
      case "Foot-mouth Disease":
        {
          return "ปากเท้าเปื่อย";
        }
      case "Swollen Neck Disease":
        {
          return "คอบวม";
        }
      case "Anthrax Disease":
        {
          return "แอนแทรกซ์";
        }
      case "Blackleg Disease":
        {
          return "แบลคเลก (ไข้ขา)";
        }
      case "Brucellosis Disease":
        {
          return "แท้งติดต่อ";
        }
      case "Other":
        {
          return model.vaccine_name ?? "";
        }
      default:
        {
          return "ไม่พบชื่อ";
        }
    }
  }
}

enum BuffActivityLog {
  breeding,
  returnEstrus,
  vaccineInjection,
  deworming,
  diseaseTreatment,
  unknown
}
