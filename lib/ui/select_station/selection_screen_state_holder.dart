import 'package:flutter/cupertino.dart';
import 'package:flutter_srt_seungpil/ui/home/home_screen_state_holder.dart';
import 'package:flutter_srt_seungpil/ui/util/log.dart';

class SelectionScreenStateHolder extends ChangeNotifier {
  late final Map<String, dynamic>? receivedData;
  bool isDepartureStation = true;
  String departureStationName = "";
  String departureStationCode = emptyStringValue;
  String destinationStationCode = emptyStringValue;
  String destinationStationName = "";

  SelectionScreenStateHolder ({required this.receivedData}) {
    isDepartureStation = receivedData?['isDeparture'] ?? true;
    departureStationName = receivedData?['departureStationName'] ?? "";
    departureStationCode = receivedData?['departureStationCode'] ?? emptyStringValue;
    destinationStationCode = receivedData?['destinationStationCode'] ?? emptyStringValue;
    destinationStationName = receivedData?['destinationStationName'] ?? "";
    notifyListeners();
  }

  /// 역 선택 했을 때 액션
  void stationClickAction(String stationCode, String stationName) {
    if (isDepartureStation) {
      if (stationCode == departureStationCode) {
        departureStationCode = emptyStringValue;
        departureStationName = "";
      } else {
        departureStationCode = stationCode;
        departureStationName = stationName;
      }
      // isDepartureStation = false;
      Log.d(message: departureStationCode, name: "departure");
    } else {
      if (stationCode == destinationStationCode) {
        destinationStationCode = emptyStringValue;
        destinationStationName = "";
      } else {
        destinationStationCode = stationCode;
        destinationStationName = stationName;
      }
      // isDepartureStation = true;
      Log.d(message: destinationStationCode, name: "destination");
    }
    notifyListeners();
  }

  /// 출발 <-> 도착 변경
  void convertStation() {
    String tempDepartureStationCode = departureStationCode;
    departureStationCode = destinationStationCode;
    destinationStationCode = tempDepartureStationCode;

    String tempDepartureStationName = departureStationName;
    departureStationName = destinationStationName;
    destinationStationName = tempDepartureStationName;

    notifyListeners();
  }

  /// 선택역 초기화를 위해
  String getSelectStation() {
    if (isDepartureStation && departureStationCode != emptyStringValue) {
      return departureStationCode;
    } else if (!isDepartureStation && destinationStationCode != emptyStringValue) {
      return destinationStationCode;
    } else {
      return "-1";
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
      'departureStationCode': departureStationCode,
      'departureStationName': departureStationName,
      'destinationStationCode': destinationStationCode,
      'destinationStationName': destinationStationName,
    };
    Navigator.pop(context, data);
  }
}
