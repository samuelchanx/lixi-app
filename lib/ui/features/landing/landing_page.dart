import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/assets/assets.gen.dart';
import 'package:lixi/ui/features/questionnaire/questionnaire_page.dart';
import 'package:lixi/ui/widgets/app_outlined_elevated_button.dart';
import 'package:lixi/ui/widgets/page_wrapper.dart';
import 'package:lixi/ui/widgets/sized_vertical.dart';
import 'package:lixi/utils/logger.dart';

const showDebug = false;

class LandingPage extends HookConsumerWidget {
  const LandingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final started = useState(false);
    final height = MediaQuery.of(context).size.height;
    if (!started.value) {
      return PageWrapper(
        showLogo: true,
        stars: getFirstPageStars(context),
        child: Positioned(
          top: height * 703 / 932,
          child: SlideInDown(
            child: AppOutlinedElevatedButton(
              child: const Text(
                '點擊開始',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              onPressed: () {
                started.value = true;
              },
            ),
          ),
        ),
      );
    }
    return PageWrapper(
      stars: getSecondPageStars(context),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedVertical(140),
            const Center(
              child: Text(
                '免責聲明',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(56),
            Center(
              child: Assets.images.pregnancyNew.image(
                height: 287 / 932 * MediaQuery.of(context).size.height,
              ),
            ),
            const Gap(24),
            const Text(
              '此計劃不適用於孕婦',
              style: TextStyle(fontSize: 24),
            ),
            const Gap(48),
            AppOutlinedElevatedButton(
              child: const Text('我沒有懷孕'),
              onPressed: () {},
            ),
            const Gap(40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 56.0),
              child: Text(
                '如服用期間發現懷孕，流產或其他情況，lixi將不負上責任。',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
            if (kDebugMode && showDebug)
              ElevatedButton(
                onPressed: () {
                  final controller = ref.read(questionControllerProvider);
                  try {
                    controller.startTest();
                  } catch (e, stack) {
                    log.severe('$e $stack');
                  }
                },
                child: const Text('Test questionnaire'),
              ),
            if (kDebugMode && showDebug)
              ElevatedButton(
                onPressed: () async {},
                child: const Text('Login'),
              ),
            if (kDebugMode && showDebug)
              ElevatedButton(
                onPressed: () async {
                  context.go('/result');
                },
                child: const Text('Results'),
              ),
          ],
        ),
      ),
    );
  }
}
