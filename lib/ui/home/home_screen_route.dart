import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/ui/home/home_screen.dart';
import 'package:flutter_srt_seungpil/ui/home/home_screen_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreenRoute extends StatelessWidget {
  const HomeScreenRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => HomeScreenViewModel(),
        child: HomeScreen());
  }
}
