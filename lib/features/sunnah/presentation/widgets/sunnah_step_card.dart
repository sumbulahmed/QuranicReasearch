import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/arabic_text.dart';
import '../../data/models/sunnah_step.dart';

class SunnahStepCard extends StatelessWidget {
  final SunnahStep step;
  final bool isCompleted;

  const SunnahStepCard({
    super.key,
    required this.step,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : AppColors.primaryMaroon.withValues(alpha: 0.18),
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.primaryMaroon,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? AppColors.accentGoldLight
                    : AppColors.primaryMaroon,
                width: 1.0,
              ),
            ),
            child: Text(
              '${step.stepNumber}',
              style: AppTypography.labelSmall.copyWith(
                color: isDark ? AppColors.accentGoldLight : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (step.arabicPhrase != null) ...[
                  ArabicText(
                    step.arabicPhrase!,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  step.title,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextHeading
                        : AppColors.lightTextHeading,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
