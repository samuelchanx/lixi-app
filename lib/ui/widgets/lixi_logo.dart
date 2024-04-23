import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LixiLogo extends StatelessWidget {
  const LixiLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'lixi',
      style: GoogleFonts.gildaDisplay().copyWith(
        fontSize: 28,
      ),
    );
  }
}
