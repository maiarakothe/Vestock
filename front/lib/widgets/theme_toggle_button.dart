import 'package:flutter/material.dart';
import '../app_theme.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const ThemeToggleButton({super.key, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(.06)
              : const Color(0xFFF1F3F9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (Widget child, Animation<double> anim) => RotationTransition(
            turns: Tween<double>(begin: .75, end: 1).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            key: ValueKey<bool>(isDark),
            size: 20,
            color: isDark ? const Color(0xFFFFD37A) : DefaultColors.primary,
          ),
        ),
      ),
    );
  }
}