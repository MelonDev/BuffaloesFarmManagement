import 'package:buffaloes_farm_management/models/activity/BaseActivityModel.dart';

class ActivityModel extends BaseActivityModel {
  String? id;
  String? name;
  String? created_at;
  String? updated_at;
  String? value;
  String? secondary_value;
  bool? bool_value;
  String? date;
  String? refer_id;
  bool? status;
  bool? delete;

  ActivityModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name']?.toString(),
        created_at = json['created_at']?.toString(),
        updated_at = json['updated_at']?.toString(),
        value = json['value']?.toString(),
        secondary_value = json['secondary_value']?.toString(),
        bool_value = json['bool_value'],
        date = json['date']?.toString(),
        refer_id = json['refer_id']?.toString(),
        status = json['status'],
        delete = json['delete'];
}
