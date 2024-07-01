import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/assets/assets.gen.dart';
import 'package:lixi/provider/auth_provider.dart';
import 'package:lixi/ui/features/diagnosis/app_progress_indicator.dart';
import 'package:lixi/ui/features/questionnaire/questionnaire_page.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/widgets/page_wrapper.dart';
import 'package:lixi/utils/logger.dart';

class ProfileRegistrationPage extends HookConsumerWidget {
  const ProfileRegistrationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailText = useTextEditingController();
    final passwordText = useTextEditingController();
    final phoneText = useTextEditingController();
    final nameText = useTextEditingController();
    final ageText = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isLoading = useValueNotifier(false);
    final decoration = InputDecoration(
      filled: true,
      fillColor: lightWhite,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(100),
      ),
    );
    return SlideInDown(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                const AppProgressIndicator(step: 0.99),
                const SizedBox(height: 20),
                Assets.images.logo.svg(
                  width: MediaQuery.of(context).size.width / 2,
                ),
                const Gap(16),
                Center(
                  child: Text(
                    '登記以獲取結果',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFE6D7D1),
                          Color(0xFFE7D9D3),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF69665D),
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const Gap(16),
                          Row(
                            children: [
                              const Text('姓名', style: TextStyle(fontSize: 16)),
                              const Gap(16),
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: TextFormField(
                                    controller: nameText,
                                    decoration: decoration,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '請輸入姓名';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(16),
                          Row(
                            children: [
                              const Text('電郵', style: TextStyle(fontSize: 16)),
                              const Gap(16),
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: TextFormField(
                                    controller: emailText,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: decoration,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '請輸入電郵';
                                      }
                                      if (!value.contains('@')) {
                                        return '請輸入有效電郵';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text('密碼', style: TextStyle(fontSize: 16)),
                              const Gap(16),
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: TextFormField(
                                    controller: passwordText,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: decoration,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '請輸入密碼';
                                      }
                                      if (value.length < 6) {
                                        return '密碼必須至少6位數';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text(
                                '電話',
                                style: TextStyle(fontSize: 16),
                              ),
                              const Gap(16),
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: TextFormField(
                                    controller: phoneText,
                                    decoration: decoration,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '請輸入電話號碼';
                                      }
                                      if (value.length != 8) {
                                        return '請輸入有效的8位數字電話號碼';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text(
                                '年齡',
                                style: TextStyle(fontSize: 16),
                              ),
                              const Gap(16),
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: TextFormField(
                                    controller: ageText,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^[1-9][0-9]*'),
                                      ),
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '請輸入年齡';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return '請輸入有效年齡';
                                      }
                                      return null;
                                    },
                                    decoration: decoration,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Gap(16),
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState?.validate() ?? false) {
                                final diagnosedIssues = ref
                                    .read(questionControllerProvider)
                                    .diagnosedIssue;
                                final userAnswers = ref
                                    .read(questionControllerProvider)
                                    .userAnswers;
                                isLoading.value = true;
                                try {
                                  await ref.read(authProvider).signUp(
                                        email: emailText.text,
                                        password: passwordText.text,
                                        name: nameText.text,
                                        phone: phoneText.text,
                                        age: int.tryParse(ageText.text),
                                        userAnswers: userAnswers,
                                        diagnosedIssues: diagnosedIssues,
                                      );
                                  if (context.mounted) context.go('/result');
                                } catch (e, stack) {
                                  log.severe('$e $stack');
                                }
                                isLoading.value = false;
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text('繼續'),
                            ),
                          ),
                          const PageFooter(),
                        ],
                      ),
                    ),
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
