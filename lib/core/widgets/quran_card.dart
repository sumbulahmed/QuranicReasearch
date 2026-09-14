import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import 'app_card.dart';

/// Vintage manuscript card for displaying Surahs or Ayah references.
class QuranCard extends StatelessWidget {
  final int number;
  final String nameEnglish;
  final String nameArabic;
  final String subtitle;
  final bool hasScience;
  final VoidCallback onTap;

  const QuranCard({
    super.key,
    required this.number,
    required this.nameEnglish,
    required this.nameArabic,
    required this.subtitle,
    this.hasScience = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Surah Number in Classic Archival Seal
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryMaroonDark
                  : AppColors.parchmentSubtle,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              border: Border.all(
                color: isDark
                    ? AppColors.darkBorder
                    : AppColors.primaryMaroon.withValues(alpha: 0.25),
                width: 1.0,
              ),
            ),
            child: Text(
              '$number',
              style: AppTypography.titleMedium.copyWith(
                color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Surah English Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      nameEnglish,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.5,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
                      ),
                    ),
                    if (hasScience) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.evidenceStrong.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: AppColors.evidenceStrong.withValues(alpha: 0.3),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.science_outlined,
                              size: 11,
                              color: AppColors.evidenceStrong,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Science',
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 9.5,
                                color: AppColors.evidenceStrong,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Arabic Name Calligraphy
          Text(
            nameArabic,
            style: AppTypography.quranTextSmall.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
            ),
          ),
        ],
      ),
    );
  }
}
