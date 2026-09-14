import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardRadius = BorderRadius.circular(borderRadius ?? AppDimensions.radiusLg);
    final bg = backgroundColor ?? (isDark ? theme.colorScheme.surface : theme.colorScheme.surface);
    final border = borderColor ?? theme.colorScheme.outlineVariant.withValues(alpha: isDark ? 0.3 : 0.6);

    final content = Container(
      padding: padding ?? AppDimensions.paddingCard,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: cardRadius,
        border: Border.all(color: border, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
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
