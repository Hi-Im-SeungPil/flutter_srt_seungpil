import 'package:dio/dio.dart';

enum Status { LOADING, SUCCESS, API_ERROR, EXCEPTION }

class ApiResult {
  final Status status;
  final dynamic data;
  final String? message;

  ApiResult({required this.status, required this.data, required this.message});

  static ApiResult success(dynamic data) {
    return ApiResult(status: Status.SUCCESS, data: data, message: null);
  }

  static ApiResult error(dynamic data, String message) {
    return ApiResult(status: Status.API_ERROR, data: null, message: message);
  }

  static ApiResult exception(Exception exception) {
    return ApiResult(
        status: Status.EXCEPTION,
        data: null,
        message: exception.toString());
  }

  static ApiResult loading() {
    return ApiResult(status: Status.LOADING, data: null, message: null);
  }
}
