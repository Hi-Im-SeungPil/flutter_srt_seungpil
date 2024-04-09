import 'package:flutter/material.dart';

import '../util/utils.dart';

class ReservationConfirmScreen extends StatelessWidget {
  const ReservationConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _appBar(context),
      body: Container(
        child: Column(
          children: [
            Text("2020.19.19(GOLD)"),
            Text("SRT 961107"),
            Text("뉴욕(23:00) -> 울산(통도사)(23:01)"),
            Text("5년 1분 소요")
          ],
        ),
      ),
    ));
  }
}

PreferredSizeWidget _appBar(BuildContext context) {
  return AppBar(
    toolbarHeight: 56,
    centerTitle: true,
    title: Text("예매 정보 확인",
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18)),
    automaticallyImplyLeading: false,
    actions: [
      IconButton(
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: () {
          Utils.pop(context);
        },
      )
    ],
  );
}
