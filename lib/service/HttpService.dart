import 'dart:convert';
import 'dart:io';
import 'package:buffaloes_farm_management/cubit/authentication/authentication_cubit.dart';
import 'package:buffaloes_farm_management/tools/DioHelper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class HttpService {
  static const String baseUrl = "https://api.melonkemo.com/v1/buffaloes";

  static const Map<String, String> headers = {
    //'Authorization': 'Basic cGRhX2FwcDpzZWNyZXRrZXk=',
    //'x-api-key': 'ASMjY6HQ4TyV7R11e0w9Dn4WNrheY0YE',
    'Content-Type': 'application/json'
    //'Content-Type': 'application/x-www-form-urlencoded'
  };

  static Future<http.StreamedResponse?> get(
      {required String path, Map<String, String>? body, String? url}) async {
    try {
      print("GET: $url");
      print("BODY: $body");
      String masterUrl = url ?? baseUrl;
      var request = http.Request('GET', Uri.parse('$masterUrl$path'));
      if (body != null) {
        request.body = json.encode(body);
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      return response;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<Response?> getForm(
      {required String path, Map<String, String>? body}) async {
    try {
      var formData = FormData.fromMap(body ?? {});
      DioHelper dio = await DioHelper.init();

      var response = await dio.get(path, data: body);

      return response;
    } on Exception catch (e) {
      if (e is DioError) {
        print(e.message);
        print(e.response?.statusCode);
        print(e.response?.data);
      } else {
        print(e);
      }
      return null;
    }
  }

  static Future<http.StreamedResponse?> delete(
      {required String path, Map<String, String>? body}) async {
    try {
      var request = http.Request('DELETE', Uri.parse('$baseUrl$path'));
      if (body != null) {
        request.body = json.encode(body);
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      return response;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<http.StreamedResponse?> post(
      {required String path, Map<String, String>? body}) async {
    try {
      var request = http.Request('POST', Uri.parse('$baseUrl$path'));
      if (body != null) {
        request.body = json.encode(body);
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      return response;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<Response?> postForm(
      {required String path, Map<String, dynamic>? body}) async {
    try {
      var formData = FormData.fromMap(body ?? {});
      DioHelper dio = await DioHelper.init();

      var response = await dio.post(path, data: formData);

      return response;
    } on Exception catch (e) {
      if (e is DioError) {
        print(e.message);
        print(e.response?.statusCode);
        print(e.response?.data);
        return e.response;
      } else {
        print(e);
      }
      return null;
    }
  }

  static Future<http.StreamedResponse?> postList(
      {required String path, List<Map<String, String>>? body}) async {
    try {
      var request = http.Request('POST', Uri.parse('$baseUrl$path'));
      if (body != null) {
        request.body = json.encode(body);
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      return response;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<String?> strFromResponse(http.StreamedResponse response) async {
    try {
      String value = await response.stream.bytesToString();
      return value;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<List<dynamic>?> listFromResponse(
      http.StreamedResponse response) async {
    try {
      String value = await response.stream.bytesToString();
      print(value);
      List<dynamic> valueList = json.decode(value);
      return valueList;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<List<dynamic>?> listFromSpecialMapResponse(
      http.StreamedResponse response) async {
    try {
      String value = await response.stream.bytesToString();
      print(value);
      List<dynamic> valueList = json.decode("[$value]");
      return valueList;
    } on Exception catch (_) {
      return null;
    }
  }

  static List<dynamic>? listFromStrResponse(String? strValue) {
    try {
      if (strValue != null) {
        List<dynamic> valueList = json.decode(strValue);
        return valueList;
      }
      return null;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<String?> uploadToFirebaseByBytes(Uint8List bytes) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = await AuthenticationCubit().currentUserUid();

    if (uid != null) {
      Reference ref = storage
          .ref()
          .child("images")
          .child(uid)
          .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

      // var metadata = SettableMetadata(
      //   contentType: 'image/${file.extension}',
      // );

      TaskSnapshot snapshot = await ref.putData(bytes);
      print(snapshot.state);

      if (snapshot.state == TaskState.success) {
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      }

      // TaskSnapshot snapshot =
      //     kIsWeb ? await ref.putData(bytes) : await ref.putFile(file);

      //TaskSnapshot snapshot = await ref.putFile(file, metadata);

      //print(snapshot.state);
      // if (snapshot.state == TaskState.success) {
      //   String downloadUrl = await snapshot.ref.getDownloadURL();
      //   return downloadUrl;
      // }
      return null;
    } else {
      return null;
    }
  }

  static Future<String?> uploadToFirebase(File file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = await AuthenticationCubit().currentUserUid();

    if (uid != null) {
      Reference ref = storage
          .ref()
          .child("images")
          .child(uid)
          .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

      // var metadata = SettableMetadata(
      //   contentType: 'image/${file.extension}',
      // );
      print(file.path);

      Uint8List? bytes;
      bytes = await file.readAsBytes().then((value) {
        bytes = Uint8List.fromList(value);
        print('reading of bytes is completed');
      }).catchError((onError) {
        print('Exception Error while reading audio from path: $onError');
      });

      if (bytes != null) {
        TaskSnapshot snapshot = await ref.putData(bytes!);
        print(snapshot.state);

        if (snapshot.state == TaskState.success) {
          String downloadUrl = await snapshot.ref.getDownloadURL();
          return downloadUrl;
        }
      }
      // TaskSnapshot snapshot =
      //     kIsWeb ? await ref.putData(bytes) : await ref.putFile(file);

      //TaskSnapshot snapshot = await ref.putFile(file, metadata);

      //print(snapshot.state);
      // if (snapshot.state == TaskState.success) {
      //   String downloadUrl = await snapshot.ref.getDownloadURL();
      //   return downloadUrl;
      // }
      return null;
    } else {
      return null;
    }
  }
}
