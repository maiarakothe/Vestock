// lib/app_theme.dart
import 'package:awidgets/custom_theme/custom_theme.dart';
import 'package:flutter/material.dart';

abstract class DefaultColors {
  // Brand
  static const Color primary = Color(0xFF7533FE);
  static const Color primaryLight = Color(0xFF9B6CFF);
  static const Color secondary = Color(0xFF4F7CFF);
  static const Color accent = Color(0xFF14B8A6);

  // Text
  static const Color text = Color(0xFF1E293B);

  // Backgrounds
  static const Color pageColor = Color(0xFFF8FAFC);
  static const Color contentBackground = Color(0xFFF4F5F9);
  static const Color darkPageColor = Color(0xFF111827);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color info = Color(0xFF3B82F6);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
}
// Notificador global para o modo de tema
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

ThemeData themeLight = themeLightData();
ThemeData themeDark = themeDarkData();

ThemeData themeLightData() {
  return ThemeData(
    fontFamily: 'Montserrat',
    fontFamilyFallback: const <String>["NotoColorEmoji"],
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),

    cardColor: Colors.white,

    canvasColor: const Color(0xFFF4F5F9),

    colorScheme: ColorScheme.fromSeed(
      seedColor: DefaultColors.primary,
      brightness: Brightness.light,
      surface: Colors.white,
    ),
    useMaterial3: true,
    tabBarTheme: const TabBarThemeData(
      unselectedLabelColor: Colors.grey,
      indicatorColor: DefaultColors.primary,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: DefaultColors.primary,
            width: 2.0,
          ),
        ),
      ),
    ),
    primaryColor: DefaultColors.primary,
    extensions: <ThemeExtension<dynamic>>[
      ATheme.defaults().copyWith(
        buttonColor: DefaultColors.primary,
        buttonTextColor: Colors.white,
        cancelButtonTextColor: Colors.grey.shade600,
        checkBoxColor: DefaultColors.secondary,
        switchColor: DefaultColors.secondary,
      ),
    ],
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey.shade100, // Fundo levemente cinza para os campos
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DefaultColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: DefaultColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(88, 48),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: DefaultColors.text,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(color: DefaultColors.text),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      elevation: 12,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide.none,
      ),
      actionsPadding: const EdgeInsets.all(16),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade900,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade200,
      selectedColor: DefaultColors.primary,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

ThemeData themeDarkData() {
  return ThemeData(
    fontFamily: 'Montserrat',
    fontFamilyFallback: const <String>["NotoColorEmoji"],
    scaffoldBackgroundColor: const Color(0xFF111827),
    cardColor: const Color(0xFF1F2937),
    canvasColor: const Color(0xFF0F172A),
    colorScheme: ColorScheme.fromSeed(
      seedColor: DefaultColors.primary,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    tabBarTheme: const TabBarThemeData(
      unselectedLabelColor: Colors.white,
      indicatorColor: DefaultColors.primary,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: DefaultColors.primary, width: 2.0),
        ),
      ),
    ),
    primaryColor: DefaultColors.primary,
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFF1E293B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DefaultColors.primary, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: DefaultColors.primary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF0F172A),
      surfaceTintColor: Colors.transparent,
      elevation: 12,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide.none,
      ),
    ),
    chipTheme: ChipThemeData(
      selectedColor: DefaultColors.primary,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
