import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../services/api_service.dart';

class AvatarChip extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const AvatarChip({super.key, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final String avatarLabel = ApiService.lojaNome?.trim().isNotEmpty == true
        ? ApiService.lojaNome!.trim()[0].toUpperCase()
        : 'L';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(21),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
          ],
          gradient: const LinearGradient(
            colors: <Color>[DefaultColors.primary, DefaultColors.secondary],
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          avatarLabel,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
