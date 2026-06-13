import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/dark/mocha.dart';
import 'theme/light/latte.dart';
import 'theme/theme_notifier.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadSavedTheme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) => MaterialApp(
        theme:     AppTheme.from(Latte()),
        darkTheme: AppTheme.from(Mocha()),
        themeMode: mode,
        home: const HomePage(),
      ),
    );
  }
}
