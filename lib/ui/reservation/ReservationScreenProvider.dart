import 'package:flutter/cupertino.dart';
import 'package:flutter_srt_seungpil/ui/reservation/ReservationScreenStateHolder.dart';

import 'ReservationScreenViewModel.dart';

class ReservationScreenProvider extends ChangeNotifier {
  ReservationScreenViewModel viewModel = ReservationScreenViewModel();
  ReservationScreenStateHolder holder = ReservationScreenStateHolder();
}