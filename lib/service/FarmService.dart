import 'package:buffaloes_farm_management/service/HttpService.dart';

class FarmService {
  static Future<bool?> buffs() async {
    try {
      Map<String, String> body = {
        //"email": "",
        //"password": "",
      };
      var response = await HttpService.getForm(path: '/buffs', body: body);
      if (response != null) {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.data);
          return null;
        }
      }

      return null;
    } on Exception catch (_) {
      return null;
    }
  }

}