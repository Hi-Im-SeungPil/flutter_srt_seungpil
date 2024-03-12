import 'package:dio/dio.dart';
import 'package:flutter_srt_seungpil/constants/url.dart';

class SrtDio {
  static final Dio _dio = Dio(
      BaseOptions(
          baseUrl: URL_BASE,
          receiveDataWhenStatusError: true
      )
  );

  static Dio getDio() {
    return _dio;
  }

  static Future<Response> requestGet(String url,
      {Map<String, dynamic>? queryParameter}) async {
    if (queryParameter != null) {
      return await getDio().get(url, queryParameters: queryParameter);
    } else {
      return await getDio().get(url);
    }
  }

  static Future<Response> requestPost(String url, {Map<String, dynamic>? body}) async {
    if (body != null) {
      return await getDio().post(url, data: body);
    } else {
      return await getDio().post(url);
    }
  }
}