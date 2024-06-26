import 'package:flutter/material.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AppProgressIndicator extends StatelessWidget {
  final double step;
  const AppProgressIndicator({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    final intValue = (step * 100).toInt();
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: buttonStrokeColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearPercentIndicator(
              lineHeight: 8,
              percent: step,
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              progressColor: mainPinkColor,
              barRadius: const Radius.circular(8),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: intValue,
              child: const SizedBox(),
            ),
            Expanded(
              flex: 100 - intValue,
              child: Text('$intValue%'),
            ),
          ],
        ),
      ],
    );
  }
}
