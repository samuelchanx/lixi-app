import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/provider/shared_pref_provider.dart';
import 'package:lixi/ui/features/landing/landing_page.dart';
import 'package:lixi/ui/features/questionnaire/questionnaire_page.dart';
import 'package:lixi/ui/features/result/result_page.dart';
import 'package:lixi/ui/theme/theme_data.dart';
import 'package:logging/logging.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
      ],
      child: const MyHealthcareApp(),
    ),
  );
}

class MyHealthcareApp extends HookWidget {
  const MyHealthcareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthcare Questionnaire',
      theme: appTheme,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('zh', 'HK'),
      ],
      routes: {
        '/': (context) => const LandingPage(),
        '/questionnaire': (context) => const QuestionnairePage(),
        '/result': (context) => const ResultPage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/result':
            return PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const ResultPage(),
            );
          default:
            return null;
        }
      },
      initialRoute: '/',
    );
  }
}
