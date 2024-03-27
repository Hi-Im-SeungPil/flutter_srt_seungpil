import 'package:flutter/cupertino.dart';
import 'package:flutter_srt_seungpil/constants/constants.dart';
import 'package:flutter_srt_seungpil/data/network/api_result.dart';
import 'package:flutter_srt_seungpil/data/network/model/request/login_req.dart';
import 'package:flutter_srt_seungpil/data/network/model/response/login_res.dart';
import 'package:flutter_srt_seungpil/ui/base/base_view_model.dart';
import 'package:flutter_srt_seungpil/ui/home/home_screen.dart';
import 'package:flutter_srt_seungpil/ui/home/home_screen_route.dart';
import 'package:flutter_srt_seungpil/ui/util/manager/preferences_manager.dart';

import '../../constants/keys.dart';
import '../util/utils.dart';

class LoginScreenViewModel extends BaseViewModel {
  String get errorMessage => baseErrorMessage;

  bool get showErrorDialog => baseShowErrorDialog;

  void requestLogin(
      String email, String pw, BuildContext context, bool checkBoxState) async {
    LoginReq loginReq = LoginReq(email: email, pw: pw);
    networkRepository.requestLogin(loginReq);
    defineNetworkResult(successAction: (ApiResult apiResult) {
      LoginRes loginRes = LoginRes.fromJson(apiResult.data);
      if (loginRes.code == Constants.NETWORK_COMMUNICATION_SUCCESS) {
        if (checkBoxState) {
          PreferencesManager.setData(Keys.PREF_KEY_SAVED_ID, email);
        } else {
          PreferencesManager.removeData(Keys.PREF_KEY_SAVED_ID);
        }
        Utils.pushAndRemoveUntil(context, const HomeScreenRoute());
      } else {
        baseErrorMessage = loginRes.message;
        baseShowErrorDialog = true;
      }
      notifyListeners();
    });
  }
}
