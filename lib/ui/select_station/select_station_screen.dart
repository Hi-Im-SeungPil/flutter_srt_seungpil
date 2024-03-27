import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/ui/select_station/select_station_view_model.dart';
import 'package:flutter_srt_seungpil/ui/select_station/selection_screen_state_holder.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../data/local/json/srt_station_model.dart';
import '../common/common_button.dart';
import '../util/utils.dart';

class SelectStationScreen extends StatelessWidget {
  SelectStationScreen({super.key});

  final SelectStationViewModel viewModel = SelectStationViewModel();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
        Consumer<SelectionScreenStateHolder>(builder: (context, holder, child) {
      return Scaffold(
          appBar: AppBar(
            toolbarHeight: 56,
            centerTitle: true,
            title: const Text('${'역 선택'}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Utils.pop(context);
              },
            ),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    SelectBox(
                        getIsDeparture: holder.getIsDeparture,
                        departureDestinationSelectAction:
                            holder.departureDestinationSelectAction,
                        departureStationName: holder.departureStationName,
                        destinationStationName: holder.destinationStationName,
                        convertStation: holder.convertStation),
                    const RecentSearchListView(),
                    StationSelectBox(
                        getStationList: viewModel.getStationList,
                        stationClickAction: holder.stationClickAction,
                        getSelectedStationCode: holder.getSelectStation,
                        get: holder.getIsDeparture)
                  ],
                )),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: commonButton(
                    onPressed: () {
                      holder.selectCompleteAction(context);
                    },
                    width: double.infinity,
                    height: 48,
                    buttonText: "선택완료"),
              )
            ],
          ));
    }));
  }
}

class SelectBox extends StatefulWidget {
  final bool Function() getIsDeparture;
  final void Function(bool isDepartureStation) departureDestinationSelectAction;
  final String departureStationName;
  final String destinationStationName;
  final void Function() convertStation;

  const SelectBox({
    super.key,
    required this.getIsDeparture,
    required this.departureDestinationSelectAction,
    required this.departureStationName,
    required this.destinationStationName,
    required this.convertStation,
  });

  @override
  State<SelectBox> createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: SizedBox(
            width: double.infinity,
            height: 102,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              decoration: const BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A000000),
                      spreadRadius: 0,
                      blurRadius: 24,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: SelectedBoxTextColumn(
                          title:
                              getStrings(context).home_screen_departure_station,
                          stationName: widget.departureStationName.isEmpty
                              ? getStrings(context).home_screen_selection
                              : widget.departureStationName,
                          getIsDeparture: widget.getIsDeparture,
                          isDeparture: true,
                        ),
                        onTap: () {
                          widget.departureDestinationSelectAction(true);
                        },
                      )),
                  GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.only(left: 43.5, right: 43.5),
                      child: Image(
                        image: AssetImage(
                            '${Constants.IMAGE_PATH}img_transf.png'),
                      ),
                    ),
                    onTap: () {
                      widget.convertStation();
                    },
                  ),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: SelectedBoxTextColumn(
                            title:
                                getStrings(context).home_screen_arrival_station,
                            stationName: widget.destinationStationName.isEmpty
                                ? getStrings(context).home_screen_selection
                                : widget.destinationStationName,
                            getIsDeparture: widget.getIsDeparture,
                            isDeparture: false),
                        onTap: () {
                          widget.departureDestinationSelectAction(false);
                        },
                      ))
                ],
              ),
            )));
  }
}

class SelectedBoxTextColumn extends StatefulWidget {
  final String title;
  final String stationName;
  final bool Function() getIsDeparture;
  final bool isDeparture;

  const SelectedBoxTextColumn(
      {super.key,
      required this.title,
      required this.stationName,
      required this.getIsDeparture,
      required this.isDeparture});

  @override
  State<SelectedBoxTextColumn> createState() => _SelectedBoxTextColumnState();
}

