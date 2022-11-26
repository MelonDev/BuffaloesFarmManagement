import 'package:buffaloes_farm_management/models/activity/BaseActivityModel.dart';

class DiseaseTreatmentActivityModel extends BaseActivityModel {
  String? id;
  String? name;
  String? created_at;
  String? updated_at;
  String? disease_name;
  String? symptom;
  String? drugs;
  bool? healed_status;
  String? date;
  String? notify;
  bool? status;
  bool? delete;

  DiseaseTreatmentActivityModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name']?.toString(),
        created_at = json['created_at']?.toString(),
        updated_at = json['updated_at']?.toString(),
        disease_name = json['disease_name']?.toString(),
        symptom = json['symptom']?.toString(),
        drugs = json['drugs']?.toString(),
        healed_status = json['healed_status'],
        date = json['date']?.toString(),
        notify = json['notify']?.toString(),
        status = json['status'],
        delete = json['delete'];
}
