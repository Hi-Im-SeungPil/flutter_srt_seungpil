import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/ui/reservation/ReservationScreenProvider.dart';
import 'package:provider/provider.dart';

import '../login/login_screen.dart';

class ReservationScreenRoute extends StatelessWidget {
  const ReservationScreenRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => ReservationScreenProvider(),
        child: const LoginScreen());
  }
}
