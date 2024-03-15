import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/ui/base/base_state_holder.dart';
import 'package:flutter_srt_seungpil/ui/signup/sign_up_screen_view_model.dart';

import '../common/common_dialog.dart';
import '../util/log.dart';

class SignUpScreenStateHolder extends BaseStateHolder{
  TextEditingController idController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();

  bool isNameSuccess = false;
  bool isBirthSuccess = false;
  bool isPwdSuccess = false;
  bool isVerifyPwdSuccess = false;

  final RegExp emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  bool isCorrectEmail = false;

  SignUpScreenStateHolder();

  void sendEmailBtnAction(Function(String) requestSendEmailCode) {
    if (emailRegex.hasMatch(idController.text)) {
      isCorrectEmail = true;
      requestSendEmailCode(idController.text);
    } else {
      isCorrectEmail = false;
    }
  }

  void verifyCodeBtnAction(Function(String) requestVerifyCode) {
    requestVerifyCode(codeController.text);
  }

  void signUpBtnAction(
      Function(String name, String pwd, String email, String birth,
              BuildContext context)
          requestSignUp,
      bool isVerifyCode,
      BuildContext context) {
    Log.d(message: "$isVerifyCode $isPwdSuccess $isVerifyPwdSuccess}", name: "spspsp");
    if (isVerifyCode && isPwdSuccess && isVerifyPwdSuccess) {
      requestSignUp(nameController.text, confirmPwdController.text,
          idController.text, birthController.text, context);
    }
  }

  String errorCheck(String title) {
    switch (title) {
      case "아이디":
        if (!emailRegex.hasMatch(idController.text)) {
          return "이메일 형식이 아닙니다.";
        } else {
          return "";
        }
      case "비밀번호 확인":
        if (!(pwdController.text == confirmPwdController.text)) {
          return "비밀번호가 일치하지 않습니다.";
        } else {
          return "";
        }
      default:
        return "";
    }
  }

  // void showErrorDialog(BuildContext context, bool visible,
  //     Function() errorDialogDismissAction, String message) {
  //   if (visible) {
  //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //       showDialog(
  //           context: context,
  //           builder: (context) {
  //             return commonDialog(context, content: message,
  //                 positiveAction: () {
  //               errorDialogDismissAction;
  //             });
  //           });
  //     });
  //   }
  // }

  void updateSignUpTask(String title) {
    Log.d(message: confirmPwdController.text ,name: "비밀번호 확인/");
    switch (title) {
      case "비밀번호":
        if (pwdController.text.length >= 8) {
          isPwdSuccess = true;
        }
        break;
      case "비밀번호 확인":
        if (confirmPwdController.text.length >= 8 &&
            confirmPwdController.text == pwdController.text) {
          isVerifyPwdSuccess = true;
        }
        break;
    }
  }

  void popScreen(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    idController.dispose();
    codeController.dispose();
    nameController.dispose();
    birthController.dispose();
    pwdController.dispose();
    confirmPwdController.dispose();
  }
}
