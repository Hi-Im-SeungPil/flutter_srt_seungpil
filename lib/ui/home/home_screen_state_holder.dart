import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/ui/base/base_state_holder.dart';
import 'package:flutter_srt_seungpil/ui/select_station/select_station_route.dart';

import '../util/log.dart';
import '../util/utils.dart';

const int emptyValue = -1;
const String emptyStringValue = "-1";

class HomeScreenStateHolder extends BaseStateHolder {
  TextEditingController selectDateController = TextEditingController();
  TextEditingController selectPersonCountController = TextEditingController();
  int personCount = 1;
  String depDate = "";
  String depTime = "";
  String departureStationCode = emptyStringValue;
  String departureStationName = "";
  String destinationStationCode = emptyStringValue;
  String destinationStationName = "";

  HomeScreenStateHolder() {
    DateTime now = DateTime.now();
    depDate = depDateMapper(now);
    depTime = "${now.hour}";
    selectDateController.text =
        "${now.year}.${now.month}.${now.day}(${Utils.weekDayMapper(now.weekday)}) $depTime시 이후";
    selectPersonCountController.text = "총 1명";
  }

  void moveSelectStation(
      BuildContext context,
      bool isDeparture,
      Function(String departureStationName, String destinationStationName)
          setStationName) async {
    Map<String, dynamic> data = {
      'departureStationCode': departureStationCode,
      'departureStationName': departureStationName,
      'destinationStationCode': destinationStationCode,
      'destinationStationName': destinationStationName,
      'isDeparture': isDeparture
    };
    Map<String, dynamic> result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const SelectStationScreenRoute(),
            settings: RouteSettings(
              arguments: data,
            )));

    if (result != null) {
      departureStationCode = result['departureStationCode'] ?? emptyStringValue;
      departureStationName = result['departureStationName'] ?? "";
      destinationStationCode =
          result['destinationStationCode'] ?? emptyStringValue;
      destinationStationName = result['destinationStationName'] ?? "";
      setStationName(departureStationName, destinationStationName);
    }
  }

  void setPersonCount(int selectedIndex) {
    personCount = selectedIndex + 1;
  }

  bool getButtonEnabled() {
    return departureStationCode != emptyStringValue &&
        destinationStationCode != emptyStringValue;
  }

  void changeStations() {
    String tempDepartureStationCode = departureStationCode;
    departureStationCode = destinationStationCode;
    destinationStationCode = tempDepartureStationCode;

    String tempDepartureStationName = departureStationName;
    departureStationName = destinationStationName;
    destinationStationName = tempDepartureStationName;
  }

  void searchSrtButtonAction(
      Function(
        String depPlaceId,
        String arrPlaceId,
        String depPlandDate,
        String depPlandTime,
      ) requestSrtTimeTable) {
    Log.d(message: depDate, name: depTime);
    requestSrtTimeTable(
        departureStationCode, destinationStationCode, depDate, depTimeMapper());
  }

  String depDateMapper(DateTime dateTime) {
    return "${dateTime.year.toString()}${dateTime.month.toString().padLeft(2, '0')}${dateTime.day.toString().padLeft(2, '0')}";
  }

  String depTimeMapper() {
    if(depTime.length == 1) {
      "0$depTime";
    }
    return "${depTime}00";
  }
}
