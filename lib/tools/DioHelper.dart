import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioHelper {
  final Dio dio;

  static Future<DioHelper> init() async {
    DioHelper dio = DioHelper(dio: Dio());
    await dio.initializeToken();
    return dio;
  }

  DioHelper({required this.dio});

  static const String _baseUrl = "https://api.melonkemo.com/v1/buffaloes";
  String token = "";
  FlutterSecureStorage storage = const FlutterSecureStorage();

  initializeToken() async {
    String? user_uid = await storage.read(key: "user_uid".toUpperCase());
    print("user_uid: ${user_uid}");

    String? accessToken = await storage.read(key: "access_token".toUpperCase());
    print("accessToken: ${accessToken}");
    token = accessToken ?? "";
    print("token: ${token}");

    initApiClient();
  }

  Future<void> initApiClient() async {
    dio.interceptors.clear();
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      options.headers['Authorization'] = "Bearer $token";

      return handler.next(options); //continue
    }, onResponse: (Response response, ResponseInterceptorHandler handler) {
      return handler.next(response); // continue
    }, onError: (DioError error, ErrorInterceptorHandler handler) async {
      if (error.response != null) {
        var response = error.response!;
        if (response.statusCode == 401) {
          try {
            String? refreshToken =
                await storage.read(key: "refresh_token".toUpperCase());
            dio.options.headers['Authorization'] =
                "Bearer $refreshToken";

            Dio anotherDio = Dio();
            anotherDio.options.headers['Authorization'] =
                "Bearer $refreshToken";

            Response<dynamic> data = await anotherDio.post("$_baseUrl/refresh");
            String newToken = data.data['access_token'];
            token = newToken;
            await storage.write(
                key: "access_token".toUpperCase(), value: newToken);

            response.requestOptions.headers['Authorization'] =
                "Bearer $newToken";

            Response newResponse = await anotherDio.request(
                "$_baseUrl${error.requestOptions.path}",
                options: Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers),
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters);

            return handler.resolve(newResponse);

          } catch (err) {
            print(err);
            print("ERROR");
            return handler.next(error); //continue
          }
        }
      }
      return handler.next(error); //continue
    }));
    dio.options.baseUrl = _baseUrl;
  }

  Future<dynamic> get(String url, {required data}) async {
    try {
      final response = await dio.get(url, queryParameters: data);
      return response;
    } on DioError catch (e) {
      print('[Dio Helper - GET] Connection Exception => ${e.message}');
      rethrow;
    }
  }

  Future<dynamic> post(String url,
      {Map<String, dynamic>? headers, required data, encoding}) async {
    try {
      final response =
          await dio.post(url, data: data, options: Options(headers: headers));

      return response;
    } on DioError catch (e) {
      print('[Dio Helper - GET] Connection Exception => ${e.message}');
      rethrow;
    }
  }
}
