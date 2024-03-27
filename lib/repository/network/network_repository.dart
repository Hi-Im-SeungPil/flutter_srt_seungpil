import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_srt_seungpil/constants/url.dart';
import 'package:flutter_srt_seungpil/data/network/model/request/send_email_code_req.dart';
import 'package:flutter_srt_seungpil/data/network/model/request/sign_up_req.dart';
import 'package:flutter_srt_seungpil/data/network/model/request/time_table_req.dart';
import 'package:flutter_srt_seungpil/data/network/model/request/verify_code_req.dart';
import 'package:flutter_srt_seungpil/data/network/api_result.dart';

import '../../data/network/model/request/login_req.dart';
import '../../data/network/srt_dio.dart';
import 'dart:developer' as developer;

import '../../ui/util/log.dart';

class NetworkRepository {
  StreamController? _streamController;

  StreamController getStreamController() {
    _streamController ??= StreamController.broadcast();
    return _streamController!;
  }

  /// 이메일 인증 코드 보냄.
  void requestSendEmailCode(SendEmailCodeReq sendEmailCodeReq) {
    call(URL_REQ_SEND_EMAIL,
        params: sendEmailCodeReq.toMap(), isGetMethod: true);
  }
  /// 인증 코드 확인
  void requestVerifyCode(VerifyCodeReq verifyCodeReq) {
    call(URL_REQ_VERIFY_EMAIL_CODE, params: verifyCodeReq.toMap());
  }
  /// 가입 요청
  void requestSignUp(SignUpReq signUpReq) {
    call(URL_REQ_SIGN_UP,params: signUpReq.toMap());
  }
  /// 로그인 요청
  void requestLogin(LoginReq loginReq) {
    call(URL_REQ_LOGIN, params: loginReq.toMap());
  }

  /// request srtInfo
  void requestSrtInfo() {
    call(URL_REQ_SRT_INFO);
  }

  /// 기차 조회하기
  void requestSrtTimeTable(TimeTableReq timeTableReq) {
    call(URL_REQ_SRT_TIME_TABLE, params: timeTableReq.toMap());
  }

  /// 통신 로직
  void call(url, {Map<String, dynamic>? params, bool? isGetMethod}) async {
    StreamController streamController = getStreamController();
    streamController.add(ApiResult.loading());
    try {
      Response response;
      if (isGetMethod != null) {
        response = await SrtDio.requestGet(url, queryParameter: params);
      } else {
        response = await SrtDio.requestPost(url, body: params);
      }
      Log.d(message: response.statusCode.toString(), name: "Status Code");
      Log.d(message: response.data.toString(), name: "Api Result");
      if (response.statusCode == 200) {
        streamController.add(ApiResult.success(response.data));
      } else {
        streamController.add(ApiResult(
            status: Status.API_ERROR,
            data: null,
            message: response.statusCode.toString()));
      }
    } on Exception catch (e, _) {
      streamController.add(ApiResult(
          status: Status.EXCEPTION, data: null, message: e.toString()));
      developer.log(e.toString());
    }
    _streamController!.close();
    _streamController = null;
  }
}
