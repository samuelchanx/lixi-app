import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/assets/assets.gen.dart';
import 'package:lixi/models/question_model_controller.dart';
import 'package:lixi/provider/question_provider.dart';
import 'package:lixi/ui/features/questionnaire/questionnaire_page.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/theme/styles.dart';
import 'package:lixi/ui/widgets/lixi_logo.dart';
import 'package:lixi/ui/widgets/lixi_slogan.dart';

class LandingPage extends HookConsumerWidget {
  const LandingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = useMemoized(() => MediaQuery.of(context).size.width);
    final checked = useState(false);

    return ProviderScope(
      overrides: [
        questionControllerProvider.overrideWith(
          (ref) => QuestionControllerV2(
            questions: ref.watch(questionsProvider),
            ref: ref,
          ),
        ),
      ],
      child: Scaffold(
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
                      const Text('懷孕'),
                      const Text(
                        '如果您已懷孕或懷疑懷孕，很抱歉我們的計劃不適合您。',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const Gap(24),
                      Center(
                        child: Assets.images.pregnancy.image(
                          width: width / 4,
                        ),
                      ),
                      const Gap(24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              '如果您繼續，便表示您同意您沒有懷孕，在這種情況下發生的任何事情都不屬於lixi的責任。',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(8),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (checked.value) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/questionnaire',
                                  (route) => false,
                                );
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
                            controller.startTest();
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
      ),
    );
  }
}
