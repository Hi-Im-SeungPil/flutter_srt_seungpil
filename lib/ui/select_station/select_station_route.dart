import 'package:flutter/cupertino.dart';
import 'package:flutter_srt_seungpil/ui/select_station/select_station_screen.dart';
import 'package:flutter_srt_seungpil/ui/select_station/selection_screen_state_holder.dart';
import 'package:provider/provider.dart';

class SelectStationScreenRoute extends StatelessWidget {
  const SelectStationScreenRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? receivedData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return ChangeNotifierProvider(
        create: (BuildContext context) => SelectionScreenStateHolder(receivedData: receivedData),
        child: SelectStationScreen());
  }
}