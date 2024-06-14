import 'package:buffaloes_farm_management/models/activity/BaseActivityModel.dart';

class DewormingActivityModel extends BaseActivityModel {
  String? id;
  String? name;
  String? created_at;
  String? updated_at;
  String? dewormer_type;
  String? duration;
  String? deworming_date;
  String? date;
  String? notify;
  bool? status;
  bool? delete;

  DewormingActivityModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name']?.toString(),
        created_at = json['created_at']?.toString(),
        updated_at = json['updated_at']?.toString(),
        dewormer_type = json['dewormer_type']?.toString(),
        duration = json['duration']?.toString(),
        deworming_date = json['deworm_date']?.toString(),
        date = json['date']?.toString(),
        notify = json['notify']?.toString(),
        status = json['status'],
        delete = json['delete'];
}
