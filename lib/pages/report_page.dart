import 'package:buffaloes_farm_management/cubit/service/service_cubit.dart';
import 'package:buffaloes_farm_management/service/FarmService.dart';
import 'package:buffaloes_farm_management/tools/ColorHelper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:buffaloes_farm_management/constants/ColorConstants.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Color primaryColor = const Color(0xFFDCDCDC);
  Color textOuterColor = const Color(0xFF2A2A2A);

  Map<String, dynamic>? data;
  List<ReportBaseModel>? mapModels;

  @override
  void initState() {
    super.initState();

    initialData();
  }

  initialData() async{
    Map<String, dynamic>? data = await FarmService.report();
    List<ReportBaseModel>? mapModels;
    if (data != null) {
      mapModels = [];
      mapModels.add(mapProvince(
          data: data,
          key: "farms",
          title: "จำนวนฟาร์ม 4 จังหวัดภาคเหนือ",
          surfix: "ฟาร์ม"));
      mapModels.add(mapProvince(
          data: data,
          key: "buffs",
          title: "จำนวนกระบือ 4 จังหวัดภาคเหนือ",
          surfix: "ตัว",
          color: Colors.blueAccent));
      mapModels.add(ReportPieChartModel(data['TYPE']));
    }

    setState(() {
      this.data = data;
      this.mapModels = mapModels;

    });
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
          //statusBarColor: Colors.white
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
                                          const SystemUiOverlayStyle(
                                              statusBarIconBrightness:
                                              Brightness.dark,
                                              statusBarBrightness: Brightness.light,
                                              statusBarColor: Colors.white),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .vertical(
                                              bottom: Radius.circular(22),
                                            ),
                                          ),
                                          centerTitle: true,
                                          title: Text(
                                            "รายงาน",
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
    if (mapModels != null) {
      return ListView.builder(
          padding: const EdgeInsets.only(top: 0),
          itemCount: mapModels!.length,
          itemBuilder: (BuildContext context, int index) {
            var model = mapModels![index];
            if (model is ReportMapModel) {
              return widgetMapFarmProvince(model);
            } else if (model is ReportPieChartModel) {
              return buffTypeCard(model.data);
            } else {
              return Container();
            }
          });
    } else {
      return Container();
    }
  }

  Widget widgetMapFarmProvince(ReportMapModel model) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(
                  left: 30, right: 20, bottom: 3, top: 16),
              child: Text(
                model.title,
                style: TextStyle(
                    fontSize: 22, color: Colors.black.withOpacity(0.8)),
              )),
          Container(
            decoration: const BoxDecoration(
              color: kBGColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(22),
                bottom: Radius.circular(22),
              ),
            ),
            margin: const EdgeInsets.only(left: 20, right: 20),
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      height: 250,
                      //height: MediaQuery.of(context).size.height,
                      child: SfMaps(
                        layers: [
                          MapShapeLayer(
                            source: model.mapSource,
                            //legend: MapLegend(MapElement.shape),
                            showDataLabels: true,
                            strokeColor: const Color(0xFF9D9D9D),
                            strokeWidth: 1.0,
                            dataLabelSettings: const MapDataLabelSettings(
                                textStyle: TextStyle(
                                    color: Color(0xFF4D4D4D),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16)),
                          ),
                        ],
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 110,
                  height: 250,
                  color: Colors.transparent,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: model.items.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return mapIndicator(
                              color: ColorHelper.darken(primaryColor, .1)
                                  .withOpacity(0.9),
                              text: "ทั้งหมด",
                              value: model.value,
                              surfix: model.surfix);
                        } else {
                          IndicatorModel item = model.items[index - 1];

                          return mapIndicator(
                              color: item.color,
                              text: item.name,
                              value: item.amount,
                              surfix: model.surfix);
                        }
                      }),
                )
              ],
            ),
          )
        ]);
  }

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

  buffTypeCard(Map<String, dynamic> data) {
    return Container(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                margin: const EdgeInsets.only(
                    left: 30, right: 20, bottom: 3, top: 16),
                child: Text(
                  "ประเภทของกระบือ",
                  style: TextStyle(
                      fontSize: 22, color: Colors.black.withOpacity(0.8)),
                )),

            Container(
              decoration: const BoxDecoration(
                color: kBGColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(22),
                  bottom: Radius.circular(22),
                ),
              ),
              margin: const EdgeInsets.only(left: 20, right: 20),
              padding:
              const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.3,
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
                          sectionsSpace: 3,
                          centerSpaceRadius: 32,
                          sections: showingBuffTypeSections(data),
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
                      mapIndicator(
                        color: ColorHelper.darken(primaryColor, .1)
                            .withOpacity(0.9),
                        text: 'ทั้งหมด',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      mapIndicator(
                        color: Colors.blue,
                        text: 'พ่อพันธุ์',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      mapIndicator(
                        color: Colors.pink,
                        text: 'แม่พันธุ์',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      mapIndicator(
                        color: Colors.yellow,
                        text: 'กระบือรุ่น',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      mapIndicator(
                        color: Colors.lightGreen,
                        text: 'กระบือขุน',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      mapIndicator(
                        color: Colors.orange,
                        text: 'แรกเกิด',
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
            )
          ],
        ));
  }

  List<PieChartSectionData> showingBuffTypeSections(Map<String, dynamic> data) {
    return List.generate(5, (i) {
      switch (i) {
        case 0:
          return section(value: data['M'].toDouble(),
              title: data['M'].toString(),
              color: Colors.blue);
        case 1:
          return section(value: data['F'].toDouble(),
              title: data['F'].toString(),
              color: Colors.pink);
        case 2:
          return section(value: data['T'].toDouble(),
              title: data['T'].toString(),
              color: Colors.yellow);
        case 3:
          return section(value: data['G'].toDouble(),
              title: data['G'].toString(),
              color: Colors.lightGreen);
        case 4:
          return section(value: data['B'].toDouble(),
              title: data['B'].toString(),
              color: Colors.orange);
        default:
          throw Error();
      }
    });
  }

  PieChartSectionData section(
      {double value = 0, String? title, Color color = Colors
          .white, double radius = 50.0, double fontSize = 22.0}) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: title ?? "",
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
        color: Colors.white.withOpacity(0.95),
      ),
    );
  }

  ReportMapModel mapProvince(
      {required data,
        required String key,
        required String title,
        required String surfix,
        Color color = Colors.lightGreen}) {
    List northProvice = data['north'][key]['provinces'];
    int northTotalCount = data['north'][key]['count'];

    northProvice.sort((a, b) {
      return a['count'].compareTo(b['count']);
    });

    List<IndicatorModel> indicators = [];
    int count = 0;
    for (var provice in northProvice) {
      double opacity = (0.8 / (northProvice.length)) * (count + 1);
      indicators.add(IndicatorModel(
          name: provice['province'],
          amount: provice['count'],
          color: color.withOpacity(opacity)));
      count += 1;
    }

    MapShapeSource _mapProvince = MapShapeSource.asset(
      'assets/geojson/thailand_northern_four_province.json',
      shapeDataField: 'name',
      dataCount: indicators.length,
      primaryValueMapper: (int index) {
        return indicators[index].name;
      },
      shapeColorValueMapper: (int index) {
        double opacity = (1.0 / (indicators.length)) * (index + 1);
        return northTotalCount == 0
            ? Colors.transparent
            : color.withOpacity(opacity);
      },
    );

    return ReportMapModel(
        title: title,
        mapSource: _mapProvince,
        items: indicators.reversed.toList(),
        color: color,
        value: northTotalCount,
        surfix: surfix);
  }
}

class IndicatorModel {
  String name;
  int amount;
  Color color;

  IndicatorModel(
      {required this.name, required this.amount, required this.color});
}

class ReportBaseModel {
}

class ReportPieChartModel extends ReportBaseModel {
  Map<String, dynamic> data;

  ReportPieChartModel(this.data);
}

class ReportMapModel extends ReportBaseModel {
  MapShapeSource mapSource;
  List<IndicatorModel> items;
  Color color;
  String title;
  int value;

  String surfix;

  ReportMapModel({required this.title,
    required this.value,
    required this.mapSource,
    required this.items,
    required this.color,
    required this.surfix});
}
