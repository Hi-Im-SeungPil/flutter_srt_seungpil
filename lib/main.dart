import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_srt_seungpil/ui/login/login_screen_route.dart';
import 'package:flutter_srt_seungpil/ui/theme/theme_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const SrtApp());
}

class SrtApp extends StatelessWidget {
  const SrtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko', ''), // Korean, no country code
        ],
        home: Scaffold(
          body: const LoginScreenRoute(),
          backgroundColor: Theme.of(context).colorScheme.background,
        ));
  }
}
