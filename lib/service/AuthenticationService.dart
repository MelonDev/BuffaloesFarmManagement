import 'dart:convert';

import 'package:buffaloes_farm_management/models/AuthenticateModel.dart';
import 'package:buffaloes_farm_management/pages/authentication/login_page.dart';
import 'package:buffaloes_farm_management/pages/farm/farm_info_page.dart';
import 'package:buffaloes_farm_management/service/HttpService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class AuthenticationService {
  static Future<AuthenticateModel?> login({required String? phone}) async {
    try {
      Map<String, String> body = {
        //"email": "",
        //"password": "",
        "phone": phone ?? ""
      };
      var response = await HttpService.postForm(path: '/login', body: body);
      print(response);
      if (response != null) {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.data);
          AuthenticateModel? result = AuthenticateModel.fromJson(response.data);

          print(result.access_token);
          print(result.refresh_token);
          print(result.farm_name);

          FlutterSecureStorage storage = const FlutterSecureStorage();
          await storage.write(
              key: "access_token".toUpperCase(), value: result.access_token);
          await storage.write(
              key: "refresh_token".toUpperCase(), value: result.refresh_token);
          await storage.write(
              key: "farm_name".toUpperCase(), value: result.farm_name);
          await storage.write(key: "phone_number".toUpperCase(), value: phone);
          await storage.write(
              key: "admin".toUpperCase(), value: result.admin ? "1" : "0");

          return result;
        } else if (response.statusCode == 404) {
          return NotFoundAuthenticateModel.fromJson({});
          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => FarmInfoPage()));

          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) => FarmInfoPage()),
          //         (Route<dynamic> route) => route is LoginPage);
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
    String? group,
    String? token,
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
        "group": group ?? "",
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
          AuthenticateModel? result = AuthenticateModel.fromJson(response.data);

          FlutterSecureStorage storage = const FlutterSecureStorage();
          await storage.write(
              key: "access_token".toUpperCase(), value: result.access_token);
          await storage.write(
              key: "refresh_token".toUpperCase(), value: result.refresh_token);
          await storage.write(
              key: "farm_name".toUpperCase(), value: result.farm_name);
          await storage.write(
              key: "phone_number".toUpperCase(), value: phoneNumber);

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
