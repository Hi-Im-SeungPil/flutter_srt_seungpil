import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/ui/login/login_screen_route.dart';
import 'package:flutter_srt_seungpil/ui/login/login_state_holder.dart';
import 'package:flutter_srt_seungpil/ui/login/login_view_model.dart';
import 'package:flutter_srt_seungpil/ui/signup/sign_up_screen_state_holder.dart';
import 'package:flutter_srt_seungpil/ui/signup/sign_up_screen_view_model.dart';
import 'package:flutter_srt_seungpil/ui/theme/theme_color.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const SrtApp());
}

class SrtApp extends StatelessWidget {
  const SrtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (BuildContext context) => LoginScreenViewModel()),
          ChangeNotifierProvider(
              create: (BuildContext context) => SignUpScreenViewModel())
        ],
        child: MaterialApp(
            theme: AppTheme().lightColors,
            darkTheme: AppTheme().darkColors,
            home: Scaffold(
              body: const LoginScreenRoute(),
              backgroundColor: Theme.of(context).colorScheme.background,
            )));
  }
}
