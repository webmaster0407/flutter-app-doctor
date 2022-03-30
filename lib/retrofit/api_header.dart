import 'package:doctro/constant/prefConstatnt.dart';
import 'package:doctro/constant/preferences.dart';
import 'package:dio/dio.dart';

class RetroApi {

  Dio dioData()
  {
    final dio = Dio();
    dio.options.headers["Accept"] = "application/json"; // config your dio headers globally
    dio.options.headers["Authorization"] = "Bearer" + " " + SharedPreferenceHelper.getString(Preferences.auth_token); // config your dio headers globally
    dio.options.headers["Content-Type"] = "application/x-www-form-urlencoded";
    dio.options.followRedirects = false;
    dio.options.connectTimeout = 75000; //5s
    dio.options.receiveTimeout = 3000;
    return dio;
  }
}