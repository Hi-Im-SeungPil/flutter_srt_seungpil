import 'package:flutter/cupertino.dart';

class ReservationScreenStateHolder extends ChangeNotifier{
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController pwdConfirmController = TextEditingController();
  String name = "";
  String phoneNum = "";

  void doMasking(bool isName) {
    if (isName) {
      name = nameController.text;
      nameController.text =
      "${name.substring(0, 1)}${"*" * (name.length - 2)}${name.substring(
          name.length - 1)}";
    } else {
      phoneNum = phoneNumController.text;
      phoneNumController.text =
      "${phoneNum.substring(0, 5)}**${phoneNum.substring(8, 10)}**";
    }
  }

  bool isAllReady() {
    return nameController.text.isNotEmpty &&
        phoneNumController.text.isNotEmpty && pwdController.text.length == 5 &&
        pwdConfirmController.text.length == 5 &&
        pwdController.text == pwdConfirmController.text;
  }
}
