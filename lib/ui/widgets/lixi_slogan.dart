import 'package:flutter/material.dart';

class LixiSlogan extends StatelessWidget {
  const LixiSlogan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      'your daily dose of magic',
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
        fontWeight: FontWeight.w200,
      ),
      textAlign: TextAlign.center,
    );
  }
}
