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
    return SizedBox(
      width: MediaQuery.of(context).size.width - 48,
      child: MaterialButton(
        onPressed: () {
          onPressed();
        },
        color: mainPinkColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
          side: const BorderSide(
            color: buttonStrokeColor,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 24.0,
              fontFamily: 'Ming',
              color: Colors.white,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
