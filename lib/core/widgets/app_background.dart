import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Reusable background widget providing a subtle parchment / aged paper aesthetic
/// and adaptive desktop/web container centering.
class AppBackground extends StatelessWidget {
  final Widget child;
  final bool constrainWidth;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const AppBackground({
    super.key,
    required this.child,
    this.constrainWidth = true,
    this.maxWidth = 920.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget content = child;
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    if (constrainWidth) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: content,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.parchment,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color(0xFF1E1917),
                  AppColors.darkBackground,
                  const Color(0xFF161211),
                ]
              : [
                  const Color(0xFFFCF9F2), // subtle illuminated paper top
                  AppColors.parchment,
                  const Color(0xFFF7F0E3), // warm aged parchment bottom
                ],
        ),
      ),
      child: content,
    );
  }
}
