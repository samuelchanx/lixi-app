import 'package:dartx/dartx.dart';
import 'package:go_router/go_router.dart';
import 'package:lixi/ui/features/landing/landing_page.dart';
import 'package:lixi/ui/features/questionnaire/questionnaire_page.dart';
import 'package:lixi/ui/features/result/result_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/questionnaire',
      builder: (context, state) => QuestionnairePage(
        step: state.uri.queryParameters['step'].toString().toIntOrNull(),
      ),
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) => const ResultPage(),
    ),
  ],
);
