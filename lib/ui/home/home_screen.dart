import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_srt_seungpil/data/network/model/response/srt_info_res.dart';
import 'package:flutter_srt_seungpil/ui/common/common_button.dart';
import 'package:flutter_srt_seungpil/ui/home/home_screen_state_holder.dart';
import 'package:flutter_srt_seungpil/ui/home/home_screen_view_model.dart';
import 'package:flutter_srt_seungpil/ui/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constants/constants.dart';
import '../../constants/url.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool buttonEnabled = false;
  HomeScreenStateHolder holder = HomeScreenStateHolder();

  void changeSelectStation(bool value) {
    setState(() {
      buttonEnabled = value;
    });
  }

  void changeStations() {
    setState(() {
      holder.changeStations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: SingleChildScrollView(child:
        Consumer<HomeScreenViewModel>(builder: (context, viewModel, child) {
      holder.showErrorDialog(context, viewModel.showErrorDialog,
          viewModel.errorDialogDismissAction, viewModel.errorMessage);
      return Column(children: [
        const HomeScreenTop(),
        SelectBox(
            moveSelectStationScreen: holder.moveSelectStation,
            departureStationName: holder.departureStationName,
            destinationStationName: holder.destinationStationName,
            buttonEnabled: buttonEnabled,
            changeButtonEnabled: changeSelectStation,
            changeStations: changeStations),
        RecentReserveListView(
            recentReservationList: viewModel.srtInfoRes?.recentReservationList),
        HomeScreenTextField(
            textEditingController: holder.selectDateController,
            identityText: getStrings(context).home_screen_date,
            dateSelectCompleteAction: holder.dateSelectCompleteAction,
            getLastSelectDate: holder.getLastSelectDate,
            getSelectTime: holder.getLastSelectTime),
        HomeScreenTextField(
          textEditingController: holder.selectPersonCountController,
          identityText: getStrings(context).home_screen_people_count,
          getPersonCount: holder.getPersonCount,
          setPersonCount: holder.setPersonCount,
        ),
        HomeScreenSearchButton(
            buttonEnabled: buttonEnabled,
            searchSrtButtonAction: holder.searchSrtButtonAction),
        HomeScreenNoticeBoard(noticeList: viewModel.srtInfoRes?.noticeList),
        AutoScrollPageView(bannerList: viewModel.srtInfoRes?.bannerList),
        const HomeScreenTermsOfService(),
        const HomeScreenWarningText()
      ]);
    }))));
  }
}

class OpenObjectLogo extends StatelessWidget {
  const OpenObjectLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: const Image(
            image:
                AssetImage('${Constants.IMAGE_PATH}img_open_object_logo.png'),
            width: 135.04,
            height: 22),
        onTap: () {});
  }
}

class IconUnderText extends StatelessWidget {
  final String text;
  final String imageFileName;

  const IconUnderText(
      {super.key, required this.text, required this.imageFileName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Image(
                  image: AssetImage('${Constants.IMAGE_PATH}$imageFileName'),
                  width: 28,
                  height: 28)),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(text,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff000000))),
          )
        ],
      ),
      onTap: () {},
    );
  }
}

class HomeScreenTop extends StatelessWidget {
  const HomeScreenTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 28, top: 41, right: 24),
        child: Row(
          children: [
            const OpenObjectLogo(),
            const Spacer(flex: 1),
            IconUnderText(
                text: getStrings(context).home_screen_alarm_box,
                imageFileName: "img_alram.png"),
            IconUnderText(
                text: getStrings(context).home_screen_my_ticket,
                imageFileName: "img_ticket.png")
          ],
        ));
  }
}

class SelectBox extends StatefulWidget {
  final Function(
          BuildContext context, bool isDeparture, Function(String a, String b))
      moveSelectStationScreen;
  String departureStationName;
  String destinationStationName;
  Function(bool value) changeButtonEnabled;
  Function() changeStations;

  SelectBox(
      {super.key,
      required this.moveSelectStationScreen,
      required this.departureStationName,
      required this.destinationStationName,
      required bool buttonEnabled,
      required this.changeButtonEnabled,
      required this.changeStations});

