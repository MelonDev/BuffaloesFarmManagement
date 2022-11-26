import 'package:buffaloes_farm_management/models/activity/BaseActivityModel.dart';

class VaccineInjectionActivityModel extends BaseActivityModel {

  String? id;
  String? name;
  String? created_at;
  String? updated_at;
  String? vaccine_name;
  String? vaccine_key;
  String? vaccine_duration;
  String? date;
  String? notify;
  bool? status;
  bool? delete;

  VaccineInjectionActivityModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name']?.toString(),
        created_at = json['created_at']?.toString(),
        updated_at = json['updated_at']?.toString(),
        vaccine_name = json['vaccine_name']?.toString(),
        vaccine_key = json['vaccine_key']?.toString(),
        vaccine_duration = json['vaccine_duration']?.toString(),
        date = json['date']?.toString(),
        notify = json['notify']?.toString(),
        status = json['status'],
        delete = json['delete'];
}
