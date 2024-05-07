import 'dart:convert';

import 'package:buffaloes_farm_management/models/DistrictModel.dart';
import 'package:buffaloes_farm_management/models/ProvinceModel.dart';
import 'package:buffaloes_farm_management/models/SubDistrictModel.dart';
import 'package:flutter/widgets.dart';

class ThailandProvider {
  static Future<ProvinceModel?> province(
      BuildContext context, String? name) async {
    if (name == null) return null;
    List<ProvinceModel> provinces = await ThailandProvider.provinces(context);
    List<ProvinceModel> filter =
        provinces.where((element) => element.PROVINCE_NAME == name).toList();
    return filter.isNotEmpty ? filter.first : null;
  }

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

  static Future<DistrictModel?> district(
      BuildContext context, int? provinceId, String? name) async {
    if (name == null || provinceId == null) return null;
    List<DistrictModel> districts =
        await ThailandProvider.districts(context, provinceId: provinceId);
    List<DistrictModel> filter =
        districts.where((element) => element.DISTRICT_NAME == name).toList();
    return filter.isNotEmpty ? filter.first : null;
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

  static Future<SubDistrictModel?> subDistrict(
      BuildContext context, int? provinceId,int? districtId, String? name) async {
    if (name == null || provinceId == null) return null;
    List<SubDistrictModel> subDistricts =
    await ThailandProvider.subDistricts(context, provinceId: provinceId,districtId: districtId);
    List<SubDistrictModel> filter =
    subDistricts.where((element) => element.SUB_DISTRICT_NAME == name).toList();
    return filter.isNotEmpty ? filter.first : null;
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
