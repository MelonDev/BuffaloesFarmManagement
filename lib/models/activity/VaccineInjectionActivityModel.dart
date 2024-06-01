import 'package:buffaloes_farm_management/models/activity/BaseActivityModel.dart';
import 'package:intl/intl.dart';

class VaccineInjectionActivityModel extends BaseActivityModel {
  String? id;
  String? created_at;
  String? updated_at;
  String? name;
  String? otherName;
  String? injected_date;
  String? duration;

  String? notify;
  bool? status;
  bool? delete;

  VaccineInjectionActivityModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        created_at = json['created_at']?.toString(),
        updated_at = json['updated_at']?.toString(),
        name = json['name']?.toString(),
        otherName = json['other_name']?.toString(),
        duration = json['duration']?.toString(),
        injected_date = json['injected_date']?.toString(),
        notify = json['notify']?.toString(),
        status = json['status'],
        delete = json['delete'];
}

DateTime? getDate(String? birthDate) {
  if (birthDate == null) return null;
  DateTime tempDate = DateFormat("yyyy-MM-dd").parse(birthDate!);
  return tempDate;
}
