import 'package:flutter/cupertino.dart';
import 'package:flutter_srt_seungpil/constants/keys.dart';
import 'package:flutter_srt_seungpil/ui/home/home_screen_state_holder.dart';

class SelectionScreenStateHolder extends ChangeNotifier {
  late final Map<String, dynamic>? receivedData;
  bool isDepartureStation = true;
  String departureStationName = "";
  String departureStationCode = emptyStringValue;
  String destinationStationCode = emptyStringValue;
  String destinationStationName = "";

  SelectionScreenStateHolder({required this.receivedData}) {
    isDepartureStation = receivedData?[Keys.PUSH_DATA_KEY_IS_DEPARTURE] ?? true;
    departureStationName =
        receivedData?[Keys.PUSH_DATA_KEY_DEPARTURE_STATION_NAME] ?? "";
    departureStationCode =
        receivedData?[Keys.PUSH_DATA_KEY_DEPARTURE_STATION_CODE] ??
            emptyStringValue;
    destinationStationCode =
        receivedData?[Keys.PUSH_DATA_KEY_DESTINATION_STATION_CODE] ??
            emptyStringValue;
    destinationStationName =
        receivedData?[Keys.PUSH_DATA_KEY_DESTINATION_STATION_NAME] ?? "";
    notifyListeners();
  }

  /// 역 선택 했을 때 액션
  void stationClickAction(String stationCode, String stationName) {
    if (isDepartureStation) {
      if (stationCode == departureStationCode) {
        departureStationCode = emptyStringValue;
        departureStationName = "";
      } else if (stationCode != destinationStationCode) {
        departureStationCode = stationCode;
        departureStationName = stationName;
      }
    } else {
      if (stationCode == destinationStationCode) {
        destinationStationCode = emptyStringValue;
        destinationStationName = "";
      } else if (stationCode != departureStationCode) {
        destinationStationCode = stationCode;
        destinationStationName = stationName;
      }
    }
    notifyListeners();
  }

  /// 출발 <-> 도착 변경
  void convertStation() {
    if (departureStationName.isNotEmpty && destinationStationName.isNotEmpty) {
      String tempDepartureStationCode = departureStationCode;
      departureStationCode = destinationStationCode;
      destinationStationCode = tempDepartureStationCode;

      String tempDepartureStationName = departureStationName;
      departureStationName = destinationStationName;
      destinationStationName = tempDepartureStationName;

      notifyListeners();
    }
  }

  /// 선택역 초기화를 위해
  String getSelectStation() {
    if (isDepartureStation && departureStationCode != emptyStringValue) {
      return departureStationCode;
    } else if (!isDepartureStation &&
        destinationStationCode != emptyStringValue) {
      return destinationStationCode;
    } else {
      return emptyStringValue;
    }
  }

  /// 선택역 선택인지 도착역 선택인지
  void departureDestinationSelectAction(bool isDepartureStation) {
    this.isDepartureStation = isDepartureStation;
    notifyListeners();
  }

  /// 출발역인지 도착역인지
  bool getIsDeparture() {
    return isDepartureStation;
  }

  /// 역 선택 하고 다시 돌아갈 때
  void selectCompleteAction(BuildContext context) {
    Map<String, dynamic> data = {
      Keys.PUSH_DATA_KEY_DEPARTURE_STATION_CODE: departureStationCode,
      Keys.PUSH_DATA_KEY_DEPARTURE_STATION_NAME: departureStationName,
      Keys.PUSH_DATA_KEY_DESTINATION_STATION_CODE: destinationStationCode,
      Keys.PUSH_DATA_KEY_DESTINATION_STATION_NAME: destinationStationName,
    };
    Navigator.pop(context, data);
  }

  bool isSelectButtonEnabled() {
    if (departureStationName.isNotEmpty && destinationStationName.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
