import 'package:flutter/material.dart';
import 'package:lixi/ui/theme/colors.dart';

class AppOutlinedElevatedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double? height;
  final double? fontSize;
  final bool selected;
  const AppOutlinedElevatedButton({
    super.key,
    required this.child,
    this.height,
    this.fontSize,
    this.selected = true,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 48,
      height: height,
      child: MaterialButton(
        onPressed: () {
          onPressed();
        },
        color: selected ? mainPinkColor : backgroundColor,
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
            style: TextStyle(
              fontSize: fontSize ?? 24.0,
              fontFamily: 'Ming',
              color: selected ? Colors.white : borderColor,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
