import 'package:buffaloes_farm_management/models/activity/ActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/BaseActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/BreedingActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/DewormingActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/DiseaseTreatmentActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/InductingActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/ReturnEstrusActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/VaccineInjectionActivityModel.dart';
import 'package:dart_extensions_methods/dart_extension_methods.dart';

class BuffModel {
  String? id;
  String? name;
  String? tag;
  String? gender;
  String? birth_date;
  String? father_id;
  String? father_name;
  String? mother_id;
  String? mother_name;

  String? source;
  String? image_url;
  String? status;
  String? type;
  String? breed;
  String? bloodline_level;
  String? price;

  // List<BaseActivityModel> history = [];
  List<BaseActivityModel> history = [];

  BuffModel();

  BuffModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['info']?['name']?.toString(),
        tag = json['info']?['tag']?.toString(),
        gender = json['info']?['gender']?.toString(),
        birth_date = json['info']?['birth_date']?.toString(),
        father_id = json['father_id']?.toString(),
        father_name = json['breeding_info']?['father_name']?.toString(),
        mother_id = json['mother_id']?.toString(),
        mother_name = json['breeding_info']?['mother_name']?.toString(),
        source = json['source']?.toString(),
        status = _getStatusName(json['status']?.toString()),
        type = json['info']?['type']?.toString(),
        breed = json['breeding_info']?['breed']?.toString(),
        bloodline_level = json['breeding_info']?['bloodline_level']?.toString(),
        price = json['price']?.toString().toDouble().toStringAsFixed(0),
        // history = json['history']
        //         ?.map<BaseActivityModel>((item) => _getActivityModel(item))
        //         .toList() ??
        //     [],
        // history = json['activities']?.map<BaseActivityModel>((map) {
        //       print("MAP");
        //       print(map);
        //       return _getActivityList(map);
        //     }).toList() ??
        //     [],
        history = _getActivityList(json['activities']),

        //history = json['history'] ?? [],
        image_url = json['image_url']?.toString();

  static List<BaseActivityModel> _getActivityList(data) {
    List<BaseActivityModel> result = [];

    for (dynamic i in data?['breeding'] ?? []){
      result.add(_getActivityModel(i, "BREEDING"));
    }

    for (dynamic i in data?['vaccine_injection'] ?? []){
      result.add(_getActivityModel(i, "VACCINE_INJECTION"));
    }

    for (dynamic i in data?['desease_treatment'] ?? []){
      result.add(_getActivityModel(i, "DISEASE_TREATMENT"));
    }

    for (dynamic i in data?['deworming'] ?? []){
      result.add(_getActivityModel(i, "DEWORMING"));
    }

    // result.addAll(data['breeding']
    //         ?.map<BaseActivityModel>(
    //             (item) => _getActivityModel(item, "BREEDING"))
    //         .toList() ??
    //     []);

    return result;
  }

  static BaseActivityModel _getActivityModel(item, type) {
    String? name = item['name'] ?? "";

    print(item);
    if (type == "INDUCTING") {
      return InductingActivityModel.fromJson(item);
    } else if (type == "BREEDING") {
      return BreedingActivityModel.fromJson(item);
    } else if (type == "RETURN_ESTRUS") {
      return ReturnEstrusActivityModel.fromJson(item);
    } else if (type == "VACCINE_INJECTION") {
      return VaccineInjectionActivityModel.fromJson(item);
    } else if (type == "DEWORMING") {
      return DewormingActivityModel.fromJson(item);
    } else if (type == "DISEASE_TREATMENT") {
      return DiseaseTreatmentActivityModel.fromJson(item);
    } else {
      return ActivityModel.fromJson(item);
    }
  }

  static String _getStatusName(name) {
    if (name == "INDUCTING") {
      return "รอตรวจการผสม";
    } else if (name == "BREEDING") {
      return "รอตรวจการกลับสัด";
    } else if (name == "RETURN_ESTRUS") {
      return "ตั้งท้อง";
    } else if (name == "VACCINE_INJECTION") {
      return "ปกติ";
    } else if (name == "DEWORMING") {
      return "ปกติ";
    } else if (name == "DISEASE_TREATMENT") {
      return "กำลังรักษาโรค";
    } else {
      return "ปกติ";
    }
  }
}
