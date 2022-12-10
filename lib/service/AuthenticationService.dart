import 'dart:convert';

import 'package:buffaloes_farm_management/models/AuthenticateModel.dart';
import 'package:buffaloes_farm_management/service/HttpService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class AuthenticationService {
  static Future<AuthenticateModel?> login({required String? token}) async {
    try {
      Map<String, String> body = {
        //"email": "",
        //"password": "",
        "token": token ?? ""
      };
      var response = await HttpService.postForm(path: '/login', body: body);
      print(response);
      if (response != null) {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.data);
          AuthenticateModel? result =
          AuthenticateModel.fromJson(response.data);

          print(result.access_token);
          print(result.refresh_token);
          print(result.farm_name);


          FlutterSecureStorage storage = const FlutterSecureStorage();
          await storage.write(key: "access_token".toUpperCase(), value: result.access_token);
          await storage.write(key: "refresh_token".toUpperCase(), value: result.refresh_token);
          await storage.write(key: "farm_name".toUpperCase(), value: result.farm_name);

          return result;
        }
      }

      return null;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<AuthenticateModel?> register({
    required String? farmName,
    required String? firstName,
    required String? lastName,
    required String? phoneNumber,
    String? address,
    required String? token,
    required String? province,
    required String? district,
    required String? subDistrict,
  }) async {
    try {
      Map<String, String> body = {
        "farm_name": farmName ?? "",
        "first_name": firstName ?? "",
        "last_name": lastName ?? "",
        "phone_number": phoneNumber ?? "",
        "address": address ?? "",
        "token": token ?? "",
        "province": province ?? "",
        "district": district ?? "",
        "sub_district": subDistrict ?? ""
      };
      print(body);
      var response = await HttpService.postForm(path: '/register', body: body);
      print("response: $response");
      if (response != null) {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.data);
          AuthenticateModel? result =
              AuthenticateModel.fromJson(response.data);

          FlutterSecureStorage storage = const FlutterSecureStorage();
          await storage.write(key: "access_token".toUpperCase(), value: result.access_token);
          await storage.write(key: "refresh_token".toUpperCase(), value: result.refresh_token);
          await storage.write(key: "farm_name".toUpperCase(), value: result.farm_name);

          return result;
        }
      }

      return null;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }
}
