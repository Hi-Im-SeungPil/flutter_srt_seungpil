import 'dart:convert';

import 'base_res.dart';

class LoginRes extends BaseRes {
  String name = "";

  LoginRes({required super.code, required super.message, required super.data}) {
    name = data!['name'];
  }

  factory LoginRes.fromJson(Map<String, dynamic> json) {
    return LoginRes(
        code: json['code'], message: json['message'], data: json['data']);
  }
}
