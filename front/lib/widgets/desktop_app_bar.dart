import 'package:flutter/material.dart';
import 'package:front/widgets/theme_toggle_button.dart';

import '../app_theme.dart';
import 'avatar_chip.dart';

class DesktopAppBar extends StatelessWidget {
  final String title;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onAvatarTap;

  const DesktopAppBar({super.key,
    required this.title,
    required this.isDark,
    required this.onToggleTheme,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(0, 16, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : DefaultColors.text,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 12),
          const SizedBox(width: 8),
          ThemeToggleButton(isDark: isDark, onTap: onToggleTheme),
          const SizedBox(width: 12),
          AvatarChip(isDark: isDark, onTap: onAvatarTap),
        ],
      ),
    );
  }
}
