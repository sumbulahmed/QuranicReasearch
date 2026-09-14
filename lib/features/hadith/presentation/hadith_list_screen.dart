import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/arabic_text.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/providers/app_providers.dart';
import '../../user_library/domain/entities/bookmark.dart';

class HadithListScreen extends ConsumerWidget {
  final String collectionKey;

  const HadithListScreen({
    super.key,
    required this.collectionKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hadithsAsync = ref.watch(collectionHadithsProvider(collectionKey));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final title = collectionKey == 'bukhari' ? 'Sahih al-Bukhari' : 'Sahih Muslim';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: hadithsAsync.when(
        data: (hadiths) {
          return ListView.separated(
            padding: AppDimensions.paddingScreen,
            itemCount: hadiths.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final hadith = hadiths[index];
              return AppCard(
                padding: AppDimensions.paddingCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with Number, Book Name, and Grading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                          ),
                          child: Text(
                            'Hadith #${hadith.hadithNumber}',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primaryEmerald,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.evidenceStrong.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.verified, size: 12, color: AppColors.evidenceStrong),
                              const SizedBox(width: 4),
                              Text(
                                hadith.grading.label,
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.evidenceStrong,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark_border_rounded, size: 20),
                          onPressed: () {
                            final bm = Bookmark(
                              id: 'bm_hadith_${hadith.collectionKey}_${hadith.hadithNumber}',
                              itemType: LibraryItemType.hadith,
                              itemId: '${hadith.collectionKey}_${hadith.hadithNumber}',
                              title: '$title #${hadith.hadithNumber}',
                              subtitle: hadith.textTranslation,
                              createdAt: DateTime.now(),
                            );
                            ref.read(bookmarksProvider.notifier).toggleBookmark(bm);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Bookmarked Hadith #${hadith.hadithNumber}'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      hadith.bookName,
                      style: AppTypography.bodySmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Arabic Hadith Text
                    ArabicText(
                      hadith.textArabic,
                      fontSize: 22,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 14),

                    // English Translation
                    Text(
                      hadith.textTranslation,
                      style: AppTypography.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.6,
                      ),
                    ),

                    if (hadith.narrator != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Narrated by: ${hadith.narrator}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.accentTeal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    // Scientific Link Indicator if connected
                    if (hadith.hasScientificConnections) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF132B23) : const Color(0xFFEAF5F0),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          border: Border.all(color: AppColors.primaryEmerald.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.science_rounded, size: 16, color: AppColors.primaryEmerald),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Linked to Scientific Topic (Embryology)',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primaryEmerald,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.push('/science/topic/embryology'),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 24),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('View Evidence'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
