import 'package:flutter/material.dart';

class AppTheme {
    ThemeData lightColors = ThemeData(
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF000000),
            onPrimary: Color(0xFFFFFFFF),
            secondary: Color(0xFFFFFFFF),
            onSecondary: Color(0xFFFFFFFF),
            error: Color(0xFFFFFFFF),
            onError: Color(0xFFFFFFFF),
            background: Color(0xFFFFFFFF),
            onBackground: Color(0xFF000000),
            surface: Color(0xFFFFFFFF),
            onSurface: Color(0xFFFFFFFF)
        )
    );

    ThemeData darkColors = ThemeData(
        colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: Color(0xFFFFFFFF),
            onPrimary: Color(0xFFFFFFFF),
            secondary: Color(0xFFFFFFFF),
            onSecondary: Color(0xFFFFFFFF),
            error: Color(0xFFFFFFFF),
            onError: Color(0xFFFFFFFF),
            background: Color(0xFF22242A),
            onBackground: Color(0xFFDEDEDE),
            surface: Color(0xFFFFFFFF),
            onSurface: Color(0xFFFFFFFF)
        )
    );
}