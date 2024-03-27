import 'dart:convert';

import 'package:flutter/services.dart';

Future<List<dynamic>> readJson(String filePath) async {
  final String response = await rootBundle.loadString(filePath);
  return json.decode(response);
}