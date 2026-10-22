import 'package:flutter/material.dart';
import 'package:vegetables_app/ui/color.dart';

/// Reusable Back Button Component for consistent navigation throughout the app.
class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isFrosted;
  final Color? iconColor;
  final Color? backgroundColor;
  final double size;
  final double iconSize;

  const AppBackButton({
    super.key,
    this.onTap,
    this.isFrosted = false,
    this.iconColor,
    this.backgroundColor,
    this.size = 42.0,
    this.iconSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ??
        (isFrosted
            ? Colors.white.withValues(alpha: 0.92)
            : Colors.white);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isFrosted ? 0.08 : 0.04),
            blurRadius: isFrosted ? 12 : 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: onTap ?? () => Navigator.maybePop(context),
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: iconColor ?? textNeutralPrimary,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
