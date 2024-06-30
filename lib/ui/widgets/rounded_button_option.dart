import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/widgets/bounce.dart';

class RoundedButtonOption extends HookWidget {
  const RoundedButtonOption({
    super.key,
    required this.text,
    this.selected = true,
    this.showShadow = true,
    this.onPressed,
  });

  final bool selected;
  final String text;
  final Function()? onPressed;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      onPressed: () {
        onPressed?.call();
      },
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: selected ? const Color(0xFFDFCAC1) : Colors.transparent,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFF69665C)),
            borderRadius: BorderRadius.circular(100),
          ),
          shadows: [
            if (selected && showShadow)
              const BoxShadow(
                color: Color(0xFFBDB0AB),
                offset: Offset(0, 6),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: const TextStyle(
              color: buttonStrokeColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
