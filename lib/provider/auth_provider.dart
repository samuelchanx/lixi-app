import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/models/question_model_v2.dart';
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
    final response = await client.auth.signUp(email: email, password: password);
    final user = response.user;
    return null;

  }
}
