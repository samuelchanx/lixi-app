import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lixi/theme/colors.dart';

final baseTheme = ThemeData(
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
  textTheme: GoogleFonts.gildaDisplayTextTheme()
      .apply(bodyColor: normalColor, displayColor: normalColor),
  scaffoldBackgroundColor: backgroundColor,
);

// Color from dex string

Color colorfromDex([String dex = 'FF000000']) {
  return Color(int.parse(dex, radix: 16));
}
