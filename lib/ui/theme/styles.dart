import 'package:flutter/material.dart';
import 'package:lixi/ui/theme/colors.dart';

final elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: highlightColor,
  padding: const EdgeInsets.symmetric(
    horizontal: 24.0,
    vertical: 16,
  ),
  shape: const StadiumBorder(),
  shadowColor: Colors.transparent,
);
