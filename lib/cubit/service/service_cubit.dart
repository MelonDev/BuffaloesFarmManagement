import 'package:bloc/bloc.dart';
import 'package:buffaloes_farm_management/pages/report_page.dart';
import 'package:buffaloes_farm_management/service/FarmService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit() : super(ServiceInitialState());

  report(BuildContext context) async {
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

    emit(ServiceReportState(data: data, mapModels: mapModels));
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
        double opacity = (0.8 / (indicators.length)) * (index + 1);

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
