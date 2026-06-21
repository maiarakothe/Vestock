import 'package:flutter/material.dart';

import '../pages/home/home_screen.dart';
import 'bottom_item.dart';


class FloatingBottomBar extends StatelessWidget {
  final List<NavItem> items;
  final List<int> indices;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const FloatingBottomBar({super.key,
    required this.items,
    required this.indices,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF1F2937) : Colors.white;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? .35 : .08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            for (final int i in indices)
              BottomItem(
                icon: items[i].icon,
                label: items[i].label,
                selected: selectedIndex == i,
                onTap: () => onSelect(i),
              ),
          ],
        ),
      ),
    );
  }
}