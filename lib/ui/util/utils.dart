
import 'package:flutter/material.dart';

class Utils {
  static void push(BuildContext context, Widget target) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => target));
  }

  static void pushAndRemoveUntil(BuildContext context, Widget target) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => target), (route) => false);
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}