import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Literary manuscript card resembling a folio page or vintage research journal section.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final bool showMaroonAccent;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.showMaroonAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardRadius = BorderRadius.circular(borderRadius ?? AppDimensions.radiusMd);
    final bg = backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.parchmentCard);
    final border = borderColor ??
        (isDark ? AppColors.darkBorder : AppColors.parchmentBorder);

    final content = Container(
      padding: padding ?? AppDimensions.paddingCard,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: cardRadius,
        border: Border.all(
          color: showMaroonAccent
              ? (isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon.withValues(alpha: 0.35))
              : border,
          width: showMaroonAccent ? 1.2 : 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF6B5848).withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: cardRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: cardRadius,
          child: content,
        ),
      );
    }

    return content;
  }
}
