import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_srt_seungpil/constants/constants.dart';
import 'package:flutter_srt_seungpil/data/network/model/response/srt_time_table_res.dart';
import 'package:flutter_srt_seungpil/ui/check_screen/srt_check_view_model.dart';
import 'package:flutter_srt_seungpil/ui/reservation/ReservationScreenRoute.dart';
import 'package:provider/provider.dart';

import '../../constants/keys.dart';
import '../util/utils.dart';

class SrtCheckScreen extends StatelessWidget {
  const SrtCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: _appBar(context),
            body: Consumer<SrtCheckScreenViewModel>(
                builder: (context, viewModel, child) => Column(
                      children: [
                        SearchInfoBox(
                          departureStationName: viewModel.receivedData?[
                              Keys.PUSH_DATA_KEY_DEPARTURE_STATION_NAME],
                          destinationStationName: viewModel.receivedData?[
                              Keys.PUSH_DATA_KEY_DESTINATION_STATION_NAME],
                          personCount: viewModel
                              .receivedData?[Keys.PUSH_DATA_KEY_PERSON_COUNT],
                          selectedDate: viewModel
                              .receivedData?[Keys.PUSH_DATA_KEY_SELECTED_DATE],
                        ),
                        Expanded(
                            child: SrtTimeTable(
                          srtTimeTableRes: viewModel.srtTimeTableRes,
                          reservationInfo: viewModel.receivedData,
                        ))
                      ],
                    ))));
  }
}

PreferredSizeWidget _appBar(BuildContext context) {
  return AppBar(
    toolbarHeight: 56,
    centerTitle: true,
    title: const Text('기차 조회',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18)),
    automaticallyImplyLeading: true,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {
        Utils.pop(context);
      },
    ),
  );
}

class SearchInfoBox extends StatelessWidget {
  final String departureStationName;
  final String destinationStationName;
  final String personCount;
  final DateTime selectedDate;

  const SearchInfoBox(
      {super.key,
      required this.departureStationName,
      required this.destinationStationName,
      required this.personCount,
      required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.only(top: 20),
            color: const Color(0xffF8F8F8),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                          '$departureStationName → $destinationStationName',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ))),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                        color: Color(0xffeeeeee),
                      ))),
                      child: Text(
                        '총 인원수 $personCount명',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff888888)),
                        textAlign: TextAlign.center,
                      ))
                ],
              ),
            )),
        Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Color(0xff2C3548),
            ))),
            child: Text(
              '${selectedDate.year}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.day.toString().padLeft(2, '0')}(${Utils.weekDayMapper(selectedDate.weekday)})',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ))
      ],
    );
  }
}

class SrtTimeTable extends StatefulWidget {
  SrtTimeTableRes? srtTimeTableRes;
  final Map<String, dynamic>? reservationInfo;

  SrtTimeTable(
      {super.key,
      required this.srtTimeTableRes,
      required this.reservationInfo});

  @override
  State<SrtTimeTable> createState() => _SrtTimeTableState();
}

class _SrtTimeTableState extends State<SrtTimeTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.only(top: 11, bottom: 10),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Color(0xffeeeeee),
            ))),
            child: const Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      '기차',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text('출발',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                        textAlign: TextAlign.center)),
                Expanded(
                    flex: 1,
                    child: Text('도착',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                        textAlign: TextAlign.center)),
                Expanded(
                    flex: 1,
                    child: Text('일반실',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                        textAlign: TextAlign.center))
              ],
            )),
        Visibility(
            visible: widget.srtTimeTableRes == null,
            child: const Expanded(
                flex: 1,
                child: Center(
                    child: Image(
                        image: AssetImage(
                            "${Constants.IMAGE_PATH}img_no_srt_message.png"))))),
        Visibility(
            visible: widget.srtTimeTableRes != null,
            child: Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.srtTimeTableRes?.totalCount ?? 0,
              itemBuilder: (BuildContext context, int index) {
                TrainInfo? trainInfo =
                    widget.srtTimeTableRes?.trainInfoList[index];
                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Positioned(
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: 16,
                            color: Color(0xff476EFF),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'SRT ${trainInfo?.trainno.toString() ?? ""}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                  textAlign: TextAlign.center,
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(trainInfo?.depplacename ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13),
                                    textAlign: TextAlign.center)),
                            Expanded(
                                flex: 1,
                                child: Text(trainInfo?.arrplacename ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13),
                                    textAlign: TextAlign.center)),
                            Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: (trainInfo?.reserveYN ?? "") == "N"
                                      ? () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ReservationScreenRoute(),
                                                  settings: RouteSettings(
                                                    arguments:
                                                        widget.reservationInfo,
                                                  )));
                                        }
                                      : null,
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xffCCCCCC),
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6))),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Text(
                                        (trainInfo?.reserveYN ?? "") == "N"
                                            ? '예매가능'
                                            : '매진',
                                        style: TextStyle(
                                            color:
                                                (trainInfo?.reserveYN ?? "") ==
                                                        "N"
                                                    ? Colors.black
                                                    : const Color(0xffCCCCCC),
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                    Container(
                        height: 8,
                        width: double.infinity,
                        color: const Color(0xffEEEEEE))
                  ],
                );
              },
            )))
      ],
    );
  }
}
