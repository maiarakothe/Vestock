import 'package:flutter/material.dart';

class ModernFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const ModernFloatingActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.gradient,
    this.height = 58,
    this.borderRadius = 18,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    final Gradient defaultGradient =
        gradient ??
        const LinearGradient(
          colors: <Color>[Color(0xFF7533FE), Color(0xFF4F7CFF)],
        );

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: defaultGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF7533FE).withOpacity(.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onPressed,
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
