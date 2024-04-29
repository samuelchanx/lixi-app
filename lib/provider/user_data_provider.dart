import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userDataFutureProvider =
    FutureProvider.autoDispose<(DiagnosedIssue, Map<int, UserAnswer>)>(
  (ref) async {
    final userData = await UserDataProvider().getUserData();
    return userData;
  },
);

class UserDataProvider {
  final client = Supabase.instance.client;

  Future<(DiagnosedIssue, Map<int, UserAnswer>)> getUserData() async {
    final results = await client
        .from('user')
        .select()
        .eq('id', client.auth.currentUser!.id);
    final res = results.first;
    final answers = res['answer_map'] as Map<String, dynamic>;
    final userAnswers = answers.map(
      (key, value) {
        return MapEntry(
          int.parse(key),
          UserAnswer.fromJson(value),
        );
      },
    );
    return (
      DiagnosedIssue.fromJson(res['diagnosis']),
      userAnswers,
    );
  }
}
