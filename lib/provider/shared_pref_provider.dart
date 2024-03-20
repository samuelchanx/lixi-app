import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    Provider.autoDispose<SharedPreferences>((ref) {
  throw UnimplementedError();
});
const userAnswerSaveKey = 'questionnaire_v2_user_answers';
final userAnswersProvider = StateProvider<Map<int, UserAnswer>>(
  (ref) {
    final answerString =
        ref.read(sharedPreferencesProvider).getString(userAnswerSaveKey);
    if (answerString == null) {
      return {};
    }
    return (jsonDecode(answerString) as Map<String, UserAnswer>)
        .map((key, value) => MapEntry(int.parse(key), value));
  },
  dependencies: [sharedPreferencesProvider],
);
