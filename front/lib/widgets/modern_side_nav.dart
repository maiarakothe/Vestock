import 'package:flutter/material.dart';
import 'package:front/widgets/side_item.dart';

import '../app_theme.dart';
import '../pages/home/home_screen.dart';

class ModernSideNav extends StatelessWidget {
  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onAvatarTap;
  final VoidCallback onLogout;

  const ModernSideNav({super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    required this.onAvatarTap,
    required this.onLogout,
  });

  Widget logoutItem({
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: DefaultColors.error.withOpacity(.10),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 18,
                color: DefaultColors.error,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Sair',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: DefaultColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Container(
      width: 272,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? .25 : .05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
      Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Image.asset('assets/images/logo-2-cortado.png', width: 180),
      ),
    ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: items.length,
              itemBuilder: (BuildContext ctx, int i) {
                // Remove o item "Lojas" do menu lateral
                if (items[i].label == 'Lojas') {
                  return const SizedBox.shrink();
                }
                return SideItem(
                  item: items[i],
                  selected: selectedIndex == i,
                  onTap: () => onSelect(i),
                  isDark: isDark,
                );
              },
            ),
          ),
          Divider(
            color: isDark ? Colors.white12 : Colors.black.withOpacity(.06),
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: logoutItem(isDark: isDark, onTap: onLogout),
          ),
        ],
      ),
    );
  }
}