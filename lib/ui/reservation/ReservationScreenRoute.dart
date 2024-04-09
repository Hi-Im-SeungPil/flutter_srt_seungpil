import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/ui/reservation/ReservationScreen.dart';
import 'package:flutter_srt_seungpil/ui/reservation/ReservationScreenProvider.dart';
import 'package:provider/provider.dart';

class ReservationScreenRoute extends StatelessWidget {
  const ReservationScreenRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? reservationInfo = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return ChangeNotifierProvider(
        create: (BuildContext context) => ReservationScreenProvider(reservationInfo: reservationInfo),
        child: const ReservationScreen());
  }
}