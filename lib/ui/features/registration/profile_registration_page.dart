import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/provider/auth_provider.dart';
import 'package:lixi/ui/features/questionnaire/questionnaire_page.dart';
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
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              const SizedBox(height: 20),
              Text(
                '登記資料',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameText,
                decoration: const InputDecoration(
                  labelText: '名稱',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入名稱';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailText,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: '電郵',
                ),
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
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordText,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  labelText: '密碼',
                ),
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
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneText,
                decoration: const InputDecoration(
                  hintText: 'e.g. 88889999',
                  labelText: '電話',
                ),
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
              const SizedBox(height: 10),
              TextFormField(
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
                decoration: const InputDecoration(
                  labelText: '年齡',
                ),
              ),
              const Gap(24),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    final diagnosedIssues =
                        ref.read(questionControllerProvider).diagnosedIssue;
                    final userAnswers =
                        ref.read(questionControllerProvider).userAnswers;
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
                      if (context.mounted) context.pop(true);
                    } catch (e, stack) {
                      log.severe('$e $stack');
                    }
                    isLoading.value = false;
                  }
                },
                child: HookBuilder(
                  builder: (context) {
                    final value = useValueListenable(isLoading);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: value
                          ? const CircularProgressIndicator()
                          : const Text('繼續'),
                    );
                  },
                ),
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}
