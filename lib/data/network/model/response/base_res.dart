class BaseRes {
  int code;
  String message;
  Map<String, dynamic>? data;

  BaseRes({required this.code, required this.message, this.data});

  factory BaseRes.fromJson(Map<String, dynamic> json) {
    return BaseRes(
      code: json['code'],
      message: json['message'],
      data: json['data'],
    );
  }
}