import 'package:flutter/material.dart';
import 'package:lixi/ui/theme/colors.dart';

class RoundedCheck extends StatelessWidget {
  final bool selected;
  final Function(bool) onChanged;
  const RoundedCheck({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!selected);
      },
      child: Container(
        width: 46,
        height: 21,
        decoration: BoxDecoration(
          border: Border.all(
            color: buttonStrokeColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: selected
            ? const Icon(
                Icons.check,
                size: 16,
                color: buttonStrokeColor,
              )
            : null,
      ),
    );
  }
}
