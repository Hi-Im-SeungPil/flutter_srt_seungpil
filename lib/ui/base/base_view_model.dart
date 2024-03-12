import 'package:flutter/cupertino.dart';
import 'package:flutter_srt_seungpil/ui/util/errors.dart';

import '../../data/network/api_result.dart';
import '../../repository/network/network_repository.dart';
import 'dart:developer' as dev;

class BaseViewModel extends ChangeNotifier {
  @protected
  NetworkRepository networkRepository = NetworkRepository();
  @protected
  String baseErrorMssage = "";
  @protected
  bool baseShowErrorDialog = false;
  @protected
  bool loadingState = false;

  @protected
  void defineNetworkResult(
      {Function(ApiResult apiResult)? successAction,
      Function(ApiResult apiResult)? apiErrorAction,
      Function(ApiResult apiResult)? exceptionAction,
      Function(ApiResult apiResult)? defaultAction}) {
    networkRepository.getStreamController().stream.listen((data) {
      ApiResult apiResult = data as ApiResult;
      switch (apiResult.status) {
        case Status.LOADING:
          dev.log("LOADING");
          loadingState = false;
          break;
        case Status.SUCCESS:
          dev.log("SUCCESS");
          if (successAction != null) {
            successAction(apiResult);
          }
          loadingState = false;
          break;
        case Status.API_ERROR:
          dev.log("API_ERROR");
          if (apiErrorAction != null) {
            apiErrorAction(apiResult);
          }
          loadingState = false;
          baseErrorMssage = errorMessageMapper(ErrorType.API_ERROR);
          baseShowErrorDialog = true;
          break;
        case Status.EXCEPTION:
          dev.log("EXCEPTION");
          if (exceptionAction != null) {
            exceptionAction(apiResult);
          }
          loadingState = false;
          baseErrorMssage = errorMessageMapper(ErrorType.EXCEPTION);
          baseShowErrorDialog = true;
          break;
        default:
          dev.log("DEFAULT");
          if (defaultAction != null) {
            defaultAction(apiResult);
          }
          loadingState = false;
          break;
      }
    });
  }

  void errorDialogDismissAction() {
    baseErrorMssage = "";
    baseShowErrorDialog = false;
  }
}
