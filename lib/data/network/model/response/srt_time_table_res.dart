import 'base_res.dart';

class SrtTimeTableRes extends BaseRes {
  late List<TrainInfo> trainInfoList;
  int totalCount = 0;

  SrtTimeTableRes(
      {required super.code, required super.message, required super.data}) {
    totalCount = data?["totalCount"] ?? 0;
    trainInfoList = List<TrainInfo>.from(data?["trainInfoList"]
        .map((model) => TrainInfo.fromJson(model)));
  }

  factory SrtTimeTableRes.fromJson(Map<String, dynamic> json) {
    return SrtTimeTableRes(
        code: json['code'], message: json['message'], data: json['data']);
  }
}

class TrainInfo {
  String arrplacename;
  int arrplandtime;
  String depplacename;
  int depplandtime;
  int trainno;
  String reserveYN;

  TrainInfo(
      {required this.arrplacename,
      required this.arrplandtime,
      required this.depplacename,
      required this.depplandtime,
      required this.trainno,
      required this.reserveYN});

  factory TrainInfo.fromJson(Map<String, dynamic> json) {
    return TrainInfo(
        arrplacename: json['arrplacename'],
        arrplandtime: json['arrplandtime'],
        depplacename: json['depplacename'],
        depplandtime: json['depplandtime'],
        trainno: json['trainno'],
        reserveYN: json['reserveYN']);
  }
}
