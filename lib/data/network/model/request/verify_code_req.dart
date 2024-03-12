class VerifyCodeReq {
  String code;

  VerifyCodeReq({required this.code});

  Map<String, dynamic> toMap() {
    return {'code': code};
  }
}