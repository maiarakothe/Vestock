import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import '../app_theme.dart';

class ThemeSwitcherTile extends StatefulWidget {
  const ThemeSwitcherTile({super.key});

  @override
  State<ThemeSwitcherTile> createState() => _ThemeSwitcherTileState();
}

class _ThemeSwitcherTileState extends State<ThemeSwitcherTile> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (BuildContext context, ThemeMode mode, Widget? child) {
        final bool isDark = mode == ThemeMode.dark;
        return AnimatedToggleSwitch<bool>.dual(
          current: isDark,
          first: false,
          second: true,
          spacing: 45.0,
          height: 40.0,
          borderWidth: 1.0,
          onChanged: (bool value) {
            themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
          },
          style: ToggleStyle(
            borderColor: Colors.grey.withOpacity(0.2),
            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            indicatorColor: DefaultColors.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          iconBuilder: (bool value) => Icon(
            value ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: Colors.white,
            size: 20,
          ),
          textBuilder: (bool value) => Center(
            child: Text(
              value ? 'Noturno' : 'Claro',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
