import 'package:age_calculator/age_calculator.dart';
import 'package:buffaloes_farm_management/components/MelonStickyListView.dart';
import 'package:buffaloes_farm_management/cubit/home/home_cubit.dart';
import 'package:buffaloes_farm_management/extensions/ExtensionBuddhistDateformat.dart';
import 'package:buffaloes_farm_management/models/NotificationModel.dart';
import 'package:buffaloes_farm_management/models/activity/ActivityFunctionModel.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({Key? key}) : super(key: key);

  Color primaryColor = Colors.orange;
  ScrollController? scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      if (state is HomeNotificationState) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: state is LoadingHomeNotificationState
              ? loading()
              : body(context, state),
        );
      } else {
        return Container();
      }
    });
  }

  loading() {
    return Center(
      child: SpinKitThreeBounce(
        color: ColorHelper.lighten(primaryColor).withOpacity(0.7),
        size: 50.0,
      ),
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
              context.read<HomeCubit>().notification();
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

  body(BuildContext context, HomeNotificationState state) {
    return Container(
      child: RefreshIndicator(
        color: primaryColor,
        child: child(context, state),
        onRefresh: () async {
          context.read<HomeCubit>().notification();
        },
      ),
    );
  }

  Widget child(BuildContext context, HomeNotificationState state) {
    if (state.data != null) {
      if (state.data!.isNotEmpty) {
        Map<String, List<NotificationModel>> data = {};

        for (NotificationModel model in state.data!) {
          if (model.notify_datetime != null) {
            if (data.containsKey(model.notify_datetime) == false) {
              data[model.notify_datetime!] = [];
            }
            data[model.notify_datetime!]?.add(model);
          }
        }

        List<Widget> children = [];
        data.forEach((key, value) {
          children.add(_head(key));
          for (NotificationModel element in value) {
            children.add(card(context, element));
          }
        });

        return ListView.builder(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 20),
          itemCount: children.length,
          itemBuilder: (context, index) {
            return children[index];
          },
        );
      }
    }
    return empty(context);
  }

  card(BuildContext context, NotificationModel model) {
    BuffNotificationType type = getNotificationCardType(model);
    IconData icon = getNotificationTypeIcon(type);

    ActivityFunctionModel? function = null;
    String message = "ชื่อกระบือ:  ${model.buff?.name ?? ""}";
    //String message = getDate(model.notify_datetime);
    //String duration = getDuration(model.notify_datetime);
    String subMessage = "เบอร์หู:  ${model.buff?.tag}";
    return GestureDetector(
      child: Material(
          color: Colors.transparent,
          child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.only(bottom: 2, top: 4, left: 2),
              decoration: BoxDecoration(
                  // color: ColorHelper.lighten(primaryColor, .5)
                  //     .withOpacity(0.1),
                  color: ColorHelper.lighten(primaryColor, .4).withOpacity(0.1),
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
                      color: ColorHelper.lighten(primaryColor, .1)
                          .withOpacity(0.65),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      size: 19,
                      color: ColorHelper.darken(primaryColor, .44)
                          .withOpacity(0.8),
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
                            getNotificationTitle(type),
                            style: GoogleFonts.itim(
                                color: ColorHelper.lighten(primaryColor, .2)
                                    .withOpacity(0.8),
                                fontSize: 24),
                          ),
                          const SizedBox(width: 0, height: 0),
                          Row(
                            children: [
                              Text(
                                message ?? "",
                                style: GoogleFonts.itim(
                                    color: ColorHelper.lighten(primaryColor, .4)
                                        .withOpacity(0.94),
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
                                    color: ColorHelper.lighten(primaryColor, .4)
                                        .withOpacity(0.94),
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(width: 0, height: 12),
                          function != null
                              ? ElevatedButton(
                                  onPressed: function.function,
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        ColorHelper.darken(primaryColor, .4)
                                            .withOpacity(0.1)),
                                    elevation: MaterialStateProperty.all(0),
                                    backgroundColor: MaterialStateProperty.all(
                                        ColorHelper.darken(primaryColor, .4)
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
                                                primaryColor, .4)
                                            .withOpacity(0.8),
                                        size: 18,
                                      ),
                                      Container(width: 12),
                                      Text(
                                        function.name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: ColorHelper.lighten(
                                                    primaryColor, .4)
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

  cards(NotificationModel model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: ColorHelper.lighten(primaryColor, .3).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12)),
      width: 10,
      height: 120,
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

  String getDuration(String? date) {
    if (date != null) {
      DateTime to = DateFormat("yyyy-MM-dd").parse(date);
      DateTime from = DateTime.now();
      int difference = daysBetween(from, to);
      return "$difference วัน";
    }
    return "ไม่ระบุ";
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Widget _head(value) {
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(value);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    var formatterFull = DateFormat("d MMMM yyyy");
    String dateInBuddhistCalendarFormat =
        formatterFull.formatInBuddhistCalendarThai(tempDate);
    var formatterDay = DateFormat("EEEE");
    String dayInBuddhistCalendarFormat = formatterDay
        .formatInBuddhistCalendarThai(tempDate)
        .replaceAll("วัน", "");

    if (tempDate == today) {
      dayInBuddhistCalendarFormat = "วันนี้";
    }
    if (tempDate == yesterday) {
      dayInBuddhistCalendarFormat = "เมื่อวาน";
    }

    return Container(
      padding: const EdgeInsets.only(left: 12, bottom: 0, top: 12),
      //margin: EdgeInsets.only(bottom: 6),
      alignment: Alignment.bottomLeft,
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //     width: 200,
          //     child: Text(
          //       dayInBuddhistCalendarFormat,
          //       style: GoogleFonts.itim(color: Colors.white, fontSize: 28),
          //     )),
          Text(
            dateInBuddhistCalendarFormat,
            style: GoogleFonts.itim(
                //color: ColorHelper.lighten(primaryColor, .3).withOpacity(0.7),
                color: ColorHelper.lighten(primaryColor, .42).withOpacity(0.84),
                fontSize: 20),
          ),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }

  IconData getNotificationTypeIcon(BuffNotificationType type) {
    switch (type) {
      case BuffNotificationType.breeding:
        {
          return FontAwesomeIcons.venusMars;
        }
      case BuffNotificationType.returnEstrus:
        {
          return FontAwesomeIcons.stethoscope;
        }
      case BuffNotificationType.vaccineInjection:
        {
          return FontAwesomeIcons.crutch;
        }
      case BuffNotificationType.deworming:
        {
          return FontAwesomeIcons.prescriptionBottleMedical;
        }
      case BuffNotificationType.diseaseTreatment:
        {
          return FontAwesomeIcons.virusCovid;
        }
      default:
        {
          return FontAwesomeIcons.ellipsis;
        }
    }
  }

  Color getNotificationTypeColor(BuffNotificationType type) {
    switch (type) {
      case BuffNotificationType.breeding:
        {
          return Colors.pink;
        }
      case BuffNotificationType.returnEstrus:
        {
          return Colors.indigo;
        }
      case BuffNotificationType.vaccineInjection:
        {
          return Colors.blue;
        }
      case BuffNotificationType.deworming:
        {
          return Colors.yellow;
        }
      case BuffNotificationType.diseaseTreatment:
        {
          return Colors.green;
        }
      default:
        {
          return Colors.blueGrey;
        }
    }
  }

  BuffNotificationType getNotificationCardType(NotificationModel model) {
    print(model);
    String? name = model.value ?? "";
    print(name);

    if (name == "BREEDING") {
      return BuffNotificationType.breeding;
    } else if (name == "RETURN_ESTRUS") {
      return BuffNotificationType.returnEstrus;
    } else if (name == "INJECTION") {
      return BuffNotificationType.vaccineInjection;
    } else if (name == "NEXT_DEWORMING") {
      return BuffNotificationType.deworming;
    } else if (name == "NEXT_TREATMENT") {
      return BuffNotificationType.diseaseTreatment;
    } else {
      return BuffNotificationType.unknown;
    }
  }

  String getNotificationTitle(BuffNotificationType type) {
    switch (type) {
      case BuffNotificationType.breeding:
        {
          return "ผสมพันธุ์";
        }
      case BuffNotificationType.returnEstrus:
        {
          return "กลับสัด";
        }
      case BuffNotificationType.vaccineInjection:
        {
          return "ฉีดวัคซีน";
        }
      case BuffNotificationType.deworming:
        {
          return "ถ่ายพยาธิ";
        }
      case BuffNotificationType.diseaseTreatment:
        {
          return "รักษาโรค";
        }
      default:
        {
          return "ไม่พบชื่อ";
        }
    }
  }
}

enum BuffNotificationType {
  breeding,
  returnEstrus,
  vaccineInjection,
  deworming,
  diseaseTreatment,
  unknown
}
