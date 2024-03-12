import 'package:flutter/cupertino.dart';
import 'package:flutter_srt_seungpil/constants/constants.dart';
import 'package:flutter_srt_seungpil/data/network/api_result.dart';
import 'package:flutter_srt_seungpil/data/network/model/request/login_req.dart';
import 'package:flutter_srt_seungpil/data/network/model/response/login_res.dart';
import 'package:flutter_srt_seungpil/ui/base/base_view_model.dart';
import 'package:flutter_srt_seungpil/ui/home/home_screen.dart';

import '../util/utils.dart';

class LoginScreenViewModel extends BaseViewModel{

  void requestLogin(String email, String pw, BuildContext context) {
      LoginReq loginReq = LoginReq(email: email, pw: pw);
      networkRepository.requestLogin(loginReq);
      defineNetworkResult(
        successAction: (ApiResult apiResult) {
          LoginRes loginRes = LoginRes.fromJson(apiResult.data);
          if (loginRes.code == Constants.NETWORK_COMMUNICATION_SUCCESS) {
            Utils.pushAndRemoveUntil(context, const HomeScreen());
          } else {
            baseErrorMssage = loginRes.message;
            baseShowErrorDialog = true;
          }
          notifyListeners();
        }
      );
  }
}