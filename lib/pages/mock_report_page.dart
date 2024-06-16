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
  State<ReportPage> createState() => _ReportPageState();
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

  initialData() async {
    Map<String, dynamic>? data = await FarmService.mockReport();
    List<ReportBaseModel>? mapModels;
    if (data != null) {
      mapModels = [];
      mapModels.add(mapProvince(
          data: data,
          key: "farms",
          title: "จำนวนฟาร์ม 4 จังหวัดภาคเหนือ",
          surfix: "คน"));
      // mapModels.add(mapProvince(
      //     data: data,
      //     key: "buffs",
      //     title: "จำนวนกระบือ 4 จังหวัดภาคเหนือ",
      //     surfix: "ตัว",
      //     color: Colors.blueAccent));
      mapModels.add(mapPhayao(data: data));
      mapModels.add(mapChiangRai(data: data));
      mapModels.add(mapNan(data: data));
      mapModels.add(mapPhrae(data: data));
      mapModels.add(ReportPieChartModel(data['MOCK']));
      mapModels.add(ReportTableModel(data['TABLE']));
    }

    setState(() {
      this.data = data;
      this.mapModels = mapModels;
    });
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;

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
            constraints: const BoxConstraints(maxWidth: 800),
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                backgroundColor: primaryColor,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(50.0),
                  child: Container(
                    height: 60 + statusBarHeight,
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: AppBar(
                          backgroundColor: Colors.white.withOpacity(0.0),
                          shadowColor: Colors.transparent,
                          elevation: 0.0,
                          surfaceTintColor: primaryColor,
                          systemOverlayStyle: SystemUiOverlayStyle(
                              statusBarIconBrightness: Brightness.dark,
                              statusBarBrightness: Brightness.light,
                              statusBarColor: primaryColor,
                              systemNavigationBarColor: primaryColor,
                              systemNavigationBarIconBrightness:
                                  Brightness.dark),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
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
                            icon: Icon(FontAwesomeIcons.xmark,
                                color: textOuterColor, size: 24),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                body: body(),
              ),
            ),
          ),
        ),
      ),
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
            } else if (model is ReportMapAmpModel) {
              return widgetMapFarmAmp(model);
            } else if (model is ReportPieChartModel) {
              return buffTypeCard(model.data);
            } else if (model is ReportTableModel) {
              //return Container();
              print("MODEL");
              return buffTableCard(model.data);
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

  Widget widgetMapFarmAmp(ReportMapAmpModel model) {
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
                                fontSize: 12)),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          )
        ]);
  }

  Widget mapIndicator(
      {required Color color,
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
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 30, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.3,
                      child: BarChart(BarChartData(
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: getTitles,
                                reservedSize: 50,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                reservedSize: 50,
                                showTitles: true,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          gridData: FlGridData(show: false),
                          barGroups: showingBuffTypeSections(data))),
                      // child: PieChart(
                      //   PieChartData(
                      //     pieTouchData: PieTouchData(
                      //       touchCallback:
                      //           (FlTouchEvent event, pieTouchResponse) {
                      //         // setState(() {
                      //         //   if (!event.isInterestedForInteractions ||
                      //         //       pieTouchResponse == null ||
                      //         //       pieTouchResponse.touchedSection == null) {
                      //         //     touchedIndex = -1;
                      //         //     return;
                      //         //   }
                      //         //   touchedIndex = pieTouchResponse
                      //         //       .touchedSection!.touchedSectionIndex;
                      //         // });
                      //       },
                      //     ),
                      //     borderData: FlBorderData(
                      //       show: false,
                      //     ),
                      //     sectionsSpace: 3,
                      //     centerSpaceRadius: 32,
                      //     sections: showingBuffTypeSections(data),
                      //   ),
                      // ),
                    ),
                  ),
                  // const SizedBox(
                  //   width: 26,
                  // ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: <Widget>[
                  //     mapIndicator(
                  //       color: ColorHelper.darken(primaryColor, .1)
                  //           .withOpacity(0.9),
                  //       text: 'ทั้งหมด',
                  //     ),
                  //     const SizedBox(
                  //       height: 8,
                  //     ),
                  //     mapIndicator(
                  //       color: Colors.blue,
                  //       text: 'พ่อพันธุ์',
                  //     ),
                  //     const SizedBox(
                  //       height: 8,
                  //     ),
                  //     mapIndicator(
                  //       color: Colors.pink,
                  //       text: 'แม่พันธุ์',
                  //     ),
                  //     const SizedBox(
                  //       height: 8,
                  //     ),
                  //     mapIndicator(
                  //       color: Colors.yellow,
                  //       text: 'กระบือรุ่น',
                  //     ),
                  //     const SizedBox(
                  //       height: 8,
                  //     ),
                  //     mapIndicator(
                  //       color: Colors.lightGreen,
                  //       text: 'กระบือขุน',
                  //     ),
                  //     const SizedBox(
                  //       height: 8,
                  //     ),
                  //     mapIndicator(
                  //       color: Colors.orange,
                  //       text: 'แรกเกิด',
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   width: 16,
                  // ),
                ],
              ),
            )
          ],
        ));
  }

  Widget getTitles(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      color: Colors.black.withOpacity(0.5),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('พ่อพันธุ์', style: style);
        break;
      case 1:
        text = Text('แม่พันธุ์', style: style);
        break;
      case 2:
        text = Text('กระบือรุ่น', style: style);
        break;
      case 3:
        text = Text('กระบือขุน', style: style);
        break;
      case 4:
        text = Text('แรกเกิด', style: style);
        break;
      case 5:
        text = Text('S', style: style);
        break;
      case 6:
        text = Text('S', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      angle: 0.7,
      child: text,
    );
  }

  List<BarChartGroupData> showingBuffTypeSections(Map<String, dynamic> data) {
    return List.generate(5, (i) {
      switch (i) {
        case 0:
          return section(
              number: 0,
              value: data['M'].toDouble(),
              title: data['M'].toString(),
              color: Colors.blue);
        case 1:
          return section(
              number: 1,
              value: data['F'].toDouble(),
              title: data['F'].toString(),
              color: Colors.pink);
        case 2:
          return section(
              number: 2,
              value: data['T'].toDouble(),
              title: data['T'].toString(),
              color: Colors.yellow);
        case 3:
          return section(
              number: 3,
              value: data['G'].toDouble(),
              title: data['G'].toString(),
              color: Colors.lightGreen);
        case 4:
          return section(
              number: 4,
              value: data['B'].toDouble(),
              title: data['B'].toString(),
              color: Colors.orange);
        default:
          throw Error();
      }
    });
  }

  BarChartGroupData section(
      {required int number,
      double value = 0,
      String? title,
      Color color = Colors.white,
      double radius = 32.0,
      double fontSize = 22.0}) {
    return BarChartGroupData(
      x: number,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: radius,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
          borderSide: const BorderSide(color: Colors.white, width: 0),
          // backDrawRodData: BackgroundBarChartRodData(
          //   show: true,
          //   toY: 20,
          //   //color: widget.barBackgroundColor,
          // ),
        ),
      ],
      // color: color,
      // value: value,
      // title: title ?? "",
      // radius: radius,
      // titleStyle: TextStyle(
      //   fontSize: fontSize,
      //   fontWeight: FontWeight.normal,
      //   color: Colors.white.withOpacity(0.95),
      // ),
    );
  }

  ReportMapModel mapProvince(
      {required data,
      required String key,
      required String title,
      required String surfix,
      Color color = Colors.lightGreen}) {
    List northProvice = data['north']?[key]?['provinces'] ?? [];
    int northTotalCount = data['north']?[key]?['count'] ?? [];

    if (northProvice.isNotEmpty) {
      northProvice.sort((a, b) {
        return a['count'].compareTo(b['count']);
      });
    }

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
        surfix: "คน");
  }

  ReportMapAmpModel mapPhayao({required data}) {
    List<String> amps = [
      "จุน",
      "เชียงคำ",
      "เมืองพะเยา",
      "ดอกคำใต้",
      "เชียงม่วน",
      "ภูซาง",
      "ภูกามยาว",
      "ปง",
      "แม่ใจ"
    ];
    Color color = Colors.lightGreen;

    List provinces = data["north"]?["farms"]?["provinces"] ?? [];
    List districts = [];
    int districtsTotalCount = 0;

    //print(provinces);

    for (var province in provinces) {
      print("PRO: ${province}");
      if (province["province"] == "พะเยา") {
        print("PHAYAO");
        List x = province["district"];
        print(x);
        districts.addAll(x);
        districtsTotalCount = x.length;
      }
    }

    districts.sort((a, b) {
      return a['count'].compareTo(b['count']);
    });

    List<IndicatorModel> indicators = [];

    int count = 0;
    indicators.add(IndicatorModel(
      //name: "TEST",
        name: "จุน",
        //amount: dist['count'] ?? 0,
        amount: 14,
        color: Colors.transparent));
    indicators.add(IndicatorModel(
      //name: "TEST",
        name: "เชียงคำ",
        //amount: dist['count'] ?? 0,
        amount: 6,
        color: Colors.transparent));
    indicators.add(IndicatorModel(
      //name: "TEST",
        name: "เมืองพะเยา",
        //amount: dist['count'] ?? 0,
        amount: 5,
        color: Colors.transparent));
    for (String amp in amps) {
      if (districts.any((district) => district['district'] == amp)) {
        print("PHAYAO: $amp");
        // var dist =
        //     districts.where((district) => district['district'] == amp).single;
        // print(dist);
        // print("${dist['district']}, ${dist['count']}");
        //int amount = dist['count'] ?? 0;
        // indicators.add(
        //     IndicatorModel(name: amp, amount: 0, color: Colors.transparent));
        // indicators.add(IndicatorModel(
        //   //name: "TEST",
        //     name: dist['district'] ?? "",
        //     //amount: dist['count'] ?? 0,
        //     amount: 20,
        //     color: Colors.transparent));


      } else {
        indicators.add(
            IndicatorModel(name: amp, amount: 0, color: Colors.transparent));
      }

      count += 1;
    }

    int totalCount = districts.length;

    MapShapeSource _mapPhayaoProvince = MapShapeSource.asset(
      'assets/geojson/phayao_province.json',
      shapeDataField: 'amp_th',
      dataCount: indicators.length,
      primaryValueMapper: (int index) {
        return indicators[index].name;
      },
      dataLabelMapper: (int index) {
        return amps[index];
      },
      shapeColorValueMapper: (int index) {
        print(indicators.where((element) => element.amount > 0));
        print(indicators[index].amount > 0);
        if (indicators[index].amount > 0) {
          double opacity = (1.0 /
                  (indicators.where((element) => element.amount > 0).length)) *
              (index + 1);
          return districtsTotalCount == 0
              ? Colors.transparent
              : color.withOpacity(opacity);
        } else {
          return Colors.transparent;
        }
      },
    );
    return ReportMapAmpModel(
        title: "จังหวัดพะเยา",
        mapSource: _mapPhayaoProvince,
        color: color,
        value: totalCount,
        surfix: "คน");
  }

  ReportMapAmpModel mapChiangRai({required data}) {
    // List<String> amps = [
    //   'ดอยหลวง',
    //   'แม่ลาว',
    //   'เวียงเชียงรุ้ง',
    //   'เชียงของ',
    //   'เทิง',
    //   'เมืองเชียงราย',
    //   'เวียงชัย',
    //   'ขุนตาล',
    //   'แม่ฟ้าหลวง',
    //   'พญาเม็งราย',
    //   'เวียงแก่น',
    //   'แม่สรวย',
    //   'เวียงป่าเป้า',
    //   'แม่สาย',
    //   'แม่จัน',
    //   'เชียงแสน',
    //   'พาน',
    //   'ป่าแดด'
    // ];
    List<String> amps = [
      'พาน',
      'ดอยหลวง',
      'แม่ลาว',
      'เวียงเชียงรุ้ง',
      'เชียงของ',
      'เทิง',
      'เมืองเชียงราย',
      'เวียงชัย',
      'ขุนตาล',
      'แม่ฟ้าหลวง',
      'พญาเม็งราย',
      'เวียงแก่น',
      'แม่สรวย',
      'เวียงป่าเป้า',
      'แม่สาย',
      'แม่จัน',
      'เชียงแสน',
      'ป่าแดด'
    ];
    Color color = Colors.lightGreen;

    List provinces = data["north"]?["farms"]?["provinces"] ?? [];
    List districts = [];
    int districtsTotalCount = 0;

    //print(provinces);

    for (var province in provinces) {
      print("PRO: ${province}");
      if (province["province"] == "เชียงราย") {
        List x = province["district"];
        print(x);
        districts.addAll(x);
        districtsTotalCount = x.length;
      }
    }

    districts.sort((a, b) {
      return a['count'].compareTo(b['count']);
    });

    List<IndicatorModel> indicators = [];

    int count = 0;
    indicators.add(IndicatorModel(
      //name: "TEST",
        name: "พาน",
        //amount: dist['count'] ?? 0,
        amount: 12,
        color: Colors.transparent));

    for (String amp in amps) {

      print("amp: $amp districts: $districts");
      if (districts.any((district) => district['district'] == amp)) {

      } else {
        indicators.add(
            IndicatorModel(name: amp, amount: 0, color: Colors.transparent));
      }

      count += 1;
    }

    int totalCount = districts.length;

    MapShapeSource _map = MapShapeSource.asset(
      'assets/geojson/chiangrai_province.json',
      shapeDataField: 'amp_th',
      dataCount: indicators.length,
      primaryValueMapper: (int index) {
        return indicators[index].name;
      },
      dataLabelMapper: (int index) {
        return amps[index];
      },
      shapeColorValueMapper: (int index) {

        if (indicators[index].amount > 0) {
          double opacity = (1.0 /
              (indicators.where((element) => element.amount > 0).length)) *
              (index + 1);
          return districtsTotalCount == 0
              ? Colors.transparent
              : color.withOpacity(opacity);
        } else {
          return Colors.transparent;
        }
      },
    );

    return ReportMapAmpModel(
        title: "จังหวัดเชียงราย",
        mapSource: _map,
        color: color,
        value: totalCount,
        surfix: "คน");
  }

  ReportMapAmpModel mapNan({required data}) {
    List<String> amps = [
      'ปัว',
      'ท่าวังผา',
      'บ้านหลวง',
      'นาน้อย',
      'เมืองน่าน',
      'แม่จริม',
      'ภูเพียง',
      'เฉลิมพระเกียรติ',
      'บ่อเกลือ',
      'สองแคว',
      'นาหมื่น',
      'สันติสุข',
      'เชียงกลาง',
      'เวียงสา',
      'ทุ่งช้าง'
    ];
    Color color = Colors.lightGreen;

    List provinces = data["north"]?["farms"]?["provinces"] ?? [];
    List districts = [];
    int districtsTotalCount = 0;

    //print(provinces);

    for (var province in provinces) {
      print("PRO: ${province}");
      if (province["province"] == "เชียงราย") {
        List x = province["district"];
        print(x);
        districts.addAll(x);
        districtsTotalCount = x.length;
      }
    }

    districts.sort((a, b) {
      return a['count'].compareTo(b['count']);
    });

    List<IndicatorModel> indicators = [];

    int count = 0;

    for (String amp in amps) {
      if (districts.any((district) => district['district'] == amp)) {
      } else {
        indicators.add(
            IndicatorModel(name: amp, amount: 0, color: Colors.transparent));
      }

      count += 1;
    }

    int totalCount = districts.length;

    MapShapeSource _map = MapShapeSource.asset(
      'assets/geojson/nan_province.json',
      shapeDataField: 'amp_th',
      dataCount: indicators.length,
      primaryValueMapper: (int index) {
        return indicators[index].name;
      },
      dataLabelMapper: (int index) {
        return amps[index];
      },
      shapeColorValueMapper: (int index) {

        if (indicators[index].amount > 0) {
          double opacity = (1.0 /
              (indicators.where((element) => element.amount > 0).length)) *
              (index + 1);
          return districtsTotalCount == 0
              ? Colors.transparent
              : color.withOpacity(opacity);
        } else {
          return Colors.transparent;
        }
      },
    );

    return ReportMapAmpModel(
        title: "จังหวัดน่าน",
        mapSource: _map,
        color: color,
        value: totalCount,
        surfix: "คน");
  }

  ReportMapAmpModel mapPhrae({required data}) {
    List<String> amps = [
      'สอง',
      'วังชิ้น',
      'สูงเม่น',
      'เด่นชัย',
      'ร้องกวาง',
      'ลอง',
      'เมืองแพร่',
      'หนองม่วงไข่'
    ];
    Color color = Colors.lightGreen;

    List provinces = data["north"]?["farms"]?["provinces"] ?? [];
    List districts = [];
    int districtsTotalCount = 0;

    //print(provinces);

    for (var province in provinces) {
      print("PRO: ${province}");
      if (province["province"] == "เชียงราย") {
        List x = province["district"];
        print(x);
        districts.addAll(x);
        districtsTotalCount = x.length;
      }
    }

    districts.sort((a, b) {
      return a['count'].compareTo(b['count']);
    });

    List<IndicatorModel> indicators = [];

    int count = 0;

    for (String amp in amps) {
      if (districts.any((district) => district['district'] == amp)) {
      } else {
        indicators.add(
            IndicatorModel(name: amp, amount: 0, color: Colors.transparent));
      }

      count += 1;
    }

    int totalCount = districts.length;

    MapShapeSource _map = MapShapeSource.asset(
      'assets/geojson/phrae_province.json',
      shapeDataField: 'amp_th',
      dataCount: indicators.length,
      primaryValueMapper: (int index) {
        return indicators[index].name;
      },
      dataLabelMapper: (int index) {
        return amps[index];
      },
      shapeColorValueMapper: (int index) {

        if (indicators[index].amount > 0) {
          double opacity = (1.0 /
              (indicators.where((element) => element.amount > 0).length)) *
              (index + 1);
          return districtsTotalCount == 0
              ? Colors.transparent
              : color.withOpacity(opacity);
        } else {
          return Colors.transparent;
        }
      },
    );
    return ReportMapAmpModel(
        title: "จังหวัดแพร่",
        mapSource: _map,
        color: color,
        value: totalCount,
        surfix: "คน");
  }

  buffTableCard(Map<String, dynamic> data) {
    List<String> titleList = [
      //'ไอดี',
      'รายชื่อ',
      'เบอร์',
      'ที่อยู่',
      'ตำบล',
      'อำเภอ',
      'จังหวัด',
      'เพศ',
      'อายุ',
      'การศึกษา',
      'สถานภาพทางสังคม',
      'การเลี้ยงกระบือ',
      'อาชีพหลัก',
      'ทำอาชีพไรบ้าง',
      'รายได้รวม',
      'รายได้เฉลี่ยต่อปีของการขายกระบือ',
      'สมาชิก',
      'หลักเกณฑ์ในการคัดเลือก',
      'จำนวนควายทั้งหมด',
      'เพศผู้',
      'เพศเมีย',
      'กระบือรุ่น',
      'ลูกกระบือ',
      'ประสบการณ์',
      'ลักษณะการเลี้ยง',
      'ลักษณะโรงเรือน',
      'พื้นโรงเรือน',
      'คอกกักกระบือ',
      'ซองบังคับ',
      'การขึ้นทะเบียน',
      'ประวัติการตรวจโรค',
      'โรคระบาดในฟาร์ม',
    ];
    List<dynamic> result = [];
    List<Map<String, dynamic>> resultMore = [];

    print("YURIIE");
    data.forEach((k, v) {
      print("$k $v");
      if (k != "อื่น") {
        result.addAll(v);
      }
      // if (k != "อื่น") {
      //   result.addAll(v);
      // } else {
      //   resultMore.addAll(v);
      // }
    });

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
                  "ข้อมูลโดยละเอียด",
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
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 20),
              child:
                  _tableWidget(context, titleKeys: titleList, dataList: result),
            )
          ],
        ));
  }

  Widget _tableWidget(BuildContext context,
      {List<String>? titleKeys, List<dynamic>? dataList}) {
    return Container(
      height: 1800,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          DataTable(
              columns: _createColumns(titleKeys ?? []),
              rows: _createRows(dataList ?? []))
        ],
      ),
    );
    // return DataTable(
    //     columns: _createColumns(titleKeys ?? []), rows: _createRows());
  }

  List<DataColumn> _createColumns(List<String> titleKeys) {
    List<DataColumn> column = [];
    print("TEST: $titleKeys");

    titleKeys.forEach((element) {
      column.add(DataColumn(label: Text(element,style: GoogleFonts.itim(fontWeight: FontWeight.bold,fontSize: 16),)));
    });
    print("TEST2: $column");
    return column;
    // return [
    //   DataColumn(label: Text('ID')),
    //   DataColumn(label: Text('Book')),
    //   DataColumn(label: Text('Author'))
    // ];
  }

  List<DataRow> _createRows(List<dynamic>? dataList) {
    print("_createRows");
    //print(dataList);
    List<DataRow> row = [];
    dataList?.forEach((element) {
      row.add(DataRow(cells: [
        //DataCell(Text(element['ไอดี']?.toString() ?? "")),
        DataCell(Text(element['รายชื่อ']?.toString() ?? "")),
        DataCell(Text(element['เบอร์']?.toString() ?? "")),
        DataCell(Text(element['ที่อยู่']?.toString() ?? "")),
        DataCell(Text(element['ตำบล']?.toString() ?? "")),
        DataCell(Text(element['อำเภอ']?.toString() ?? "")),
        DataCell(Text(element['จังหวัด']?.toString() ?? "")),
        DataCell(Text(element['เพศ']?.toString() ?? "")),
        DataCell(Text(element['อายุ']?.toString() ?? "")),
        DataCell(Text(element['การศึกษา']?.toString() ?? "")),
        DataCell(Text(element['สถานภาพทางสังคม']?.toString() ?? "")),
        DataCell(Text(element['การเลี้ยงกระบือ']?.toString() ?? "")),
        DataCell(Text(element['อาชีพหลัก']?.toString() ?? "")),
        DataCell(Text(element['ทำอาชีพไรบ้าง']?.toString() ?? "")),
        DataCell(Text(element['รายได้รวม']?.toString() ?? "")),
        DataCell(Text(element['รายได้เฉลี่ยต่อปีของการขายกระบือ']?.toString() ?? "")),
        DataCell(Text(element['สมาชิก']?.toString() ?? "")),
        DataCell(Text(element['หลักเกณฑ์ในการคัดเลือก']?.toString() ?? "")),
        DataCell(Text(element['จำนวนควายทั้งหมด']?.toString() ?? "")),
        DataCell(Text(element['เพศผู้']?.toString() ?? "")),
        DataCell(Text(element['เพศเมีย']?.toString() ?? "")),
        DataCell(Text(element['กระบือรุ่น']?.toString() ?? "")),
        DataCell(Text(element['ลูกกระบือ']?.toString() ?? "")),
        DataCell(Text(element['ประสบการณ์']?.toString() ?? "")),
        DataCell(Text(element['ลักษณะการเลี้ยง']?.toString() ?? "")),
        DataCell(Text(element['ลักษณะโรงเรือน']?.toString() ?? "")),
        DataCell(Text(element['พื้นโรงเรือน']?.toString() ?? "")),
        DataCell(Text(element['คอกกักกระบือ']?.toString() ?? "")),
        DataCell(Text(element['ซองบังคับ']?.toString() ?? "")),
        DataCell(Text(element['การขึ้นทะเบียน']?.toString() ?? "")),
        DataCell(Text(element['ประวัติการตรวจโรค']?.toString() ?? "")),
        DataCell(Text(element['โรคระบาดในฟาร์ม']?.toString() ?? "")),
      ]));

    });
    return row;
    return [
      // DataRow(cells: [
      //   DataCell(Text('#100')),
      //   DataCell(Text('Flutter Basics')),
      //   DataCell(Text('David John'))
      // ]),
      // DataRow(cells: [
      //   DataCell(Text('#101')),
      //   DataCell(Text('Dart Internals')),
      //   DataCell(Text('Alex Wick'))
      // ])
    ];
  }
}

class IndicatorModel {
  String name;
  int amount;
  Color color;

  IndicatorModel(
      {required this.name, required this.amount, required this.color});
}

class ReportBaseModel {}

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

  ReportMapModel(
      {required this.title,
      required this.value,
      required this.mapSource,
      required this.items,
      required this.color,
      required this.surfix});
}

class ReportMapAmpModel extends ReportBaseModel {
  MapShapeSource mapSource;
  Color color;
  String title;
  int value;

  String surfix;

  ReportMapAmpModel(
      {required this.title,
      required this.value,
      required this.mapSource,
      required this.color,
      required this.surfix});
}

class ReportTableModel extends ReportBaseModel {
  Map<String, dynamic> data;

  ReportTableModel(this.data);
}
