import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/common_dialog.dart';

class BaseStateHolder {
  void showErrorDialog(BuildContext context, bool visible,
      Function() errorDialogDismissAction, String message) {
    if (visible) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showDialog(
            context: context,
            builder: (context) {
              return commonDialog(context, content: message,
                  positiveAction: () {
                errorDialogDismissAction();
              });
            });
      });
    }
  }
}