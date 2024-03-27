class TimeTableReq {
  String depPlaceId;
  String arrPlaceId;
  String depPlandDate;
  String depPlandTime;

  TimeTableReq(
      this.depPlaceId, this.arrPlaceId, this.depPlandDate, this.depPlandTime);

  Map<String, dynamic> toMap() {
    return {
      'depPlaceId': depPlaceId,
      'arrPlaceId': arrPlaceId,
      'depPlandDate': depPlandDate,
      'depPlandTime': depPlandTime,
    };
  }
}
