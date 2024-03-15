import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/constants/keys.dart';
import 'package:flutter_srt_seungpil/ui/base/base_state_holder.dart';
import 'package:flutter_srt_seungpil/ui/util/manager/preferences_manager.dart';

class LoginScreenStateHolder extends BaseStateHolder {
  TextEditingController idEditingController = TextEditingController();
  TextEditingController pwdEditingController = TextEditingController();
  bool isSaveId = false;

  void loginButtonAction(
      Function(
              String email, String pw, BuildContext context, bool checkBoxState)
          requestLogin,
      BuildContext context) {
    requestLogin(
        idEditingController.text, pwdEditingController.text, context, isSaveId);
  }

  void updateIsSaveId(bool value) {
    isSaveId = value;
  }

  Future<String?> getSavedId() async {
    if (await PreferencesManager.getBool(Keys.PREF_KEY_IS_SAVE_ID)) {
      String id = await PreferencesManager.getString(Keys.PREF_KEY_SAVED_ID);
      idEditingController.text = id;
      return id;
    } else {
      return null;
    }
  }

  void checkBoxOnChanged(bool value) async {
    await PreferencesManager.setData(Keys.PREF_KEY_IS_SAVE_ID, value);
    isSaveId = value;
  }
}
