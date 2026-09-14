import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/arabic_text.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/translation_text.dart';
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
  Widget build(BuildContext context) {
    final hadithsAsync = ref.watch(collectionHadithsProvider(collectionKey));
    final bookmarks = ref.watch(bookmarksProvider).value ?? [];
    final arabicFontSize = ref.watch(arabicFontSizeProvider);
    final translationPref = ref.watch(translationPreferenceProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final title = _getCollectionTitle(collectionKey);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks_outlined),
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
            onPressed: () => context.push('/library/bookmarks'),
            tooltip: 'Bookmarks',
          ),
        ],
      ),
      body: AppBackground(
        child: hadithsAsync.when(
          data: (hadiths) {
            if (hadiths.isEmpty) {
              return Center(
                child: Text(
                  'No narrations found in this compendium.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: AppDimensions.paddingScreen,
              itemCount: hadiths.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
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
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              'Hadith #${hadith.hadithNumber}',
                              style: AppTypography.labelSmall.copyWith(
                                color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
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
                                  borderRadius: BorderRadius.circular(4),
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
                                      hadith.grading.label,
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.evidenceStrong,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: Icon(
                                  isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                  color: isBookmarked ? AppColors.accentGold : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
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
                                tooltip: 'Bookmark Hadith',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hadith.bookName,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Arabic Matn
                      ArabicText(
                        hadith.textArabic,
                        fontSize: arabicFontSize - 2,
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 12),

                      // English Translation
                      if (translationPref == 'english' || translationPref == 'both') ...[
                        TranslationText(hadith.textTranslation),
                        const SizedBox(height: 8),
                      ],

                      // Urdu Translation
                      if ((translationPref == 'urdu' || translationPref == 'both') &&
                          hadith.textTranslationUrdu != null) ...[
                        Text(
                          hadith.textTranslationUrdu!,
                          textDirection: TextDirection.rtl,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            fontSize: 14.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      if (hadith.narrator != null) ...[
                        Text(
                          'Narrated by: ${hadith.narrator}',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
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
                            color: isDark ? const Color(0xFF2B161B) : AppColors.parchmentSubtle,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
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
                                  hadith.scientificPerspective != null
                                      ? hadith.scientificPerspective!
                                      : 'Empirical research correlation documented',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 13,
                                color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                              ),
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
                                icon: Icon(
                                  Icons.copy_rounded,
                                  size: 16,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                                onPressed: () {
                                  final text = '${hadith.textArabic}\n\n"${hadith.textTranslation}"\n— $title #${hadith.hadithNumber}';
                                  Clipboard.setData(ClipboardData(text: text));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Hadith text copied!'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                tooltip: 'Copy Hadith',
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.share_outlined,
                                  size: 16,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                                onPressed: () {
                                  final text = '${hadith.textArabic}\n\n"${hadith.textTranslation}"\n— $title #${hadith.hadithNumber}';
                                  Clipboard.setData(ClipboardData(text: text));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Hadith ready to share!'),
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
                            icon: Icon(
                              Icons.auto_stories_outlined,
                              size: 14,
                              color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                            ),
                            label: Text(
                              'View Full Analysis',
                              style: TextStyle(
                                color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
      ),
    );
  }
}
