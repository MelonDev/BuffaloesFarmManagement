import 'package:buffaloes_farm_management/models/financial_model.dart';
import 'package:buffaloes_farm_management/pages/add_financial_page.dart';
import 'package:buffaloes_farm_management/service/FarmService.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FinancialPage extends StatefulWidget {
  const FinancialPage({Key? key}) : super(key: key);

  @override
  _FinancialPageState createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage> {
  static RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  Color primaryColor = Colors.teal;

  int position = 0;
  List<FinancialModel>? model;

  double totalIncome = 0.00;
  double totalExpense = 0.00;

  List<FinancialModel> filter(
      List<FinancialModel> transactions, FinancialType type) {
    return transactions
        .where((transaction) => transaction.type == type.name.toUpperCase())
        .toList();
  }

  double calculateTotal(List<FinancialModel> transactions) {
    return transactions.fold(
        0.0,
        (sum, transaction) =>
            sum +
            (double.tryParse(transaction.price ?? "0.0")?.toDouble() ?? 0.0));
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    model = await FarmService.financial();
    totalIncome = calculateTotal(filter(model ?? [], FinancialType.income));
    totalExpense = calculateTotal(filter(model ?? [], FinancialType.expense));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarDividerColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark),
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
                          "การเงินของฟาร์ม",
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
            floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () async {
                bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddFinancialPage(
                            type: position == 0
                                ? FinancialType.income
                                : FinancialType.expense,
                          ),
                      fullscreenDialog: true),
                );
                load();
              },
              elevation: 20,
              backgroundColor: Colors.white,
              child: Icon(
                FontAwesomeIcons.plus,
                color: primaryColor,
              ),
            ),
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
          load();
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

  Widget detail(BuildContext context) {
    double total = totalIncome - totalExpense;
    double wid = MediaQuery.of(context).size.width - 40 - 4;
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 4,
          ),
          detailBox(context,
              width: wid / 3, title: "รายรับ", value: totalIncome),
          Container(height: 2, width: 200, color: primaryColor),
          detailBox(context,
              width: wid / 3,
              title: total >= 0 ? "กำไร" : "ขาดทุน",
              value: total.abs()),
          Container(height: 2, width: 200, color: primaryColor),
          detailBox(context,
              width: wid / 3, title: "รายจ่าย", value: totalExpense),
        ],
      ),
    );
  }

  Widget detailBox(BuildContext context,
      {required double width, required String title, required double value}) {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: primaryColor, fontSize: 20),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(color: Colors.white, fontSize: 20),
          )
        ],
      ),
    );
  }

  Widget child(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 20),
      children: [
        detail(context),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tabBar(
              initialValue: position,
              children: {
                0: buildSegment("รายรับ", 0, position),
                1: buildSegment("รายจ่าย", 1, position),
              },
              callback: (value) {
                setState(() {
                  position = value;
                });
                // setState(() async {
                //   model.sick = value;
                //   await FarmService.updateSickBuff(
                //       id: buff!.id, sick: model.sick ?? false);
                //   await onLoad();
                // });
              },
            ),
          ],
        ),
        SizedBox(height: 10,),
        if (position == 0)
          ...filter(model ?? [], FinancialType.income)
              .map((model) => card(context, model)),
        if (position == 1)
          ...filter(model ?? [], FinancialType.expense)
              .map((model) => card(context, model))
      ],
    );
  }

  Widget tabBar(
      {required Map<int, Widget> children,
      required int initialValue,
      required Function(int) callback}) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 0, right: 0),
      padding: const EdgeInsets.all(4),
      child: CustomSlidingSegmentedControl<int>(
        decoration: BoxDecoration(
          color: ColorHelper.lighten(Colors.white.withOpacity(0.1), .14),
          borderRadius: BorderRadius.circular(10),
        ),
        //thumbColor: Colors.white,
        thumbDecoration: BoxDecoration(
          color: ColorHelper.lighten(Colors.white, .0).withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.0),
              blurRadius: 1.0,
              spreadRadius: 1.0,
              offset: const Offset(
                0.0,
                2.0,
              ),
            ),
          ],
        ),
        innerPadding: const EdgeInsets.all(0),
        initialValue: initialValue,
        children: children,
        onValueChanged: callback,
      ),
    );
  }

  Widget buildSegment(String text, int number, int selectedValue) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: selectedValue == number ? 18 : 16,
          color: selectedValue == number
              ? Colors.black
              : Colors.white.withOpacity(0.90),
        ),
      ),
    );
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

  String getDate(String? date) {
    if (date != null) {
      DateTime tempDate = DateFormat("yyyy-MM-dd").parse(date);
      DateFormat format = DateFormat("dd MMMM yyyy");
      var formattedDate = format.format(tempDate);
      return "${tempDate.day} ${getMonthName(tempDate.month - 1)} ${tempDate.year + 543}";
    }
    return "ไม่ระบุ";
  }

  Widget card(BuildContext context, FinancialModel model) {
    IconData icon = model.type == FinancialType.income.name.toUpperCase() ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown;

    String title = model.name ?? "";
    String message = "${model.price} บาท";
    String subMessage = getDate(model.date);
    //String duration = getDuration(model.notify_datetime);
    return Material(
        color: Colors.transparent,
        child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.only(bottom: 2, top: 4, left: 2),
            decoration: BoxDecoration(
                // color: ColorHelper.lighten(primaryColor, .5)
                //     .withOpacity(0.1),
                color: primaryColor,
                borderRadius: BorderRadius.circular(12)),
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
                    color:
                        Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: ColorHelper.darken(primaryColor, .2).withOpacity(0.9),
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
                          title,
                          style: GoogleFonts.itim(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 22),
                        ),
                        const SizedBox(width: 0, height: 0),
                        Row(
                          children: [
                            Text(
                              message ?? "",
                              style: GoogleFonts.itim(
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                            // Container(
                            //     decoration: BoxDecoration(
                            //       color: ColorHelper.lighten(primaryColor, .3)
                            //           .withOpacity(0.25),
                            //       borderRadius: BorderRadius.circular(14),
                            //     ),
                            //     margin: const EdgeInsets.only(left: 8),
                            //     padding: const EdgeInsets.only(
                            //         left: 10, right: 10, top: 2, bottom: 2),
                            //     child: Text(
                            //       duration ?? "",
                            //       style: GoogleFonts.itim(
                            //           color: ColorHelper.lighten(
                            //                   primaryColor, .42)
                            //               .withOpacity(0.96),
                            //           fontSize: 14),
                            //     ))
                          ],
                        ),
                        const SizedBox(width: 0, height: 1),
                        Row(
                          children: [
                            Text(
                              subMessage ?? "",
                              style: GoogleFonts.itim(
                                  color: Colors.white
                                      .withOpacity(0.9),
                                  fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(width: 0, height: 4),
                      ]),
                )
              ],
            )));
  }
}