  @override
  State<SelectBox> createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {
  void setStations(String departure, String destination) {
    setState(() {
      widget.departureStationName = departure;
      widget.destinationStationName = destination;
      widget.changeButtonEnabled(widget.departureStationName.isNotEmpty &&
          widget.destinationStationName.isNotEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
        child: SizedBox(
            width: double.infinity,
            height: 102,
            child: Container(
              decoration: const BoxDecoration(
                  color: Color(0xff3D4964),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: SelectedBoxTextColumn(
                              title: getStrings(context)
                                  .home_screen_departure_station,
                              stationName: widget.departureStationName == ""
                                  ? getStrings(context).home_screen_selection
                                  : widget.departureStationName)),
                      onTap: () {
                        widget.moveSelectStationScreen(
                            context, true, setStations);
                      },
                    ),
                  ),
                  GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.only(left: 43.5, right: 43.5),
                      child: Image(
                        image: AssetImage(
                            '${Constants.IMAGE_PATH}img_refresh.png'),
                      ),
                    ),
                    onTap: () {
                      widget.changeStations();
                    },
                  ),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: SelectedBoxTextColumn(
                                title: getStrings(context)
                                    .home_screen_arrival_station,
                                stationName: widget.destinationStationName == ""
                                    ? getStrings(context).home_screen_selection
                                    : widget.destinationStationName)),
                        onTap: () {
                          widget.moveSelectStationScreen(
                              context, false, setStations);
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

  const SelectedBoxTextColumn(
      {super.key, required this.title, required this.stationName});

  @override
  State<SelectedBoxTextColumn> createState() => _SelectedBoxTextColumnState();
}

class _SelectedBoxTextColumnState extends State<SelectedBoxTextColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(widget.title,
              style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xffbbbbbb),
                  fontWeight: FontWeight.w400))),
      SizedBox(
          height: 34,
          child: AutoSizeText(widget.stationName,
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xffffffff),
                  fontWeight: FontWeight.w700)))
    ]);
  }
}

class RecentReserveListView extends StatelessWidget {
  final List<RecentReservationList>? recentReservationList;

  const RecentReserveListView({super.key, required this.recentReservationList});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible:
            recentReservationList != null && recentReservationList!.isNotEmpty,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 8),
                    child: Text(
                        getStrings(context).home_screen_recently_reserve,
                        style: const TextStyle(color: Color(0xff888888)))),
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
                            padding: const EdgeInsets.symmetric(horizontal: 14),
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
        ));
  }
}

class HomeScreenTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String identityText;
  void Function(int selectedIndex)? setPersonCount;
  Function(DateTime selectedDay, int selecTime)? dateSelectCompleteAction;
  DateTime Function()? getLastSelectDate;
  int Function()? getSelectTime;
  int Function()? getPersonCount;

  HomeScreenTextField(
      {super.key,
      required this.textEditingController,
      required this.identityText,
      this.setPersonCount,
      this.dateSelectCompleteAction,
      this.getLastSelectDate,
      this.getSelectTime,
      this.getPersonCount});

  @override
  State<HomeScreenTextField> createState() => _HomeScreenTextFieldState();
}

class _HomeScreenTextFieldState extends State<HomeScreenTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            top: widget.identityText == getStrings(context).home_screen_date
                ? 20
                : 12,
            left: 24,
            right: 24),
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color(0xFFEEEEEE),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: GestureDetector(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                      left: 23, right: 20, top: 20, bottom: 20),
                  child: Text(
                    widget.identityText,
                    style:
                        const TextStyle(color: Color(0xFF888888), fontSize: 16),
                  )),
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: TextField(
                        textAlign: TextAlign.right,
                        controller: widget.textEditingController,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w500),
                        enabled: false,
                      )))
            ],
          ),
          onTap: () {
            if (widget.identityText == "인원 수") {
              showPersonCountBottomSheet(context, widget.textEditingController,
                  widget.setPersonCount, widget.getPersonCount);
            } else {
              showCalendarBottomSheet(
                  context,
                  widget.textEditingController,
                  widget.dateSelectCompleteAction,
                  widget.getLastSelectDate,
                  widget.getSelectTime);
            }
          },
        ));
  }
}

