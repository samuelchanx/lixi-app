import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/models/question_model_controller.dart';
import 'package:lixi/provider/user_data_provider.dart';
import 'package:lixi/ui/features/questionnaire/questionnaire_page.dart';
import 'package:lixi/ui/widgets/lixi_logo.dart';
import 'package:lixi/ui/widgets/lixi_slogan.dart';
import 'package:lixi/utils/date_formatter.dart';

class ResultPage extends HookConsumerWidget {
  const ResultPage({
    super.key,
  });

  String buildDateRangeText(List<DateTime> dates) {
    return '${dates.first.yearMonthDay} - ${dates.last.yearMonthDay}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(userDataFutureProvider);
    final controller = ref.watch(questionControllerProvider);
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
            ...results.when(
              data: (data) {
                final periodPrediction = getPeriodPrediction(data.$2);
                controller.updateAnswers(data.$2);
                controller.diagnoseCurrentAnswers();
                return [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FadeInDown(
                      duration: const Duration(seconds: 1),
                      child: Text(
                        '診斷：${controller.diagnosedIssue.bodyTypes?.map((e) => e.title).join(', ')}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FadeInDown(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 500),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'lixi治療方案：',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '月經期 — 理血舒氣\n經後期 — 補肝腎，養沖任，調和氣血\n排卵期 — 溫補腎陽，填補腎陰\n經前期 — 肝腎同調',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // TODO:
                  const Gap(16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FadeInDown(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 500),
                      child: Builder(
                        builder: (context) {
                          final periodText =
                              '''月經期 [${buildDateRangeText(periodPrediction.$1)}] 
經後期 [${buildDateRangeText(periodPrediction.$2)}] New Moon 早 (1) | 晚 (1)
排卵期 [${buildDateRangeText(periodPrediction.$3)}] Bal samic 早 (2.1) | 晚(2.2)
經前期 [${buildDateRangeText(periodPrediction.$4)}] Full Moon 早 (3.1) | 晚(3.2)''';
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'lixi使用方法：',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                periodText,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  SlideInLeft(
                    duration: const Duration(seconds: 1),
                    child: const Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          // ...issues.entries.map(
                          //   (e) => ListTile(
                          //     title: Text(e.key),
                          //     trailing: Text(e.value.toString()),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.go('/');
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('重新開始'),
                    ),
                  ),
                ];
              },
              error: (_, __) => [
                const Text('未有結果'),
                Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go('/');
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('開始測試'),
                  ),
                ),
              ],
              loading: () => [const CircularProgressIndicator()],
            ),
          ],
        ),
      ),
    );
  }
}
