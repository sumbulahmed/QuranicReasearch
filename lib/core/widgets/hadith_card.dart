import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import 'app_card.dart';
import 'arabic_text.dart';
import 'translation_text.dart';

/// Vintage compendium card for Hadith narrations with classical manuscript typography.
class HadithCard extends StatelessWidget {
  final int hadithNumber;
  final String bookName;
  final String gradingLabel;
  final String textArabic;
  final String textTranslation;
  final String? narrator;
  final bool hasScientificConnections;
  final VoidCallback? onBookmark;
  final VoidCallback? onScientificLink;

  const HadithCard({
    super.key,
    required this.hadithNumber,
    required this.bookName,
    required this.gradingLabel,
    required this.textArabic,
    required this.textTranslation,
    this.narrator,
    this.hasScientificConnections = false,
    this.onBookmark,
    this.onScientificLink,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Hadith #, Grading & Bookmark
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceSubtle
                      : AppColors.parchmentSubtle,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  'Hadith #$hadithNumber',
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.evidenceStrong.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                      border: Border.all(
                        color: AppColors.evidenceStrong.withValues(alpha: 0.35),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified, size: 12, color: AppColors.evidenceStrong),
                        const SizedBox(width: 4),
                        Text(
                          gradingLabel,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.evidenceStrong,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onBookmark != null) ...[
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border_rounded, size: 20),
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      onPressed: onBookmark,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            bookName,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 14),

          // Arabic Matn
          ArabicText(
            textArabic,
            fontSize: 22,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 14),

          // English Translation
          TranslationText(textTranslation),

          if (narrator != null) ...[
            const SizedBox(height: 10),
            Text(
              'Narrated by: $narrator',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

          if (hasScientificConnections && onScientificLink != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceSubtle
                    : AppColors.parchmentSubtle,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder
                      : AppColors.primaryMaroon.withValues(alpha: 0.25),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.science_outlined,
                    size: 16,
                    color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Linked to Scientific Topic (Embryology)',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: onScientificLink,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 24),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'View Evidence',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