Future<dynamic> showCalendarBottomSheet(
    BuildContext context,
    TextEditingController controller,
    Function(DateTime selectedDay, int selecTime)? dateSelectCompleteAction,
    DateTime Function()? getLastSelectDate,
    int Function()? getSelectTime) {
  DateTime now = DateTime.now();
  DateTime firstDay = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime lastDay = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 30);
  DateTime _selectedDay = getLastSelectDate!();
  int selectTimeIndex = getSelectTime!();
  ScrollController scrollController =
      ScrollController(initialScrollOffset: selectTimeIndex * 60);

  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Wrap(children: [
          StatefulBuilder(
              builder: (BuildContext context, StateSetter bottomState) {
            return Container(
                child: Column(
              children: [
                Padding(
                    padding:
                        const EdgeInsets.only(top: 23, left: 24, right: 24),
                    child: Row(children: [
                      const Text(
                        "인원 선택",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      const Spacer(flex: 1),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                        iconSize: 24,
                      )
                    ])),
                Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: TableCalendar(
                        focusedDay: now,
                        firstDay: firstDay,
                        lastDay: lastDay,
                        locale: "ko-KR",
                        daysOfWeekHeight: 30,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month'
                        },
                        calendarStyle: const CalendarStyle(
                            selectedDecoration: BoxDecoration(
                          color: Color(0xff383B5A),
                          shape: BoxShape.circle,
                        )),
                        headerStyle: const HeaderStyle(
                            formatButtonVisible: false, titleCentered: true),
                        onDaySelected: (selectedDay, focusedDay) {
                          if (selectedDay.isBefore(DateTime.now()
                              .subtract(const Duration(days: 1)))) {
                            return;
                          }
                          if (!isSameDay(_selectedDay, selectedDay)) {
                            bottomState(() {
                              if (isSameDay(selectedDay, now) &&
                                  now.hour >= selectTimeIndex) {
                                selectTimeIndex = now.hour;
                                scrollController
                                    .jumpTo(60 * now.hour.toDouble());
                              }
                              _selectedDay = selectedDay;
                            });
                          }
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        calendarBuilders:
                            CalendarBuilders(dowBuilder: (context, day) {
                          Center(
                            child: Text(Utils.weekDayMapper(day.weekday)),
                          );
                        }))),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                  child: SizedBox(
                      height: 38,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // 가로 스크롤 설정
                        itemCount: 24,
                        controller: scrollController,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            height: 38,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xffdddddd),
                                ),
                                color: selectTimeIndex == index
                                    ? const Color(0xff476EFF)
                                    : const Color(0xffffffff)),
                            child: GestureDetector(
                              child: Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  '$index 시',
                                  style: TextStyle(
                                    color: _selectedDay.isAfter(now) ||
                                            isSameDay(_selectedDay, now) &&
                                                now.hour <= index
                                        ? selectTimeIndex == index
                                            ? const Color(0xffffffff)
                                            : const Color(0xff050F26)
                                        : const Color(0xffcccccc),
                                    fontSize: 14,
                                  ),
                                ),
                              )),
                              onTap: () {
                                bottomState(() {
                                  if (_selectedDay.isAfter(now) ||
                                      isSameDay(_selectedDay, now) &&
                                          now.hour <= index) {
                                    selectTimeIndex = index;
                                  }
                                });
                              },
                            ),
                          );
                        },
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 27, bottom: 16),
                  child: commonButton(
                      onPressed: () {
                        if (dateSelectCompleteAction != null) {
                          dateSelectCompleteAction(
                              _selectedDay!, selectTimeIndex);
                        }
                        Navigator.pop(context);
                      },
                      width: double.infinity,
                      height: 47.79,
                      buttonText: "선택완료"),
                )
              ],
            ));
          })
        ]);
      });
}

Future<dynamic> showPersonCountBottomSheet(
    BuildContext context,
    TextEditingController controller,
    void Function(int selectedIndex)? setPersonCount,
    int Function()? getPersonCount) {
  int currentSelectedIndex = getPersonCount!() - 1;
  return showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter bottomState) {
          return SizedBox(
            height: 223,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 23, left: 24, right: 24),
                  child: Row(
                    children: [
                      const Text(
                        "인원 선택",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      const Spacer(flex: 1),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                        iconSize: 24,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                  child: SizedBox(
                      height: 38,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // 가로 스크롤 설정
                        itemCount: 9,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            height: 38,
                            decoration: BoxDecoration(
                                color: currentSelectedIndex != null &&
                                        currentSelectedIndex == index
                                    ? const Color(0xff476EFF)
                                    : const Color(0xFFFFFFFF),
                                border: Border.all(
                                  width: 1,
                                  color: currentSelectedIndex != null &&
                                          currentSelectedIndex == index
                                      ? const Color(0xff476EFF)
                                      : const Color(0xFFCCCCCC),
                                )),
                            child: GestureDetector(
                              child: Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  '${index + 1} 명',
                                  style: TextStyle(
                                    color: currentSelectedIndex != null &&
                                            currentSelectedIndex == index
                                        ? Colors.white
                                        : const Color(0xFF000000),
                                    fontSize: 14,
                                  ),
                                ),
                              )),
                              onTap: () {
                                bottomState(() {
                                  currentSelectedIndex = index;
                                });
                              },
                            ),
                          );
                        },
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 27),
                  child: commonButton(
                      onPressed: () {
                        controller.text = "총 ${currentSelectedIndex + 1}명";
                        if (setPersonCount != null) {
                          if (currentSelectedIndex < 1) {
                            currentSelectedIndex = 1;
                          }
                          setPersonCount(currentSelectedIndex);
                        }
                        Navigator.pop(context);
                      },
                      width: double.infinity,
                      height: 47.79,
                      buttonText: "선택완료"),
                )
              ],
            ),
          );
        });
      });
}

