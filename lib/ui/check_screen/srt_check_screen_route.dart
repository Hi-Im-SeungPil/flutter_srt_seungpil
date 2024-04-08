
import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/ui/check_screen/srt_check_screen.dart';
import 'package:flutter_srt_seungpil/ui/check_screen/srt_check_view_model.dart';
import 'package:provider/provider.dart';

class SrtCheckScreenRoute extends StatelessWidget {
  const SrtCheckScreenRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? receivedData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return ChangeNotifierProvider(
        create: (BuildContext context) => SrtCheckScreenViewModel(receivedData: receivedData),
        child: const SrtCheckScreen());
  }
}