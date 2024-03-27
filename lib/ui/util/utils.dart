import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static void push(BuildContext context, Widget target) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => target));
  }

  static void pushAndRemoveUntil(BuildContext context, Widget target) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => target), (route) => false);
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

  static Future<void> urlLauncher(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  static String weekDayMapper(int day) {
    switch (day) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '';
    }
  }
}

AppLocalizations getStrings(BuildContext context) {
  return AppLocalizations.of(context)!;
}
