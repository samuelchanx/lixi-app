import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/assets/assets.gen.dart';
import 'package:lixi/ui/features/diagnosis/app_progress_indicator.dart';
import 'package:lixi/ui/features/diagnosis/q1_period_content.dart';
import 'package:lixi/ui/widgets/page_wrapper.dart';
import 'package:lixi/utils/logger.dart';

class DiagnosisPage extends HookConsumerWidget {
  const DiagnosisPage({
    super.key,
    this.step,
  });

  final int? step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.i('Step from route: $step');
    final currentStep = step ?? 0;
    return PageWrapper(
      stars: getStars(context),
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        shrinkWrap: true,
        children: [
          AppProgressIndicator(
            step: getStep(),
          ),
          if (currentStep == 0) const Q1PeriodContent(),
        ],
      ),
    );
  }

  double getStep() {
    switch (step ?? 0) {
      case 0:
        return 0.25;
      case 1:
        return 0.5;
      case 2:
        return 0.75;
      case 3:
        return 0.95;
      default:
        return 1;
    }
  }

  List<Widget> getStars(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return [
      Positioned(
        top: height * 84 / calculatingPageHeight,
        left: width * 308 / calculatingPageWidth,
        child: Assets.svgs.staticSplash.svg(width: 26),
      ),
      Positioned(
        top: height * 166 / calculatingPageHeight,
        left: width * 20 / calculatingPageWidth,
        child: Assets.svgs.staticSplash.svg(width: 26),
      ),
      Positioned(
        top: height * 332 / calculatingPageHeight,
        left: width * 357 / calculatingPageWidth,
        child: Assets.svgs.staticSplash.svg(width: 26),
      ),
      Positioned(
        top: height * 349 / calculatingPageHeight,
        left: width * 62 / calculatingPageWidth,
        child: Assets.svgs.staticSplash.svg(width: 26),
      ),
      Positioned(
        top: height * 583 / calculatingPageHeight,
        left: width * 208 / calculatingPageWidth,
        child: Assets.svgs.staticSplash.svg(width: 26),
      ),
      Positioned(
        top: height * 806 / calculatingPageHeight,
        left: width * 41 / calculatingPageWidth,
        child: Assets.svgs.staticSplash.svg(height: 26),
      ),
      Positioned(
        top: height * 803 / calculatingPageHeight,
        left: width * 325 / calculatingPageWidth,
        child: Assets.svgs.staticSplash.svg(height: 26),
      ),
    ];
  }
}