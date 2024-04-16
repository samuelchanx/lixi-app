import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    Provider.autoDispose<SharedPreferences>((ref) {
  throw UnimplementedError();
});
const userAnswerSaveKey = 'questionnaire_v2_user_answers';
const diagnosedIssueSaveKey = 'questionnaire_v2_diagnosed_issue';
final userAnswersProvider = StateProvider<Map<int, UserAnswer>>(
  (ref) {
    return {};
    final answerString =
        ref.read(sharedPreferencesProvider).getString(userAnswerSaveKey);
    if (answerString == null) {
      return {};
    }
    return (jsonDecode(answerString) as Map<String, dynamic>).map(
      (key, value) => MapEntry(int.parse(key), UserAnswer.fromJson(value)),
    );
  },
  dependencies: [sharedPreferencesProvider],
);

final diagnosedIssuesProvider = StateProvider<DiagnosedIssue>(
  (ref) {
    final answerString =
        ref.read(sharedPreferencesProvider).getString(diagnosedIssueSaveKey);
    if (answerString == null) {
      return const DiagnosedIssue();
    }
    return DiagnosedIssue.fromJson(jsonDecode(answerString));
  },
  dependencies: [sharedPreferencesProvider],
);
