import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/providers/app_providers.dart';

class HadithCollectionsScreen extends ConsumerWidget {
  const HadithCollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(hadithCollectionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hadith Compendiums',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
          ),
        ),
      ),
      body: AppBackground(
        child: collectionsAsync.when(
          data: (collections) {
            return ListView.separated(
              padding: AppDimensions.paddingScreen,
              itemCount: collections.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final col = collections[index];
                return AppCard(
                  onTap: () => context.push('/hadith/collection/${col.key}'),
                  padding: AppDimensions.paddingCard,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            col.nameEnglish,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
                            ),
                          ),
                          Text(
                            col.nameArabic,
                            style: AppTypography.quranTextSmall.copyWith(
                              fontSize: 20,
                              color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Compiled by ${col.compiler} • ${col.totalHadiths} Narrations',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        col.description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Explore Compendium',
                            style: AppTypography.labelMedium.copyWith(
                              color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error loading collections: $err')),
        ),
      ),
    );
  }
}
