import 'package:flutter/material.dart';
import 'package:lixi/ui/theme/colors.dart';

final baseTheme = ThemeData(
  useMaterial3: true,
  primarySwatch: const MaterialColor(
    0xffDFCAC1,
    <int, Color>{
      50: Color(0xffDFCAC1),
      100: Color(0xffDFCAC1),
      200: Color(0xffDFCAC1),
      300: Color(0xffDFCAC1),
      400: Color(0xffDFCAC1),
      500: Color(0xffDFCAC1),
      600: Color(0xffDFCAC1),
      700: Color(0xffDFCAC1),
      800: Color(0xffDFCAC1),
      900: Color(0xffDFCAC1),
    },
  ),
  primaryColor: highlightColor,
  highlightColor: highlightColor,
  fontFamily: 'Ming',
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
final appTheme = baseTheme.copyWith(
  colorScheme: baseTheme.colorScheme.copyWith(
    primary: highlightColor,
    onPrimary: normalColor,
    secondary: normalColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: mainPinkColor,
      foregroundColor: Colors.white,
      maximumSize: const Size.fromHeight(60),
    ),
  ),
  textTheme: baseTheme.textTheme.apply(
    bodyColor: normalColor,
    displayColor: normalColor,
  ),
  scaffoldBackgroundColor: backgroundColor,
  unselectedWidgetColor: Colors.red,
);

// Color from dex string

Color colorfromDex([String dex = 'FF000000']) {
  return Color(int.parse(dex, radix: 16));
}
