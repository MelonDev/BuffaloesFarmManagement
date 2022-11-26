import 'package:buffaloes_farm_management/models/BuffModel.dart';
import 'package:buffaloes_farm_management/models/NotificationModel.dart';
import 'package:buffaloes_farm_management/service/HttpService.dart';
import 'package:intl/intl.dart';

class FarmService {
  static Future<BuffModel?> buff(String id) async {
    try {
      Map<String, String> body = {
        //"email": "",
        //"password": "",
      };
      var response = await HttpService.getForm(path: '/buffs/$id', body: body);
      if (response != null) {
        if (response.statusCode == 200) {
          var data = response.data['data'];
          print(data);
          if (data != null) {
            BuffModel buff = BuffModel.fromJson(data);
            return buff;
          }
        }
      }

      return null;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> summary() async {
    try {
      Map<String, String> body = {
        //"email": "",
        //"password": "",
      };
      var response = await HttpService.getForm(path: '/summary', body: body);
      if (response != null) {
        if (response.statusCode == 200) {
          var data = response.data['data'];
          print(data);
          if (data != null) {
            return data;
          }
        }
        return {};
      }

      return null;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<List<BuffModel>?> buffs() async {
    try {
      Map<String, String> body = {
        //"email": "",
        //"password": "",
      };
      var response = await HttpService.getForm(path: '/buffs', body: body);
      if (response != null) {
        if (response.statusCode == 200) {
          var data = response.data['data'];
          if (data != null) {
            List<BuffModel> list = data.map<BuffModel>((item) {
              return BuffModel.fromJson(item);
            }).toList();
            return list;
          }
        }
        return [];
      }

      return null;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<bool?> addBuff(
      {required String? name,
      String? tag,
      required String? datetime,
      required String? gender,
      String? father,
      String? mother,
      String? source,
      String? image}) async {
    try {
      Map<String, String> body = {
        "name": name ?? "",
        "tag": tag ?? "",
        "gender": gender ?? "",
        "birth_date": datetime ?? "",
        "father_name": father ?? "",
        "mother_name": mother ?? "",
        "source": source ?? "",
        "image_url": image ?? "",
      };

      print(body);
      var response = await HttpService.postForm(path: '/buffs', body: body);
      print("response: $response");
      if (response != null) {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.data);
          return true;
        } else {
          return false;
        }
      }

      return null;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> addBreeding(
      {required String buffId,
      required bool artificialInsemination,
      required String breederName,
      required DateTime date}) async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(date);

      Map<String, dynamic> body = {
        "buff_id": buffId,
        "artificial_insemination": artificialInsemination,
        "breeder_name": breederName ?? "",
        "breeder_id": "",
        "date": formatted,
        "notify": true
      };

      print(body);
      var response = await HttpService.postForm(path: '/breeding', body: body);
      print("response: $response");
      if (response != null) {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.data);
          return "SUCCESS";
        } else if (response.statusCode == 406) {
          return "อยู่ในสถานะรอการกลับสัด ไม่สามารถผสมพันธุ์เพิ่มได้";
        } else {
          String message = response.data['detail'];
          if (message == "MALE CAN'T NOT BREEDING") {
            return "เพศผู้ไม่สามารถเป็นแม่พันธุ์";
          }
          if (message == "FEMALE CAN'T NOT BREEDER") {
            return "เพศเมียไม่สามารถเป็นพ่อพันธุ์";
          }
          if (message == "NOT FOUND") {
            return "ไม่พบข้อมูลแม่พันธุ์";
          }
          return "เกิดข้อผิดพลาด";
        }
      }

      return null;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> addReturnEstrus(
      {required String buffId,
      required bool estrusResult,
      String? messageResult}) async {
    try {
      Map<String, dynamic> body = {
        "buff_id": buffId,
        "estrus_result": estrusResult,
        "message_result": messageResult ?? "",
        "notify": true
      };

      print(body);
      var response =
          await HttpService.postForm(path: '/return-estrus', body: body);
      print("response: $response");
      if (response != null) {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.data);
          return "SUCCESS";
        } else if (response.statusCode == 406) {
          return "ไม่พบสถานะรอการกลับสัด";
        } else {
          String message = response.data['detail'];
          if (message == "MALE CAN'T NOT RETURN ESTRUS") {
            return "เพศผู้ไม่สามารถกลับสัด";
          }
          if (message == "NOT FOUND") {
            return "ไม่พบข้อมูลแม่พันธุ์";
          }
          return "เกิดข้อผิดพลาด";
        }
      }

      return null;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> addVaccineInjection(
      {required String buffId,
      required String vaccine_name,
      String? otherVaccineName,
      int? otherVaccineDuration,
      required DateTime date}) async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(date);

      Map<String, dynamic> body = {
        "buff_id": buffId,
        "vaccine_name": vaccine_name,
        "other_vaccine_name": otherVaccineName,
        "vaccine_duration": otherVaccineDuration,
        "date": formatted,
        "notify": true
      };

      print(body);
      var response =
          await HttpService.postForm(path: '/vaccine_injection', body: body);
      print("response: $response");
      if (response != null) {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.data);
          return "SUCCESS";
        } else {
          return "เกิดข้อผิดพลาด";
        }
      }

      return null;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> addDeworming(
      {required String buffId,
      required String anthelminticDrugName,
      int? nextDewormingDuration,
      required DateTime date}) async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(date);

      Map<String, dynamic> body = {
        "buff_id": buffId,
        "anthelmintic_drug_name": anthelminticDrugName,
        "next_deworming_duration": nextDewormingDuration,
        "date": formatted,
        "notify": true
      };

      print(body);
      var response = await HttpService.postForm(path: '/deworming', body: body);
      print("response: $response");
      if (response != null) {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.data);
          return "SUCCESS";
        } else {
          return "เกิดข้อผิดพลาด";
        }
      }

      return null;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> addDiseaseTreatment(
      {required String buffId,
      required String diseaseName,
      required String symptom,
      required String drug,
      required bool healedStatus,
      int? duration,
      required DateTime date}) async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(date);
      List<String> symptoms = symptom.split(",");
      List<String> drugs = drug.split(",");

      Map<String, dynamic> body = {
        "buff_id": buffId,
        "disease_name": diseaseName,
        "symptom": symptoms,
        "drugs": drugs,
        "healed_status": healedStatus,
        "duration": duration,
        "date": formatted,
        "notify": true
      };

      print(body);
      var response = await HttpService.postForm(path: '/disease-treatment', body: body);
      print("response: $response");
      if (response != null) {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.data);
          return "SUCCESS";
        } else {
          return "เกิดข้อผิดพลาด";
        }
      }

      return null;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<NotificationModel>?> notifications() async {
    try {
      Map<String, String> body = {
        //"email": "",
        //"password": "",
      };
      var response =
          await HttpService.getForm(path: '/notifications', body: body);
      if (response != null) {
        if (response.statusCode == 200) {
          var data = response.data['data'];
          if (data != null) {
            List<NotificationModel> list = data.map<NotificationModel>((item) {
              return NotificationModel.fromJson(item);
            }).toList();
            return list;
          }
        }
        return [];
      }

      return null;
    } on Exception catch (_) {
      return null;
    }
  }
}
