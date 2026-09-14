import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  String _getCollectionTitle(String key) {
    switch (key.toLowerCase()) {
      case 'bukhari':
        return 'Sahih al-Bukhari';
      case 'muslim':
        return 'Sahih Muslim';
      case 'abudawud':
        return 'Sunan Abi Dawud';
      case 'tirmidhi':
        return 'Jami` at-Tirmidhi';
      default:
        return 'Hadith Collection';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hadithsAsync = ref.watch(collectionHadithsProvider(collectionKey));
    final bookmarks = ref.watch(bookmarksProvider).value ?? [];
    final arabicFontSize = ref.watch(arabicFontSizeProvider);
    final translationPref = ref.watch(translationPreferenceProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final title = _getCollectionTitle(collectionKey);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks_outlined),
            onPressed: () => context.push('/library/bookmarks'),
            tooltip: 'Bookmarks',
          ),
        ],
      ),
      body: hadithsAsync.when(
        data: (hadiths) {
          if (hadiths.isEmpty) {
            return const Center(child: Text('No narrations found in this collection.'));
          }

          return ListView.separated(
            padding: AppDimensions.paddingScreen,
            itemCount: hadiths.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final hadith = hadiths[index];
              final bookmarkId = 'bm_hadith_${hadith.collectionKey}_${hadith.hadithNumber}';
              final isBookmarked = bookmarks.any((b) => b.id == bookmarkId);

              return AppCard(
                onTap: () => context.push('/hadith/detail/${hadith.collectionKey}/${hadith.hadithNumber}'),
                padding: AppDimensions.paddingCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with Number, Grading, and Actions
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
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: hadith.grading.label.toLowerCase() == 'sahih'
                                    ? AppColors.evidenceStrong.withValues(alpha: 0.12)
                                    : AppColors.evidenceModerate.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.verified,
                                    size: 12,
                                    color: hadith.grading.label.toLowerCase() == 'sahih'
                                        ? AppColors.evidenceStrong
                                        : AppColors.evidenceModerate,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    hadith.grading.label,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: hadith.grading.label.toLowerCase() == 'sahih'
                                          ? AppColors.evidenceStrong
                                          : AppColors.evidenceModerate,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              icon: Icon(
                                isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                color: isBookmarked ? AppColors.accentGold : null,
                                size: 20,
                              ),
                              onPressed: () {
                                final bm = Bookmark(
                                  id: bookmarkId,
                                  itemType: LibraryItemType.hadith,
                                  itemId: '${hadith.collectionKey}_${hadith.hadithNumber}',
                                  title: '$title #${hadith.hadithNumber}',
                                  subtitle: hadith.textTranslation,
                                  createdAt: DateTime.now(),
                                );
                                ref.read(bookmarksProvider.notifier).toggleBookmark(bm);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isBookmarked
                                          ? 'Removed from bookmarks'
                                          : 'Bookmarked Hadith #${hadith.hadithNumber}',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ],
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
                      fontSize: arabicFontSize - 2,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 14),

                    // English Translation
                    if (translationPref == 'english' || translationPref == 'both') ...[
                      Text(
                        hadith.textTranslation,
                        style: AppTypography.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Urdu Translation
                    if ((translationPref == 'urdu' || translationPref == 'both') &&
                        hadith.textTranslationUrdu != null) ...[
                      Text(
                        hadith.textTranslationUrdu!,
                        textDirection: TextDirection.rtl,
                        style: AppTypography.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                          height: 1.7,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    if (hadith.narrator != null) ...[
                      Text(
                        'Narrated by: ${hadith.narrator}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.accentTeal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Scientific Link Indicator if connected
                    if (hadith.hasScientificConnections) ...[
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
                                hadith.scientificPerspective != null
                                    ? hadith.scientificPerspective!
                                    : 'Empirical research correlation identified',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primaryEmerald,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primaryEmerald),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Bottom action row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy_rounded, size: 16),
                              onPressed: () {
                                final text = '${hadith.textArabic}\n\n"${hadith.textTranslation}"\n— $title #${hadith.hadithNumber}';
                                Clipboard.setData(ClipboardData(text: text));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Hadith copied to clipboard!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              tooltip: 'Copy',
                            ),
                            IconButton(
                              icon: const Icon(Icons.share_outlined, size: 16),
                              onPressed: () {
                                final text = '${hadith.textArabic}\n\n"${hadith.textTranslation}"\n— $title #${hadith.hadithNumber}';
                                Clipboard.setData(ClipboardData(text: text));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Hadith copied for sharing!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              tooltip: 'Share',
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () => context.push('/hadith/detail/${hadith.collectionKey}/${hadith.hadithNumber}'),
                          icon: const Icon(Icons.open_in_new_rounded, size: 14),
                          label: const Text('View Full Analysis'),
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
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

