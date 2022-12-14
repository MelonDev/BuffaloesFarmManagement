import 'package:buffaloes_farm_management/models/activity/BaseActivityModel.dart';

class ReturnEstrusActivityModel extends BaseActivityModel {
  String? id;
  String? name;
  String? created_at;
  String? updated_at;
  String? estrus_message;
  bool? estrus_result;
  String? date;
  String? end_date;

  String? notify;
  bool? status;
  bool? delete;

  ReturnEstrusActivityModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name']?.toString(),
        created_at = json['created_at']?.toString(),
        updated_at = json['updated_at']?.toString(),
        estrus_message = json['estrus_message']?.toString(),
        estrus_result = json['estrus_result'],
        date = json['date']?.toString(),
        end_date = json['end_date']?.toString(),
        notify = json['notify']?.toString(),
        status = json['status'],
        delete = json['delete'];
}
