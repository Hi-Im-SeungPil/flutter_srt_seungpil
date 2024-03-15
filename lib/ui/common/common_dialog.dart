import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/ui/util/log.dart';

Widget commonDialog(BuildContext context,
    {String? title = "",
    String? content = "",
    String? negativeText = "취소",
    String? positiveText = "확인",
    Function()? positiveAction,
    Function()? negativeAction,
    bool? isOneButton = true}) {
  Log.d(message: "common Dialog", name: "name");
  return AlertDialog(
    title: Visibility(visible: title!.isNotEmpty, child: Text(title)),
    content: Visibility(visible: content!.isNotEmpty, child: Text(content)),
    actions: [
      Row(
        children: [
          Visibility(
              visible: !isOneButton!,
              child: TextButton(
                  onPressed: () {
                    if (negativeAction != null) {
                      negativeAction();
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(negativeText!))),
          TextButton(
              onPressed: () {
                if (positiveAction != null) {
                  positiveAction();
                }
                Navigator.of(context).pop();
              },
              child: Text(positiveText!))
        ],
      )
    ],
  );
}
