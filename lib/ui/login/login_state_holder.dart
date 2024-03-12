import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_srt_seungpil/constants/keys.dart';
import 'package:flutter_srt_seungpil/ui/util/manager/preferences_manager.dart';

class LoginScreenStateHolder {
  TextEditingController idEditingController = TextEditingController();
  TextEditingController pwdEditingController = TextEditingController();
  bool isSaveId = false;

  LoginScreenStateHolder() {
    // init();
  }

  // void init() async {
  //   isSaveId = await PreferencesManager.getBool(Keys.PREF_KEY_IS_SAVE_ID);
  // }

  void updateIsSaveId(bool value) {
    isSaveId = value;
  }

  Future<bool> getIsSaveId() async {
    return await PreferencesManager.getBool(Keys.PREF_KEY_IS_SAVE_ID);
  }

  void checkBoxOnChanged(bool value) async {
    await PreferencesManager.setData(Keys.PREF_KEY_IS_SAVE_ID, value);
    isSaveId = value;
  }
}
