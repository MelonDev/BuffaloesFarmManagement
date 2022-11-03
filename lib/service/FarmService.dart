import 'package:buffaloes_farm_management/models/BuffModel.dart';
import 'package:buffaloes_farm_management/service/HttpService.dart';

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
        }else {
          return false;
        }
      }

      return null;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }
}
