import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/ui/widgets/lixi_logo.dart';
import 'package:lixi/ui/widgets/lixi_slogan.dart';

class ResultPage extends HookConsumerWidget {
  const ResultPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnosedIssue = useMemoized(
      () =>
          ModalRoute.of(context)!.settings.arguments as DiagnosedIssue? ??
          const DiagnosedIssue(),
    );
    // useEffect(
    //   () {
    //     controller.diagnose();
    //     return null;
    //   },
    //   const [],
    // );
    final issues = diagnosedIssue.toJson();
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const LixiLogo(),
            const Gap(8),
            const LixiSlogan(),
            const Gap(24),
            Align(
              alignment: Alignment.centerLeft,
              child: FadeInDown(
                duration: const Duration(seconds: 1),
                child: const Text(
                  '診斷',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: FadeInDown(
                duration: const Duration(seconds: 1),
                delay: const Duration(milliseconds: 500),
                child: const Text(
                  'lixi治療方案',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: FadeInDown(
                duration: const Duration(seconds: 1),
                delay: const Duration(milliseconds: 500),
                child: const Text(
                  'lixi使用方法',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SlideInLeft(
              duration: const Duration(seconds: 1),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    ...issues.entries.map(
                      (e) => ListTile(
                        title: Text(e.key),
                        trailing: Text(e.value.toString()),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'You should take some rest and drink lots of water.',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
