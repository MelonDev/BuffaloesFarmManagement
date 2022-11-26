import 'package:buffaloes_farm_management/models/activity/ActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/BaseActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/BreedingActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/DewormingActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/DiseaseTreatmentActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/ReturnEstrusActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/VaccineInjectionActivityModel.dart';

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

  List<BaseActivityModel> history = [];

  BuffModel();

  BuffModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name']?.toString(),
        tag = json['tag']?.toString(),
        gender = json['gender']?.toString(),
        birth_date = json['birth_date']?.toString(),
        father_id = json['father_id']?.toString(),
        father_name = json['father_name']?.toString(),
        mother_id = json['mother_id']?.toString(),
        mother_name = json['mother_name']?.toString(),
        source = json['source']?.toString(),
        status = json['source']?.toString(),
        history = json['history']
                ?.map<BaseActivityModel>((item) => _getActivityModel(item))
                .toList() ??
            [],
        image_url = json['image_url']?.toString();

  static BaseActivityModel _getActivityModel(item) {
    String? name = item['name'] ?? "";

    print(item);

    if (name == "BREEDING") {
      return BreedingActivityModel.fromJson(item);
    } else if (name == "RETURN_ESTRUS") {
      return ReturnEstrusActivityModel.fromJson(item);
    } else if (name == "VACCINE_INJECTION") {
      return VaccineInjectionActivityModel.fromJson(item);
    } else if (name == "DEWORMING") {
      return DewormingActivityModel.fromJson(item);
    } else if (name == "DISEASE_TREATMENT") {
      return DiseaseTreatmentActivityModel.fromJson(item);
    } else {
      return ActivityModel.fromJson(item);
    }
  }
}
