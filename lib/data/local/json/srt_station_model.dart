import 'dart:convert';

class SrtStationModel {
  List<SrtStationModelItem> srtStationModelList;

  SrtStationModel({required this.srtStationModelList});

  factory SrtStationModel.fromJson(List<dynamic> list) {
    // List<dynamic> listFromJson = json.decode(jsonString);
    List<SrtStationModelItem> temp = <SrtStationModelItem>[];

    // temp = listFromJson.map((temp) => SrtStationModelItem.fromJson(temp)).toList();

    temp = List<SrtStationModelItem>.from(list.map((model) => SrtStationModelItem.fromJson(model)));

    return SrtStationModel(srtStationModelList: temp);
  }

}

class SrtStationModelItem {

  String stationNm;
  String stationId;

  SrtStationModelItem({required this.stationNm, required this.stationId});

  factory SrtStationModelItem.fromJson(Map<String, dynamic> json) =>  SrtStationModelItem(stationNm: json["stationNm"], stationId: json["stationId"]);
}