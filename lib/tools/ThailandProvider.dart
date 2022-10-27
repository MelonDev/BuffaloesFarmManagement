import 'dart:convert';

import 'package:buffaloes_farm_management/models/DistrictModel.dart';
import 'package:buffaloes_farm_management/models/ProvinceModel.dart';
import 'package:buffaloes_farm_management/models/SubDistrictModel.dart';
import 'package:flutter/widgets.dart';

class ThailandProvider {
  static Future<List<ProvinceModel>> provinces(BuildContext context) async {
    print("provinces");
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/provinces.json");
    List<dynamic> jsonResult = jsonDecode(data);

    List<ProvinceModel> provinces = jsonResult.map((item) {
      return ProvinceModel.fromJson(item);
    }).toList();

    return provinces;
  }

  static Future<List<DistrictModel>> districts(BuildContext context,
      {int? provinceId}) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/districts.json");
    List<dynamic> jsonResult = jsonDecode(data);

    List<DistrictModel> districts = jsonResult.map((item) {
      return DistrictModel.fromJson(item);
    }).toList();

    return provinceId != null
        ? districts.where((i) => i.PROVINCE_ID == provinceId).toList()
        : districts;
  }

  static Future<List<SubDistrictModel>> subDistricts(BuildContext context,
      {int? provinceId, int? districtId}) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/subDistricts.json");
    List<dynamic> jsonResult = jsonDecode(data);

    List<SubDistrictModel> subDistricts = jsonResult.map((item) {
      return SubDistrictModel.fromJson(item);
    }).toList();

    return provinceId != null && districtId != null
        ? subDistricts
            .where((i) =>
                i.PROVINCE_ID == provinceId && i.DISTRICT_ID == districtId)
            .toList()
        : subDistricts;
  }
}
