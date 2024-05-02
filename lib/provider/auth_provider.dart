import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authProvider = Provider((ref) => AuthProvider());

class AuthProvider {
  final client = Supabase.instance.client;

  User? get currentUser => client.auth.currentUser;
  bool get isSignedIn => currentUser != null;

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user;
  }

  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    int? age,
    required Map<int, UserAnswer> userAnswers,
    required DiagnosedIssue diagnosedIssues,
  }) async {
    if (currentUser == null) {
      try {
        await client.auth.signUp(email: email, password: password);
      } on AuthException catch (e) {
        if (e.statusCode.toString() == '422') {
          await client.auth.signInWithPassword(
            email: email,
            password: password,
          );
        }
      }
    }
    log.info('signUp');
    final Map<String, dynamic> answers = userAnswers.map(
      (key, value) => MapEntry(key.toString(), value.toJson()),
    );
    final res = await client.from('user').upsert(
      {
        'id': currentUser?.id,
        'name': name,
        'phone': phone,
        'age': age,
        'email': email,
        'diagnosis': diagnosedIssues.toJson(),
        'answer_map': answers,
      },
      onConflict: 'id',
    ).select();
    log.info(res);
    return null;
  }

  Future<void> signOut() {
    return client.auth.signOut();
  }
}
