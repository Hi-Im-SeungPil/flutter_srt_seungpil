import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/ui/base/base_state_holder.dart';
import 'package:flutter_srt_seungpil/ui/select_station/select_station_route.dart';

import '../../constants/keys.dart';
import '../check_screen/srt_check_screen_route.dart';
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
  late DateTime lastSelectDate;
  String departureStationCode = emptyStringValue;
  String departureStationName = "";
  String destinationStationCode = emptyStringValue;
  String destinationStationName = "";

  HomeScreenStateHolder() {
    DateTime now = DateTime.now();
    lastSelectDate = now;
    depDate = Utils.depDateMapper(now);
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
      Keys.PUSH_DATA_KEY_DEPARTURE_STATION_CODE: departureStationCode,
      Keys.PUSH_DATA_KEY_DEPARTURE_STATION_NAME: departureStationName,
      Keys.PUSH_DATA_KEY_DESTINATION_STATION_CODE: destinationStationCode,
      Keys.PUSH_DATA_KEY_DESTINATION_STATION_NAME: destinationStationName,
      Keys.PUSH_DATA_KEY_IS_DEPARTURE: isDeparture
    };
    Map<String, dynamic> result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const SelectStationScreenRoute(),
            settings: RouteSettings(
              arguments: data,
            )));

    if (result != null) {
      departureStationCode = result[Keys.PUSH_DATA_KEY_DEPARTURE_STATION_CODE] ?? emptyStringValue;
      departureStationName = result[Keys.PUSH_DATA_KEY_DEPARTURE_STATION_NAME] ?? "";
      destinationStationCode =
          result[Keys.PUSH_DATA_KEY_DESTINATION_STATION_CODE] ?? emptyStringValue;
      destinationStationName = result[Keys.PUSH_DATA_KEY_DESTINATION_STATION_NAME] ?? "";
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

  void searchSrtButtonAction(BuildContext context) {
    Log.d(message: depDate, name: depTime);
    Map<String, dynamic> data = {
      Keys.PUSH_DATA_KEY_DEPARTURE_STATION_CODE: departureStationCode,
      Keys.PUSH_DATA_KEY_DEPARTURE_STATION_NAME: departureStationName,
      Keys.PUSH_DATA_KEY_DESTINATION_STATION_CODE: destinationStationCode,
      Keys.PUSH_DATA_KEY_DESTINATION_STATION_NAME: destinationStationName,
      Keys.PUSH_DATA_KEY_SELECTED_DATE: lastSelectDate,
      Keys.PUSH_DATA_KEY_SELECTED_TIME: depTime,
      Keys.PUSH_DATA_KEY_PERSON_COUNT: personCount.toString()
    };
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const SrtCheckScreenRoute(),
            settings: RouteSettings(
              arguments: data,
            )));
  }

  String depTimeMapper() {
    if (depTime.length == 1) {
      "0$depTime";
    }
    return "${depTime}00";
  }

  void dateSelectCompleteAction(DateTime selectedDay, int selectTime) {
    lastSelectDate = selectedDay;
    depDate = Utils.depDateMapper(selectedDay);
    depTime = selectTime.toString();
    Log.d(message: "", name: depTime);
    selectDateController.text =
        "${selectedDay.year}.${selectedDay.month}.${selectedDay.day}(${Utils.weekDayMapper(selectedDay.weekday)}) $depTime시 이후";
  }

  DateTime getLastSelectDate() {
    return lastSelectDate;
  }

  int getLastSelectTime() {
    return int.parse(depTime);
  }

  int getPersonCount() {
    return personCount;
  }
}
