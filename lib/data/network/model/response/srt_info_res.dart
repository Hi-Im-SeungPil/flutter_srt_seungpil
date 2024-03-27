import 'dart:convert';

import '../../../../ui/util/log.dart';
import 'base_res.dart';

class SrtInfoRes extends BaseRes {
  late List<RecentReservationList> recentReservationList;
  late List<BannerList> bannerList;
  late List<NoticeList> noticeList;

  SrtInfoRes(
      {required super.code, required super.message, required super.data}) {
    if (data != null) {
      recentReservationList = List<RecentReservationList>.from(
          data?["recentReservationList"]
              .map((model) => RecentReservationList.fromJson(model)));
      bannerList = List<BannerList>.from(data?["bannerList"]
          .map((model) => BannerList.fromJson(model)));
      noticeList = List<NoticeList>.from(data?["noticeList"]
          .map((model) => NoticeList.fromJson(model)));
    }
  }

  factory SrtInfoRes.fromJson(Map<String, dynamic> json) {
    return SrtInfoRes(
        code: json['code'], message: json['message'], data: json['data']);
  }
}

class RecentReservationList {
  String depPlaceId;
  String depPlaceName;
  String arrPlaceId;
  String arrPlaceName;

  RecentReservationList(
      {required this.depPlaceId,
      required this.depPlaceName,
      required this.arrPlaceId,
      required this.arrPlaceName});

  factory RecentReservationList.fromJson(Map<String, dynamic> json) {
    return RecentReservationList(
        depPlaceId: json['depPlaceId'],
        depPlaceName: json['depPlaceName'],
        arrPlaceId: json['arrPlaceId'],
        arrPlaceName: json['arrPlaceName']);
  }
}

class BannerList {
  String imgUrl;
  String linkUrl;

  BannerList({required this.imgUrl, required this.linkUrl});

  factory BannerList.fromJson(Map<String, dynamic> json) {
    return BannerList(imgUrl: json['imgUrl'], linkUrl: json['linkUrl']);
  }
}

class NoticeList {
  String title;
  String linkUrl;

  NoticeList({required this.title, required this.linkUrl});

  factory NoticeList.fromJson(Map<String, dynamic> json) {
    return NoticeList(title: json['title'], linkUrl: json['linkUrl']);
  }
}
