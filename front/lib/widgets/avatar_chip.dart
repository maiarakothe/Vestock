import 'package:flutter/material.dart';

import '../app_theme.dart';

class AvatarChip extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const AvatarChip({super.key, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(21),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
          ],
          gradient: const LinearGradient(
            colors: [DefaultColors.primary, DefaultColors.secondary],
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          'L',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}