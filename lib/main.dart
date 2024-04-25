import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/provider/auth_provider.dart';
import 'package:lixi/provider/shared_pref_provider.dart';
import 'package:lixi/router/router.dart';
import 'package:lixi/ui/theme/theme_data.dart';
import 'package:lixi/utils/app_initializer.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
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

class MyHealthcareApp extends HookConsumerWidget {
  const MyHealthcareApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return MaterialApp.router(
      title: 'lixi - your daily dose of magic',
      theme: appTheme,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('zh', 'HK'),
      ],
      routerConfig: router,
      // initialRoute: auth.isSignedIn ? '/profile' : '/',
    );
  }
}
