import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/assets/assets.gen.dart';
import 'package:lixi/ui/features/questionnaire/questionnaire_page.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/theme/styles.dart';
import 'package:lixi/ui/widgets/lixi_logo.dart';
import 'package:lixi/ui/widgets/lixi_slogan.dart';
import 'package:lixi/utils/logger.dart';

class LandingPage extends HookConsumerWidget {
  const LandingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = useMemoized(() => MediaQuery.of(context).size.width);
    final checked = useState(false);

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const LixiLogo(),
              const Gap(8),
              const LixiSlogan(),
              const Gap(24),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 24.0,
                  color: normalColor,
                  fontWeight: FontWeight.w200,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('聲明'),
                    const Text(
                      '如果妳正在懷孕或有懷疑，為保障妳的安全，妳不能參與此計劃。',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    const Gap(24),
                    Center(
                      child: Assets.images.pregnancyNew.image(
                        height: MediaQuery.of(context).size.height / 2.5,
                      ),
                    ),
                    const Gap(24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: checked.value,
                          activeColor: highlightColor,
                          side: BorderSide(
                            color: highlightColor,
                            width: 2,
                          ),
                          onChanged: (value) {
                            checked.value = value ?? false;
                          },
                        ),
                        const Expanded(
                          child: Text(
                            '請按同意，以開始妳的調理計劃三步曲。',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '註: 如服用期間發現懷孕，流產或其他情況，lixi 將不負上仼何責任。',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (checked.value) {
                              context.go('/questionnaire');
                            }
                          },
                          style: elevatedButtonStyle.copyWith(
                            backgroundColor: MaterialStatePropertyAll(
                              checked.value ? highlightColor : Colors.grey,
                            ),
                          ),
                          child: const Text(
                            '繼續',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (kDebugMode)
                      ElevatedButton(
                        onPressed: () {
                          final controller =
                              ref.read(questionControllerProvider);
                          try {
                            controller.startTest();
                          } catch (e, stack) {
                            log.severe('$e $stack');
                          }
                        },
                        child: const Text('Test questionnaire'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
