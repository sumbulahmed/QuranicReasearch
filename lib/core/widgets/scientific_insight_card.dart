import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import '../models/evidence_level.dart';
import 'app_card.dart';
import 'evidence_badge.dart';

/// Reusable scholarly card presenting a scientific topic with evidence taxonomy.
class ScientificInsightCard extends StatelessWidget {
  final String category;
  final String title;
  final String summary;
  final int connectionsCount;
  final EvidenceLevel evidenceLevel;
  final VoidCallback onTap;

  const ScientificInsightCard({
    super.key,
    required this.category,
    required this.title,
    required this.summary,
    required this.connectionsCount,
    required this.evidenceLevel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      onTap: onTap,
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                        category.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.5,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              EvidenceBadge(level: evidenceLevel, compact: true),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            summary,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_stories_outlined,
                    size: 15,
                    color: isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '$connectionsCount Linked Texts',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Explore Evidence',
                    style: AppTypography.labelMedium.copyWith(
                      color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 13,
                    color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
