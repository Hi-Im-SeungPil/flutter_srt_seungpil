import 'package:flutter_srt_seungpil/data/network/model/request/time_table_req.dart';
import 'package:flutter_srt_seungpil/data/network/model/response/srt_info_res.dart';
import 'package:flutter_srt_seungpil/data/network/model/response/srt_time_table_res.dart';
import 'package:flutter_srt_seungpil/ui/base/base_view_model.dart';
import 'package:flutter_srt_seungpil/ui/util/log.dart';

import '../../constants/constants.dart';
import '../../data/network/api_result.dart';

class _HomeViewModelState {
  SrtInfoRes? srtInfoRes;
  SrtTimeTableRes? srtTimeTableRes;
}

class HomeScreenViewModel extends BaseViewModel {
  final _HomeViewModelState _state = _HomeViewModelState();

  String get errorMessage => baseErrorMessage;

  bool get showErrorDialog => baseShowErrorDialog;

  SrtInfoRes? get srtInfoRes => _state.srtInfoRes;

  HomeScreenViewModel() {
    requestSrtInfo();
  }

  void requestSrtInfo() async {
    networkRepository.requestSrtInfo();
    defineNetworkResult(successAction: (ApiResult apiResult) {
      SrtInfoRes srtInfoRes = SrtInfoRes.fromJson(apiResult.data);
      if (srtInfoRes.code == Constants.NETWORK_COMMUNICATION_SUCCESS) {
        _state.srtInfoRes = srtInfoRes;
      } else {
        baseErrorMessage = srtInfoRes.message;
        baseShowErrorDialog = true;
      }
      notifyListeners();
    });
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
