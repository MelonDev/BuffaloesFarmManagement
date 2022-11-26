import 'package:buffaloes_farm_management/models/activity/BaseActivityModel.dart';

class BreedingActivityModel extends BaseActivityModel {
  String? id;
  String? name;
  String? created_at;
  String? updated_at;
  bool? artificial_insemination;
  String? date;
  String? notify;
  bool? status;
  bool? delete;

  BreedingActivityModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name']?.toString(),
        created_at = json['created_at']?.toString(),
        updated_at = json['updated_at']?.toString(),
        artificial_insemination = json['artificial_insemination'],
        date = json['date']?.toString(),
        notify = json['notify']?.toString(),
        status = json['status'],
        delete = json['delete'];
}
