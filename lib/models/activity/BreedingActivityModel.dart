import 'package:buffaloes_farm_management/models/activity/BaseActivityModel.dart';

class BreedingActivityModel extends BaseActivityModel {
  String? id;
  String? name;
  bool? induction;
  String? created_at;
  String? updated_at;
  bool? artificial_insemination;
  String? date;
  String? induction_method;
  String? induction_date;
  String? estrus_return_date;
  String? notify;
  bool? status;
  bool? delete;

  BreedingActivityModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name']?.toString(),
        induction = json['induction'],
        created_at = json['created_at']?.toString(),
        updated_at = json['updated_at']?.toString(),
        induction_method = json['induction_method']?.toString(),
        induction_date = json['induction_date']?.toString(),
        estrus_return_date = json['estrus_return_check_date']?.toString(),
        artificial_insemination = json['artificial_insemination'],
        date = json['date']?.toString(),
        notify = json['notify']?.toString(),
        status = json['status'],
        delete = json['delete'];
}