class HomeScreenSearchButton extends StatelessWidget {
  bool buttonEnabled;
  void Function(BuildContext context) searchSrtButtonAction;

  HomeScreenSearchButton(
      {super.key,
      required this.buttonEnabled,
      required this.searchSrtButtonAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
        child: SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      buttonEnabled ? const Color(0xFF476EFF) : Colors.black26),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                ),
                onPressed: buttonEnabled
                    ? () {
                        searchSrtButtonAction(context);
                      }
                    : null,
                child: Text(getStrings(context).home_screen_search_srt,
                    style: const TextStyle(
                        color: Color(0xffffffff), fontSize: 16)))));
  }
}

class HomeScreenNoticeBoard extends StatelessWidget {
  final List<NoticeList>? noticeList;

  const HomeScreenNoticeBoard({super.key, required this.noticeList});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: noticeList != null && noticeList!.isNotEmpty,
        child: Padding(
            padding: const EdgeInsets.only(top: 48, left: 24, right: 24),
            child: GestureDetector(
                child: Row(
                  children: [
                    const Image(
                        image:
                            AssetImage('${Constants.IMAGE_PATH}img_alram.png'),
                        width: 20,
                        height: 20),
                    Expanded(
                      flex: 1,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            noticeList?.first.title ?? "",
                            style: const TextStyle(
                                color: Color(0xff000000),
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    const Image(
                        image: AssetImage(
                            '${Constants.IMAGE_PATH}ico_arrow_r.png'),
                        width: 20,
                        height: 20)
                  ],
                ),
                onTap: () {
                  if (noticeList != null) {
                    Utils.urlLauncher(noticeList!.first.linkUrl);
                  }
                })));
  }
}

class AutoScrollPageView extends StatefulWidget {
  final List<BannerList>? bannerList;

  const AutoScrollPageView({super.key, required this.bannerList});

  @override
  _AutoScrollPageViewState createState() => _AutoScrollPageViewState();
}

class _AutoScrollPageViewState extends State<AutoScrollPageView> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (widget.bannerList != null &&
          _currentPageIndex < widget.bannerList!.length - 1) {
        _currentPageIndex++;
      } else {
        _currentPageIndex = 0;
      }

      _pageController.animateToPage(
        _currentPageIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 160,
              child: Stack(children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: (widget.bannerList?.length ?? 0),
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPageIndex = page;
                        });
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            child: Image.network(
                                "http://dpms.openobject.net:4132${widget.bannerList?[index].imgUrl ?? 0}",
                                width: 300,
                                height: 150),
                            onTap: () {
                              if (widget.bannerList != null) {
                                Utils.urlLauncher(
                                    widget.bannerList![index].linkUrl);
                              }
                            });
                      },
                    )),
                Visibility(
                    visible: _currentPageIndex != 0,
                    child: Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: GestureDetector(
                        child: const Image(
                          image: AssetImage(
                              '${Constants.IMAGE_PATH}img_left_circle.png'),
                          width: 24,
                          height: 24,
                        ),
                        onTap: () {
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeIn);
                        },
                      ),
                    )),
                Visibility(
                    visible: widget.bannerList != null &&
                        _currentPageIndex != widget.bannerList!.length - 1,
                    child: Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: GestureDetector(
                        child: const Image(
                          image: AssetImage(
                              '${Constants.IMAGE_PATH}img_arror_circle_r.png'),
                          width: 24,
                          height: 24,
                        ),
                        onTap: () {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeIn);
                        },
                      ),
                    ))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.bannerList?.length ?? 0,
                  effect: const ExpandingDotsEffect(
                      activeDotColor: Color(0xff383B5A),
                      dotColor: Color(0xffDDDDDD),
                      radius: 2,
                      dotHeight: 4,
                      dotWidth: 4),
                  onDotClicked: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeIn,
                    );
                  }),
            )
          ],
        ));
  }
}

class HomeScreenTermsOfService extends StatelessWidget {
  const HomeScreenTermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 46, bottom: 16),
      child: GestureDetector(
        child: Text(getStrings(context).home_screen_reserve_terms,
            style: const TextStyle(
              color: Color(0xff666666),
              fontSize: 12,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xff666666),
// 밑줄 색상
              decorationStyle: TextDecorationStyle.solid,
// 밑줄 스타일
              decorationThickness: 1.0, // 밑줄 두께),
            )),
        onTap: () {
          Utils.urlLauncher(URL_RESERVE_TERMS);
        },
      ),
    );
  }
}

class HomeScreenWarningText extends StatelessWidget {
  const HomeScreenWarningText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: const Color(0xfff8f8f8),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Text(
              getStrings(context).home_screen_warning_text,
              style: const TextStyle(color: Color(0xff888888), fontSize: 11),
              textAlign: TextAlign.center,
            )));
  }
}
