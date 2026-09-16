import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/arabic_text.dart';
import '../../data/models/sunnah_practice.dart';
import '../providers/sunnah_providers.dart';

class SunnahCard extends ConsumerWidget {
  final SunnahPractice practice;

  const SunnahCard({
    super.key,
    required this.practice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isBookmarked = ref.watch(sunnahBookmarksProvider).contains(practice.id);
    final isChildMode = ref.watch(sunnahChildModeProvider);

    final displayTitle = (isChildMode && practice.childTitle != null)
        ? practice.childTitle!
        : practice.title;
    final displayDescription = (isChildMode && practice.childDescription != null)
        ? practice.childDescription!
        : practice.description;

    return AppCard(
      onTap: () => context.push('/sunnah/${practice.id}'),
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Category Tag, Science Badge, and Bookmark Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceSubtle
                            : AppColors.parchmentSubtle,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.primaryMaroon.withValues(alpha: 0.2),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        practice.category,
                        style: AppTypography.labelSmall.copyWith(
                          color: isDark
                              ? AppColors.accentGoldLight
                              : AppColors.primaryMaroon,
                          fontWeight: FontWeight.w700,
                          fontSize: 10.5,
                        ),
                      ),
                    ),
                    if (practice.hasScience)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.evidenceModerate.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.evidenceModerate.withValues(alpha: 0.4),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.science_rounded,
                              size: 11,
                              color: AppColors.evidenceModerate,
                            ),
                            const SizedBox(width: 3.5),
                            Text(
                              'Science Insights',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.evidenceModerate,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(
                  isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  size: 20,
                  color: isBookmarked
                      ? AppColors.accentGold
                      : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
                ),
                onPressed: () {
                  ref
                      .read(sunnahBookmarksProvider.notifier)
                      .toggleBookmark(practice.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isBookmarked
                            ? 'Removed from Sunnah Bookmarks'
                            : 'Saved to Sunnah Bookmarks',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                tooltip: 'Bookmark',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Arabic Title
          ArabicText(
            practice.arabicTitle,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),

          // English Title
          Text(
            displayTitle,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextHeading
                  : AppColors.lightTextHeading,
            ),
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            displayDescription,
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              height: 1.45,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),

          // Hadith Source citation footer
          if (practice.hadithReferences.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 13,
                  color: isDark
                      ? AppColors.accentGoldLight
                      : AppColors.accentSepia,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '${practice.hadithReferences.first.collection} ${practice.hadithReferences.first.hadithNumber}',
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark
                          ? AppColors.accentGoldLight
                          : AppColors.accentSepia,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: isDark
                      ? AppColors.accentGoldLight
                      : AppColors.primaryMaroon,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
