import 'package:buffaloes_farm_management/models/BuffModel.dart';
import 'package:buffaloes_farm_management/models/activity/ActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/BaseActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/BreedingActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/DewormingActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/DiseaseTreatmentActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/ReturnEstrusActivityModel.dart';
import 'package:buffaloes_farm_management/models/activity/VaccineInjectionActivityModel.dart';

class NotificationModel {

  String? id;
  String? value;
  String? category;
  String? notify_datetime;
  bool? status;
  BaseActivityModel activity;
  BuffModel? buff;

  NotificationModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        value = json['value']?.toString(),
        category = json['category']?.toString(),
        notify_datetime = json['notify_datetime']?.toString(),
        status = json['status'],
        activity = _getActivityModel(json['activity']),
        buff = BuffModel.fromJson(json['buff']);

  static BaseActivityModel _getActivityModel(item){
    String? name = item['name'] ?? "";

    print(name);

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