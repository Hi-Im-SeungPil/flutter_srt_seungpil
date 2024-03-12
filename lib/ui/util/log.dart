import 'dart:developer' as dev;

class Log {
  static d({String? message = "", String? name = ""}) {
    dev.log(message!, name: name!);
  }
}
