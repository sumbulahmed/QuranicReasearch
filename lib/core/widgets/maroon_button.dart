import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../constants/app_dimensions.dart';

/// Elegant deep maroon button styled like classic bookcloth binding.
class MaroonButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isOutlined;
  final double? width;
  final EdgeInsetsGeometry padding;

  const MaroonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isOutlined = false,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isOutlined) {
      return SizedBox(
        width: width,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            side: BorderSide(
              color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
              width: 1.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
          child: _buildChild(
            isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.primaryMaroon : AppColors.primaryMaroon,
          foregroundColor: AppColors.parchmentCard,
          padding: padding,
          elevation: 1.0,
          shadowColor: AppColors.primaryMaroon.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            side: BorderSide(
              color: AppColors.accentGold.withValues(alpha: 0.35),
              width: 1.0,
            ),
          ),
        ),
        child: _buildChild(AppColors.parchmentCard),
      ),
    );
  }

  Widget _buildChild(Color textColor) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTypography.titleMedium.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      label,
      style: AppTypography.titleMedium.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
