import 'package:buffaloes_farm_management/models/activity/BaseActivityModel.dart';

class DewormingActivityModel extends BaseActivityModel {
  String? id;
  String? name;
  String? created_at;
  String? updated_at;
  String? anthelmintic_drug_name;
  String? next_deworming_duration;
  String? next_deworming_date;
  String? date;
  String? notify;
  bool? status;
  bool? delete;

  DewormingActivityModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name']?.toString(),
        created_at = json['created_at']?.toString(),
        updated_at = json['updated_at']?.toString(),
        anthelmintic_drug_name = json['anthelmintic_drug_name']?.toString(),
        next_deworming_duration = json['next_deworming_duration']?.toString(),
        next_deworming_date = json['next_deworming_date']?.toString(),
        date = json['date']?.toString(),
        notify = json['notify']?.toString(),
        status = json['status'],
        delete = json['delete'];
}
