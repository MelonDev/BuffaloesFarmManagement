import 'package:buffaloes_farm_management/models/activity/BaseActivityModel.dart';

class InductingActivityModel extends BaseActivityModel {
  String? id;
  String? name;
  String? created_at;
  String? updated_at;
  String? induction_message;
  bool? induction;
  String? date;
  String? notify;
  bool? status;
  bool? delete;

  InductingActivityModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name']?.toString(),
        created_at = json['created_at']?.toString(),
        updated_at = json['updated_at']?.toString(),
        induction = json['induction'],
        induction_message = json['induction_message']?.toString(),
        date = json['date']?.toString(),
        notify = json['notify']?.toString(),
        status = json['status'],
        delete = json['delete'];
}
