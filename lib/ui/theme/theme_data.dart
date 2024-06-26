import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lixi/ui/theme/colors.dart';

final baseTheme = ThemeData(
  useMaterial3: true,
  primarySwatch: Colors.blue,
  primaryColor: highlightColor,
  highlightColor: highlightColor,
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
      maximumSize: const Size.fromHeight(60),
    ),
  ),
  textTheme: GoogleFonts.gildaDisplayTextTheme()
      .apply(bodyColor: normalColor, displayColor: normalColor),
  scaffoldBackgroundColor: backgroundColor,
  unselectedWidgetColor: Colors.red,
);

// Color from dex string

Color colorfromDex([String dex = 'FF000000']) {
  return Color(int.parse(dex, radix: 16));
}
