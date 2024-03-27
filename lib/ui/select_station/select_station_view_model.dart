import 'package:flutter_srt_seungpil/data/local/json/json.dart';
import 'package:flutter_srt_seungpil/ui/util/log.dart';

import '../../data/local/json/srt_station_model.dart';

class SelectStationViewModel {
  late dynamic stationJson;

  // SelectStationViewModel() {
  // }

  Future<SrtStationModel> getStationList() async{
    List<dynamic> json = await readJson("json/srt_station.json");
    SrtStationModel srtStationModel = SrtStationModel.fromJson(json);
    return srtStationModel;
  }
}
