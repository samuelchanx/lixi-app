import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/assets/assets.gen.dart';
import 'package:lixi/ui/features/diagnosis/app_progress_indicator.dart';
import 'package:lixi/ui/features/diagnosis/q1_period_content.dart';
import 'package:lixi/ui/features/diagnosis/q2_blood_content.dart';
import 'package:lixi/ui/features/diagnosis/q3_pain_content.dart';
import 'package:lixi/ui/features/diagnosis/q4_symptoms_content.dart';
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

    final scrollController = useScrollController();
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      });
      return null;
    });
    return PageWrapper(
      stars: getStars(context),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 24,
        ),
        shrinkWrap: true,
        children: [
          AppProgressIndicator(
            step: getStep(),
          ),
          if (currentStep == 0)
            SlideInDown(
              child: const Q1PeriodContent(),
            ),
          if (currentStep == 1)
            SlideInRight(
              child: const Q2BloodContent(),
            ),
          if (currentStep == 2)
            SlideInRight(
              child: const Q3PainContent(),
            ),
          if (currentStep == 3)
            SlideInRight(
              child: const Q4SymptomsContent(),
            ),
          const Center(child: PageFooter()),
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