class _SelectedBoxTextColumnState extends State<SelectedBoxTextColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(widget.title,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff888888),
                      fontWeight: FontWeight.w400))),
          SizedBox(
            height: 34,
            child: AutoSizeText(
              widget.stationName,
              style: TextStyle(
                  fontSize: 24,
                  color: widget.getIsDeparture() == widget.isDeparture
                      ? Colors.blue
                      : Color(0xffbbbbbb),
                  fontWeight: FontWeight.w700),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          )
        ]);
  }
}

class RecentSearchListView extends StatelessWidget {
  // final List<RecentReservationList>? recentReservationList;

  const RecentSearchListView({
    super.key,
    // required this.recentReservationList
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: true
        // recentReservationList != null && recentReservationList!.isNotEmpty
        ,
        child: Container(
            decoration: const BoxDecoration(color: Color(0xffF8F8F8)),
            margin: const EdgeInsets.only(top: 32),
            child: SizedBox(
                width: double.infinity,
                height: 102,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 4),
                            child: Text("최근 검색 구간",
                                style: TextStyle(color: Color(0xff888888)))),
                        SizedBox(
                            height: 38,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal, // 가로 스크롤 설정
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  height: 38,
                                  color: const Color(0xffEFF0F5),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: Text(
                                      'Item $index',
                                      style: const TextStyle(
                                        color: Color(0xff494F60),
                                        fontSize: 14,
                                      ),
                                    ),
                                  )),
                                );
                              },
                            ))
                      ]),
                ))));
  }
}

class StationSelectBox extends StatefulWidget {
  final Function(String stationCode, String stationName) stationClickAction;
  final Future<SrtStationModel> Function() getStationList;
  final String Function() getSelectedStationCode;
  final bool Function() get;

  const StationSelectBox(
      {super.key,
      required this.getStationList,
      required this.stationClickAction,
      required this.getSelectedStationCode,
      required this.get});

  @override
  State<StationSelectBox> createState() => _StationSelectBoxState();
}

class _StationSelectBoxState extends State<StationSelectBox> {
  // String selectedStationCode = "-1";

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.only(left: 24),
                child: Text("정차역",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 22))),
            FutureBuilder(
                future: widget.getStationList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 16),
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: (152 / 52)),
                            itemCount: snapshot.data.srtStationModelList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Station(
                                srtStationModelItem:
                                    snapshot.data.srtStationModelList[index],
                                stationClickAction: widget.stationClickAction,
                                getSelectedStationCode:
                                    widget.getSelectedStationCode,
                                get: widget.get)));
                  } else {
                    return const Spacer(flex: 1);
                  }
                })
          ],
        ));
  }
}

class Station extends StatefulWidget {
  final Function(String stationCode, String stationName) stationClickAction;
  final SrtStationModelItem srtStationModelItem;
  final String Function() getSelectedStationCode;
  final bool Function() get;

  // final String selectedStationCode;

  const Station({
    super.key,
    required this.srtStationModelItem,
    required this.stationClickAction,
    required this.getSelectedStationCode,
    required this.get,
    // required this.selectedStationCode
  });

  @override
  State<Station> createState() => _StationState();
}

class _StationState extends State<Station> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 152,
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.getSelectedStationCode() ==
                    widget.srtStationModelItem.stationId
                ? Color(0xff476EFF)
                : Color(0xffCCCCCC), // 테두리 색상
            width: 1.0, // 테두리 두께
          ),
          color: widget.getSelectedStationCode() ==
                  widget.srtStationModelItem.stationId
              ? Color(0xff476EFF)
              : Color(0xffffffff),
          borderRadius: BorderRadius.circular(8), // 모서리 반경
        ),
        child: Center(
          child: Text(
            widget.srtStationModelItem.stationNm,
            style: TextStyle(
                fontSize: 13,
                color: widget.getSelectedStationCode() ==
                        widget.srtStationModelItem.stationId
                    ? Color(0xffffffff)
                    : Color(0xff000000)),
          ),
        ),
      ),
      onTap: () {
        widget.stationClickAction(widget.srtStationModelItem.stationId,
            widget.srtStationModelItem.stationNm);
      },
    );
  }
}
