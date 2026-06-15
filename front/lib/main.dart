import 'package:flutter/material.dart';
import 'package:front/pages/home/home_screen.dart';
import 'package:front/pages/login/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Vestock',
          theme: themeLight,
          darkTheme: themeDark,
          themeMode: currentMode,
          debugShowCheckedModeBanner: false,
          home: const LoginScreen(),
          locale: const Locale('pt', 'BR'),
          supportedLocales: const <Locale>[Locale('pt', 'BR')],
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
