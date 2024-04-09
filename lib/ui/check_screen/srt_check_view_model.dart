import 'package:flutter_srt_seungpil/constants/keys.dart';
import 'package:flutter_srt_seungpil/ui/base/base_view_model.dart';

import '../../constants/constants.dart';
import '../../data/network/api_result.dart';
import '../../data/network/model/request/time_table_req.dart';
import '../../data/network/model/response/srt_time_table_res.dart';
import '../util/log.dart';
import '../util/utils.dart';

class _HomeViewModelState {
  SrtTimeTableRes? srtTimeTableRes;
  Map<String, dynamic>? reservationInfo;
}

class SrtCheckScreenViewModel extends BaseViewModel {
  final _HomeViewModelState _state = _HomeViewModelState();

  SrtTimeTableRes? get srtTimeTableRes => _state.srtTimeTableRes;
  Map<String, dynamic>? get receivedData => _state.reservationInfo;

  SrtCheckScreenViewModel({required Map<String, dynamic>? receivedData}) {
    _state.reservationInfo = receivedData;
    String depPlaceId =
        receivedData?[Keys.PUSH_DATA_KEY_DEPARTURE_STATION_CODE];
    String arrPlaceId =
        receivedData?[Keys.PUSH_DATA_KEY_DESTINATION_STATION_CODE];
    DateTime depPlandDate = receivedData?[Keys.PUSH_DATA_KEY_SELECTED_DATE];
    String depPlandTime = receivedData?[Keys.PUSH_DATA_KEY_SELECTED_TIME];
    requestSrtTimeTable(depPlaceId, arrPlaceId, Utils.depDateMapper(depPlandDate), "1300");
  }

  void requestSrtTimeTable(
    String depPlaceId,
    String arrPlaceId,
    String depPlandDate,
    String depPlandTime,
  ) {
    TimeTableReq timeTableReq =
        TimeTableReq(depPlaceId, arrPlaceId, depPlandDate, depPlandTime);
    networkRepository.requestSrtTimeTable(timeTableReq);
    defineNetworkResult(successAction: (ApiResult apiResult) {
      SrtTimeTableRes srtTimeTableRes =
          SrtTimeTableRes.fromJson(apiResult.data);
      if (srtTimeTableRes.code == Constants.NETWORK_COMMUNICATION_SUCCESS) {
        Log.d(message: srtTimeTableRes.toString(), name: "result2");
        _state.srtTimeTableRes = srtTimeTableRes;
      } else {
        Log.d(message: srtTimeTableRes.code.toString(), name: "result");
        baseErrorMessage = srtTimeTableRes.message;
        baseShowErrorDialog = true;
      }
      notifyListeners();
    });
  }
}
