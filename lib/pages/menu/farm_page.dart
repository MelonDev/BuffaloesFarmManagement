import 'package:buffaloes_farm_management/cubit/home/home_cubit.dart';
import 'package:buffaloes_farm_management/models/BuffModel.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmPage extends StatelessWidget {
  FarmPage({Key? key}) : super(key: key);

  Color primaryColor = const Color(0xff0171BB);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      if (state is HomeFarmState) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: state is LoadingHomeFarmState
                ? loading()
                : body(context, state));
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
    ));
  }

  body(BuildContext context, HomeFarmState state) {
    if (state.data != null) {
      if (state.data!.isNotEmpty) {
        Map<String, dynamic>? farm = state.data!['FARM'];
        Map<String, dynamic>? buffs = state.data!['BUFFS'];
        Map<String, dynamic>? activities = state.data!['ACTIVITIES'];

        return ListView(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 26, bottom: 50),
          children: [
            farm != null ? farmCard(farm) : Container(),
            buffs != null ? buffsCard(buffs) : Container(),
            activities != null ? activitiesCard(activities) : Container(),
          ],
        );
        return ListView.builder(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          itemCount: state.data?.length ?? 0,
          itemBuilder: (context, index) {
            return card(state.data![index]);
          },
        );
      }
    }
    return empty(context);
  }

  Widget empty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "?????????????????????????????????",
            style: GoogleFonts.itim(
                color: ColorHelper.lighten(primaryColor, .3).withOpacity(0.8),
                fontSize: 26),
          ),
          Container(height: 6),
          ElevatedButton(
            onPressed: () {
              context.read<HomeCubit>().farm(context);
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
                  "??????????????????",
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

  card(BuffModel model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: ColorHelper.lighten(primaryColor, .5).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12)),
      width: 10,
      height: 120,
    );
  }

  farmCard(Map<String, dynamic> data) {
    return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 2),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  ColorHelper.lighten(primaryColor, .6).withOpacity(0.12),
                  ColorHelper.lighten(primaryColor, .10).withOpacity(0.0),
                ],
                begin: const Alignment(-0.0, -1.0),
                end: const Alignment(0.0, 1.0),
                stops: const [0.0, 0.4],
                tileMode: TileMode.clamp),
            //color: primaryColor.withOpacity(0.65),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['name'] ?? "",
              style: GoogleFonts.kodchasan(
                  fontWeight: FontWeight.bold,
                  color: ColorHelper.lighten(primaryColor, .3),
                  fontSize: 28),
            ),
            const SizedBox(
              height: 12,
            ),
            RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "????????????:",
                    style: GoogleFonts.itim(
                        color: ColorHelper.darken(Colors.white, .2), fontSize: 17),
                  ),
                  TextSpan(
                    text: "    ${data['first_name']} ${data['last_name']}",
                    style: GoogleFonts.itim(
                        color: ColorHelper.darken(Colors.white, .1), fontSize: 19),
                  )
                ])),
            // Text(
            //   "???????????????????????????????????????:  ${data['phone_number']?.toString().replaceAll("+66", "0")}",
            //   style: GoogleFonts.itim(
            //       color: ColorHelper.darken(Colors.white, .15), fontSize: 16),
            // ),
            RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "?????????????????????:",
                    style: GoogleFonts.itim(
                        color: ColorHelper.darken(Colors.white, .2), fontSize: 17),
                  ),
                  TextSpan(
                    text: "  ${data['sub_district']}, ${data['district']}, ${data['province']}",
                    style: GoogleFonts.itim(
                        color: ColorHelper.darken(Colors.white, .1), fontSize: 19),
                  )
                ])),
            const SizedBox(
              height: 16,
            ),
            // Row(
            //     mainAxisSize: MainAxisSize.max,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       button(
            //           icon: Icons.info_outline_rounded, message: "??????????????????????????????"),
            //       const SizedBox(width: 8, height: 0),
            //       button(icon: Icons.edit_outlined, message: "???????????????")
            //     ])
          ],
        ));
  }

  buffsCard(Map<String, dynamic> data) {
    return Container(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                margin: const EdgeInsets.only(left: 8, right: 0, bottom: 0),
                child: Text(
                  "???????????????",
                  style: GoogleFonts.itim(
                      color: ColorHelper.lighten(primaryColor, .7),
                      fontSize: 28),
                )),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        ColorHelper.lighten(primaryColor, .6).withOpacity(0.12),
                        ColorHelper.lighten(primaryColor, .10).withOpacity(0.0),
                      ],
                      begin: const Alignment(-0.0, -1.0),
                      end: const Alignment(0.0, 1.0),
                      stops: const [0.0, 0.4],
                      tileMode: TileMode.clamp),
                  //color: ColorHelper.lighten(primaryColor, .6).withOpacity(0.07),
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 22, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              // setState(() {
                              //   if (!event.isInterestedForInteractions ||
                              //       pieTouchResponse == null ||
                              //       pieTouchResponse.touchedSection == null) {
                              //     touchedIndex = -1;
                              //     return;
                              //   }
                              //   touchedIndex = pieTouchResponse
                              //       .touchedSection!.touchedSectionIndex;
                              // });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 8,
                          centerSpaceRadius: 32,
                          sections: showingBuffsSections(data),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 26,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buffIndicator(
                          color: ColorHelper.lighten(primaryColor, .6)
                              .withOpacity(0.9),
                          text: '?????????????????????',
                          value: data['TOTAL'] ?? 0),
                      const SizedBox(
                        height: 8,
                      ),
                      buffIndicator(
                          color: Colors.blue,
                          text: '??????????????????',
                          value: data['MALE'] ?? 0),
                      const SizedBox(
                        height: 8,
                      ),
                      buffIndicator(
                          color: Colors.pink,
                          text: '?????????????????????',
                          value: data['FEMALE'] ?? 0),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }

  activitiesCard(Map<String, dynamic> data) {
    print(data);
    return Container(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                margin: const EdgeInsets.only(left: 8, right: 0, bottom: 0),
                child: Text(
                  "???????????????",
                  style: GoogleFonts.itim(
                      color: ColorHelper.lighten(primaryColor, .7),
                      fontSize: 28),
                )),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        ColorHelper.lighten(primaryColor, .6).withOpacity(0.12),
                        ColorHelper.lighten(primaryColor, .10).withOpacity(0.0),
                      ],
                      begin: const Alignment(-0.0, -1.0),
                      end: const Alignment(0.0, 1.0),
                      stops: const [0.0, 0.4],
                      tileMode: TileMode.clamp),
                  //color: ColorHelper.lighten(primaryColor, .6).withOpacity(0.07),
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.only(
                  left: 0, right: 16, top: 32, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(
                    width: 26,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /*activityIndicator(
                          color: Colors.pink,
                          text: '????????????????????????????????????',
                          alignment: Alignment.topCenter,
                          value: data['BREEDING'] ?? 0),
                      const SizedBox(
                        height: 4,
                      ),*/
                      activityIndicator(
                          color: Colors.indigo,
                          text: '??????????????????',
                          alignment: Alignment.topCenter,
                          value: data['RETURN_ESTRUS'] ?? 0),
                      const SizedBox(
                        height: 4,
                      ),
                      activityIndicator(
                          color: Colors.blue,
                          text: '?????????????????????????????????',
                          value: data['VACCINE_INJECTION'] ?? 0),
                      const SizedBox(
                        height: 4,
                      ),
                      activityIndicator(
                          color: Colors.yellow,
                          text: '?????????????????????????????????',
                          value: data['DEWORMING'] ?? 0),
                      const SizedBox(
                        height: 4,
                      ),
                      activityIndicator(
                          color: Colors.green,
                          text: '???????????????????????????????????????',
                          alignment: Alignment.bottomCenter,

                          value: data['DISEASE_TREATMENT'] ?? 0),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget button({required String message, required IconData icon}) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
            ColorHelper.darken(primaryColor, .4).withOpacity(.1)),
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(
            ColorHelper.lighten(primaryColor, .48).withOpacity(.17)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: 2),
          Text(
            message,
            style: TextStyle(
                fontSize: 17,
                color: ColorHelper.lighten(primaryColor, .6).withOpacity(0.8)),
          ),
          Container(width: 2),
        ],
      ),
    );
  }

  Widget activityIndicator(
      {required Color color,
      Alignment alignment = Alignment.center,
      required String text,
      required int value}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 65,
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
              margin: const EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      alignment == Alignment.topCenter ? 10 : 4),
                  topRight: Radius.circular(
                      alignment == Alignment.topCenter ? 10 : 4),
                  bottomLeft: Radius.circular(
                      alignment == Alignment.bottomCenter ? 10 : 4),
                  bottomRight: Radius.circular(
                      alignment == Alignment.bottomCenter ? 10 : 4),
                ),
              ),
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "$value",
                  style: GoogleFonts.itim(
                      fontSize: 22,
                      color: color.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white),
                ),
                TextSpan(
                  text: " ?????????",
                  style: GoogleFonts.itim(
                      fontSize: 15,
                      color: color.computeLuminance() > 0.5
                          ? Colors.black.withOpacity(0.8)
                          : Colors.white.withOpacity(0.8)),
                )
              ]))),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                    fontSize: 18,
                    color: ColorHelper.lighten(color, .5).withOpacity(0.99)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                  gradient: LinearGradient(
                      colors: [
                        ColorHelper.lighten(color, .1).withOpacity(0.8),
                        Colors.transparent,
                      ],
                      begin: const Alignment(0.0, 0.0),
                      end: const Alignment(1.0, 1.0),
                      stops: const [0.0, 1.0],
                      tileMode: TileMode.clamp),

                ),
                height: 1,width: 180,
              ),
            ]
          )

        ]);
  }

  Widget buffIndicator(
      {required Color color, required String text, required int value}) {
    return Row(
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
                      fontSize: 17,
                      color: ColorHelper.lighten(primaryColor, .6)
                          .withOpacity(0.9)),
                ),
                Text(
                  "$value ?????????",
                  style: TextStyle(
                      fontSize: 16,
                      color: ColorHelper.lighten(primaryColor, .6)
                          .withOpacity(0.7)),
                )
              ])
        ]);
  }

  List<PieChartSectionData> showingBuffsSections(Map<String, dynamic> data) {
    return List.generate(2, (i) {
      const fontSize = 18.0;
      const radius = 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: data['MALE'].toDouble(),
            title: '',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.pink,
            value: data['FEMALE'].toDouble(),
            title: '',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
