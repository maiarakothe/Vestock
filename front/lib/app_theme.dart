// lib/app_theme.dart
import 'package:flutter/material.dart';

const kPrimary = Color(0xFF6744CF);
const kPrimaryLight = Color(0xFFA084E0);
const kAccent = Color(0xFF28B070);

abstract class DefaultColors {
  static const Color primary = Color(0xFF006874);
  static const Color secondary = Color(0xFF46C8BC);
  static const Color secondary2 = Color(0xFFCCE0DC);
  static const Color text = Color(0xFF424242);
  static const Color pageColor = Color(0xFFf7fcfb);
  static const Color darkPageColor = Color(0xFF303030);

  static const Color success = Color(0xFF46c77a);
  static const Color accent = Color(0xFF4693c7);
  static const Color info = Color(0xFF4653c7);
  static const Color error = Color(0xFFc74653);
  static const Color warning = Color(0xFFc77a46);
}

//Para alterar o estado do tema do app precisa do hot reload
ThemeData themeLight = themeLightData();
ThemeData themeDark = themeDarkData();

ThemeData themeLightData() {
  return ThemeData(
    fontFamily: 'Montserrat',
    fontFamilyFallback: const <String>["NotoColorEmoji"],
    canvasColor: Colors.grey.shade200,
    colorScheme: ColorScheme.fromSeed(
      seedColor: DefaultColors.primary,
      brightness: Brightness.light,
    ),
    useMaterial3: false,
    tabBarTheme: const TabBarThemeData(
      labelColor: DefaultColors.primary,
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        backgroundColor: Colors.grey.shade600,
        foregroundColor: Colors.grey.shade50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
    ),
    sliderTheme: SliderThemeData(
      overlayShape: SliderComponentShape.noOverlay,
      activeTrackColor: DefaultColors.primary,
    ),
    // Para os dropdowns não mudarem a fonte
    textTheme: const TextTheme(),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade900,
      ),
      elevation: 2,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade200,
      selectedColor: DefaultColors.primary,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}

ThemeData themeDarkData() {
  return ThemeData(
    fontFamily: 'Montserrat',
    fontFamilyFallback: const <String>["NotoColorEmoji"],
    canvasColor: Colors.grey.shade900,
    colorScheme: ColorScheme.fromSeed(
      seedColor: DefaultColors.primary,
      brightness: Brightness.dark,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: DefaultColors.primary,
      unselectedLabelColor: Colors.white,
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
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.all(Colors.grey.shade900),
    ),
    useMaterial3: false,
    primaryColor: DefaultColors.primary,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        backgroundColor: Colors.grey.shade600,
        foregroundColor: Colors.grey.shade50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
    ),
    sliderTheme: SliderThemeData(
      overlayShape: SliderComponentShape.noThumb,
      activeTrackColor: DefaultColors.primary,
    ),
    // Para os dropdowns não mudarem a fonte
    textTheme: const TextTheme(),
    chipTheme: ChipThemeData(
      selectedColor: DefaultColors.primary,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}
