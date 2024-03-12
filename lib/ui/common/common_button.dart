import 'package:flutter/material.dart';

Widget commonButton(
    {required Function() onPressed,
      required double width,
      required double height,
      required String buttonText}) {
  return SizedBox(
      width: width,
      height: height,
      child: TextButton(
          style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xFF476EFF)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)))),
          ),
          onPressed: () {
            onPressed();
          },
          child: Text(buttonText,
              style: const TextStyle(color: Color(0xffffffff)))));
}