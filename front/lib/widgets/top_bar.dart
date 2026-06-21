import 'package:flutter/material.dart';
import 'package:front/widgets/theme_toggle_button.dart';

import '../app_theme.dart';
import 'avatar_chip.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onAvatarTap;

  const TopBar({super.key,
    required this.title,
    required this.isDark,
    required this.onToggleTheme,
    required this.onAvatarTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      foregroundColor: DefaultColors.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 18,
          color: isDark ? Colors.white : DefaultColors.text,
        ),
      ),
      actions: <Widget>[
        ThemeToggleButton(isDark: isDark, onTap: onToggleTheme),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: AvatarChip(isDark: isDark, onTap: onAvatarTap),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? Colors.white12 : Colors.black.withOpacity(.05),
        ),
      ),
    );
  }
}