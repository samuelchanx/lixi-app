import 'package:flutter/material.dart';
import 'package:lixi/ui/theme/colors.dart';

class AppOutlinedElevatedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  const AppOutlinedElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
          side: const BorderSide(
            color: buttonStrokeColor,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 100.0,
          vertical: 13.5,
        ),
        child: child,
      ),
    );
  }
}
