import 'package:buffaloes_farm_management/models/BuffModel.dart';
import 'package:buffaloes_farm_management/models/NotificationModel.dart';
import 'package:buffaloes_farm_management/models/financial_model.dart';
import 'package:buffaloes_farm_management/service/HttpService.dart';
import 'package:intl/intl.dart';

class FarmService {

  static Future<List<FinancialModel>?> financial() async {
    try {
      Map<String, String> body = {
        //"email": "",
        //"password": "",
      };
      var response = await HttpService.getForm(path: '/financial', body: body);
      if (response != null) {
        if (response.statusCode == 200) {
          var data = response.data['data'];
          print("DATA: $data");
          if (data != null) {
            List<FinancialModel> list = data.map<FinancialModel>((item) {
              return FinancialModel.fromJson(item);
            }).toList();
            return list;
          }
        }
      }

      return null;
    } on Exception catch (_) {
      return null;
    }
  }

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
          print("DATA: $data");
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

  static Future<Map<String, dynamic>?> info() async {
    try {
      var response = await HttpService.getForm(path: '/info', body: {});
      if (response != null) {
        if (response.statusCode == 200) {
          var data = response.data['data'];
          print("info");
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

  static Future<bool> changeInfo({
    String? farmName,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
    String? group,
    String? token,
    String? province,
    String? district,
    String? subDistrict,
    DateTime? birthDate,
    DateTime? farmDate,
  }) async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');

      Map<String, String> body = {
        "farm_name": farmName ?? "",
        "first_name": firstName ?? "",
        "last_name": lastName ?? "",
        "address": address ?? "",
        "group": group ?? "",
        "province": province ?? "",
        "district": district ?? "",
        "sub_district": subDistrict ?? "",
        "birth_date": birthDate != null ? formatter.format(birthDate) : "",
        "farm_date": farmDate != null ? formatter.format(farmDate) : ""
      };
      var response =
          await HttpService.patchForm(path: '/change-info', body: body);
      return response?.statusCode == 200;
    } on Exception catch (_) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> summary() async {
    try {
      var response = await HttpService.getForm(path: '/summary', body: {});
      if (response != null) {
        if (response.statusCode == 200) {
          var data = response.data['data'];
          print("summary");
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

  static Future<Map<String, dynamic>?> report() async {
    try {
      var response = await HttpService.getForm(path: '/report', body: {});
      if (response != null) {
        if (response.statusCode == 200) {
          var data = response.data['data'];
          print("report");
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

  static Future<Map<String, dynamic>?> mockReport() async {
    try {
      var response = await HttpService.getForm(path: '/dashboard', body: {});
      if (response != null) {
        if (response.statusCode == 200) {
          var data = response.data['data'];
          print("report");
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

  static Future<List<String>?> groupsList() async {
    try {
      var response = await HttpService.getForm(path: '/groups/list', body: {});
      if (response != null) {
        if (response.statusCode == 200) {
          var data = response.data['data'];
          print(data);
          if (data != null) {
            List<String>? list =
                (data as List).map((item) => item as String).toList();
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

  static Future<List<BuffModel>?> buffs(String code) async {
    try {
      Map<String, String> body = {
        "type": code,
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

  static Future<bool?> addFinancial({
    String? name,
    String? type,
    String? date,
    String? price,
    String? weight,
  }) async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');

      Map<String, dynamic> body = {
        "name": name ?? "",
        "type": type ?? "",
        "price": price,
        "weight": weight,
        "date": date,
      };

      print(body);
      var response = await HttpService.postForm(path: '/financial', body: body);
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

  static Future<bool?> addBuff({
    required String? name,
    String? tag,
    required String? datetime,
    required String? gender,
    String? father,
    String? mother,
    String? source,
    String? type,
    String? species,
    String? price,
    String? blood,
    String? image,
    String? healthCheckupDate,
    String? healthCheckupType,
  }) async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');

      Map<String, String> body = {
        "name": name ?? "",
        "tag": tag ?? "",
        "gender": gender ?? "",
        "birth_date": datetime ?? "",
        "father_name": father ?? "",
        "mother_name": mother ?? "",
        "source": source ?? "",
        "type": type ?? "",
        "species": species ?? "",
        "price": price ?? "",
        "blood_percent": blood ?? "",
        "image_url": image ?? "",
        "health_checkup_type": healthCheckupType ?? "NULL",
        "health_checkup_date": healthCheckupDate ?? ""
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

  static Future<bool?> updateBuff({
    required String? id,
    required String? name,
    String? tag,
    required String? datetime,
    required String? gender,
    String? father,
    String? mother,
    String? source,
    String? type,
    String? species,
    String? price,
    String? blood,
    String? image,
    String? healthCheckupDate,
    String? healthCheckupType,
  }) async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');

      Map<String, String> body = {
        "name": name ?? "",
        "tag": tag ?? "",
        "gender": gender ?? "",
        "birth_date": datetime ?? "",
        "father_name": father ?? "",
        "mother_name": mother ?? "",
        "source": source ?? "",
        "type": type ?? "",
        "species": species ?? "",
        "price": price ?? "",
        "blood_percent": blood ?? "",
        "image_url": image ?? "",
        "health_checkup_type": healthCheckupType ?? "NULL",
        "health_checkup_date": healthCheckupDate ?? ""
      };

      print(body);
      var response =
          await HttpService.patchForm(path: '/buffs/$id', body: body);
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

  static Future<bool?> updateSickBuff(
      {required String? id, bool sick = false}) async {
    try {
      Map<String, String> body = {
        "sick": sick.toString(),
      };

      print(body);
      var response =
          await HttpService.patchForm(path: '/buffs/$id', body: body);
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

  static Future<String?> addInducting(
      {required String buffId,
      String? method,
      required DateTime date,
      required DateTime estrusReturnDate}) async {
    if (method == null) return "ไม่สามารถบันทึกได้";
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(date);
      final String estrusReturnFormatted = formatter.format(date);

      Map<String, dynamic> body = {
        "buff_id": buffId,
        "induction": true,
        "induction_method": method,
        "induction_date": formatted,
        "estrus_return_check_date": estrusReturnFormatted,
        "notify": true
      };

      print("BODY");
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
          String? message = response.data['detail']?.toString();
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

  static Future<String?> addNonInducting(
      {required String buffId,
      bool artificialInsemination = false,
      String? breederBreed,
      required DateTime date,
      required DateTime estrusReturnDate}) async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(date);
      final String estrusReturnFormatted = formatter.format(date);

      Map<String, dynamic> body = {
        "buff_id": buffId,
        "induction": false,
        "artificial_insemination": artificialInsemination,
        "estrus_return_check_date": estrusReturnFormatted,
        "breeder_breed": breederBreed,
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
          String? message = response.data['detail']?.toString();
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
        "name": vaccine_name,
        "other_name": otherVaccineName,
        "duration": otherVaccineDuration,
        "injected_date": formatted,
        "notify": true
      };

      print(body);
      var response =
          await HttpService.postForm(path: '/vaccine-injection', body: body);
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
      print(formatted);

      Map<String, dynamic> body = {
        "buff_id": buffId,
        "dewormer_type": anthelminticDrugName,
        "duration": nextDewormingDuration,
        "deworm_date": formatted,
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
      var response =
          await HttpService.postForm(path: '/disease-treatment', body: body);
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

  static Future<String?> addSold(
      {required String buffId,
      required DateTime sold_date,
      int? duration,
      String? note,
      String? buyer,
      String? channel,
      String? style}) async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(sold_date);

      Map<String, dynamic> body = {
        "buff_id": buffId,
        "sold_date": formatted,
        "duration": duration,
        "note": note,
        "buyer": buyer,
        "channel": channel,
        "style": style,
        "notify": true
      };

      print(body);
      var response = await HttpService.postForm(path: '/selling', body: body);
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
          print("DATA");
          print(data);
          if (data != null) {
            List<NotificationModel> list = data.map<NotificationModel>((item) {
              return NotificationModel.fromJson(item);
            }).toList();

            list.sort((a, b) {
              var adate = a.notify_datetime;
              var bdate = b.notify_datetime;
              if (adate != null && bdate != null) {
                return adate.compareTo(bdate);
              }
              return 0;
            });

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
