import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../pages/home/home_screen.dart';

class SideItem extends StatelessWidget {
  final NavItem item;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  const SideItem({super.key,
    required this.item,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = DefaultColors.primary;
    final Color inactiveText = isDark ? Colors.white70 : const Color(0xFF475569);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            left: 0,
            top: selected ? 10 : 22,
            bottom: selected ? 10 : 22,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 3,
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    DefaultColors.primary,
                    DefaultColors.secondary,
                  ],
                )
                    : null,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(14),
                hoverColor: activeColor.withOpacity(.06),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: selected
                        ? LinearGradient(
                      colors: <Color>[
                        activeColor.withOpacity(.12),
                        DefaultColors.secondary.withOpacity(.10),
                      ],
                    )
                        : null,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: selected
                              ? const LinearGradient(
                            colors: <Color>[
                              DefaultColors.primary,
                              DefaultColors.secondary,
                            ],
                          )
                              : null,
                          color: selected
                              ? null
                              : (isDark
                              ? Colors.white.withOpacity(.04)
                              : const Color(0xFFF1F3F9)),
                          borderRadius: BorderRadius.circular(11),
                          boxShadow: selected
                              ? <BoxShadow>[
                            BoxShadow(
                              color: activeColor.withOpacity(.35),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ]
                              : null,
                        ),
                        child: Icon(
                          item.icon,
                          size: 19,
                          color: selected ? Colors.white : inactiveText,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: selected
                                ? (isDark ? Colors.white : DefaultColors.text)
                                : inactiveText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}