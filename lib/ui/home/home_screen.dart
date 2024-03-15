import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../constants/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
            body: Column(
      children: [
        Padding(
            padding: EdgeInsets.only(left: 28, top: 41, right: 24),
            child: Row(
              children: [
                OpenObjectLogo(),
                Spacer(flex: 1),
                IconUnderText(text: "알림함", imageFileName: "img_alram.png"),
                IconUnderText(text: "내 승차권", imageFileName: "img_ticket.png")
              ],
            )),
        SelectBox()
      ],
    )));
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

class SelectBox extends StatefulWidget {
  const SelectBox({super.key});

  @override
  State<SelectBox> createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {
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
                  const SelectedBoxTextColumn(title: "출발역", stationName: '선택'),
                  GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.only(left: 43.5, right: 43.5),
                      child: Image(
                        image: AssetImage(
                            '${Constants.IMAGE_PATH}img_refresh.png'),
                      ),
                    ),
                    onTap: () {},
                  ),
                  const SelectedBoxTextColumn(title: "도착역", stationName: '선택')
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
      Text(widget.stationName,
          style: const TextStyle(
              fontSize: 24,
              color: Color(0xffffffff),
              fontWeight: FontWeight.w700))
    ]);
  }
}
