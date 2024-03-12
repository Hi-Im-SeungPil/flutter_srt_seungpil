import 'base_req.dart';

class SendEmailCodeReq extends BaseReq{
  String email;

  SendEmailCodeReq({required this.email});

  Map<String, dynamic> toMap() {
    return {'email': email};
  }
}
