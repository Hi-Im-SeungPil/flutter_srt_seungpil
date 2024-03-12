import 'package:flutter/cupertino.dart';
import 'package:flutter_srt_seungpil/data/network/model/request/send_email_code_req.dart';
import 'package:flutter_srt_seungpil/data/network/api_result.dart';
import 'package:flutter_srt_seungpil/data/network/model/request/sign_up_req.dart';
import 'package:flutter_srt_seungpil/data/network/model/request/verify_code_req.dart';
import 'package:flutter_srt_seungpil/ui/base/base_view_model.dart';
import 'package:flutter_srt_seungpil/ui/util/errors.dart';

import '../../constants/constants.dart';
import '../../data/network/model/response/base_res.dart';
import '../util/utils.dart';

class SignUpScreenState {
  bool isSuccessSendEmailCode = false;
  bool isSuccessVerifyCode = false;
  bool showSendEmailErrorDialog = false;
  bool showVerifyCodeErrorDialog = false;
  bool completeSignUp = false;
}

class SignUpScreenViewModel extends BaseViewModel {
  final SignUpScreenState _state = SignUpScreenState();

  bool get isSuccessSendEmailCode => _state.isSuccessSendEmailCode;

  bool get isSuccessVerifyCode => _state.isSuccessVerifyCode;

  bool get showSendEmailErrorDialog => _state.showSendEmailErrorDialog;

  bool get showVerifyCodeErrorDialog => _state.showVerifyCodeErrorDialog;

  String get errorMessage => baseErrorMssage;

  bool get showErrorDialog => baseShowErrorDialog;

  bool get completeSignUp => _state.completeSignUp;

  /// 이메일 전송 요청 BaseRes
  void requestSendEmailCode(String userEmail) {
    SendEmailCodeReq sendEmailCodeReq = SendEmailCodeReq(email: userEmail);
    networkRepository.requestSendEmailCode(sendEmailCodeReq);
    defineNetworkResult(successAction: (ApiResult apiResult) {
      BaseRes result = BaseRes.fromJson(apiResult.data);
      if (result.code == Constants.NETWORK_COMMUNICATION_SUCCESS) {
        _state.isSuccessSendEmailCode = true;
      } else {
        baseErrorMssage = errorMessageMapper(ErrorType.EMAIL_SEND_ERROR);
        baseShowErrorDialog = true;
      }
      notifyListeners();
    }, apiErrorAction: (ApiResult apiResult) {
      _state.isSuccessSendEmailCode = false;
      notifyListeners();
    }, exceptionAction: (ApiResult apiResult) {
      _state.isSuccessSendEmailCode = false;
      notifyListeners();
    });
  }

  /// 코드 확인
  void requestVerifyCode(String code) {
    VerifyCodeReq verifyCodeReq = VerifyCodeReq(code: code);
    networkRepository.requestVerifyCode(verifyCodeReq);
    defineNetworkResult(successAction: (ApiResult apiResult) {
      BaseRes result = BaseRes.fromJson(apiResult.data);
      if (result.code == Constants.NETWORK_COMMUNICATION_SUCCESS) {
        _state.isSuccessVerifyCode = true;
      } else {
        baseErrorMssage = result.message;
        baseShowErrorDialog = true;
      }
      notifyListeners();
    }, apiErrorAction: (ApiResult apiResult) {
      _state.isSuccessVerifyCode = false;
      notifyListeners();
    }, exceptionAction: (ApiResult apiResult) {
      _state.isSuccessVerifyCode = false;
      notifyListeners();
    });
  }

  /// 회원가입 요청
  void requestSignUp(String name, String pwd, String email, String birth,
      BuildContext context) {
    SignUpReq signUpReq = SignUpReq(name, pwd, birth, email);
    networkRepository.requestSignUp(signUpReq);
    defineNetworkResult(successAction: (ApiResult apiResult) {
      BaseRes result = BaseRes.fromJson(apiResult.data);
      if (result.code == Constants.NETWORK_COMMUNICATION_SUCCESS) {
        _state.completeSignUp = true;
        Utils.pop(context);
      } else {
        baseErrorMssage = result.message;
        baseShowErrorDialog = true;
      }
      notifyListeners();
    });
  }
}
