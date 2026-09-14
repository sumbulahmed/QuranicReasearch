import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/arabic_text.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/research_citation_card.dart';
import '../../../core/providers/app_providers.dart';
import '../../user_library/domain/entities/bookmark.dart';

class HadithDetailScreen extends ConsumerWidget {
  final String collectionKey;
  final String hadithNumber;

  const HadithDetailScreen({
    super.key,
    required this.collectionKey,
    required this.hadithNumber,
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
    final hadithAsync = ref.watch(hadithDetailProvider((collectionKey, hadithNumber)));
    final bookmarks = ref.watch(bookmarksProvider).value ?? [];
    final arabicFontSize = ref.watch(arabicFontSizeProvider);
    final translationPref = ref.watch(translationPreferenceProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final collectionTitle = _getCollectionTitle(collectionKey);
    final bookmarkId = 'bm_hadith_${collectionKey}_$hadithNumber';
    final isBookmarked = bookmarks.any((b) => b.id == bookmarkId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$collectionTitle #$hadithNumber',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isBookmarked ? AppColors.accentGold : null,
            ),
            onPressed: () {
              final hadith = hadithAsync.value;
              if (hadith == null) return;
              final bm = Bookmark(
                id: bookmarkId,
                itemType: LibraryItemType.hadith,
                itemId: '${hadith.collectionKey}_${hadith.hadithNumber}',
                title: '$collectionTitle #${hadith.hadithNumber}',
                subtitle: hadith.textTranslation,
                createdAt: DateTime.now(),
              );
              ref.read(bookmarksProvider.notifier).toggleBookmark(bm);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isBookmarked ? 'Removed from bookmarks' : 'Added to bookmarks',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Bookmark',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              final hadith = hadithAsync.value;
              if (hadith == null) return;
              final text = '${hadith.textArabic}\n\n"${hadith.textTranslation}"\n— $collectionTitle #${hadith.hadithNumber}';
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hadith copied for sharing!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Share',
          ),
        ],
      ),
      body: hadithAsync.when(
        data: (hadith) {
          if (hadith == null) {
            return const Center(child: Text('Hadith not found.'));
          }

          final papersAsync = hadith.relatedResearchIds.isNotEmpty
              ? ref.watch(researchPapersProvider(hadith.relatedResearchIds))
              : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Metadata Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryEmerald.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                            ),
                            child: Text(
                              '$collectionTitle • #${hadith.hadithNumber}',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primaryEmerald,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                  size: 14,
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
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        hadith.bookName,
                        style: AppTypography.bodySmall.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (hadith.narrator != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.accentTeal),
                            const SizedBox(width: 4),
                            Text(
                              'Narrated by: ${hadith.narrator}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.accentTeal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Arabic Text Card
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'النص العربي',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.primaryEmerald,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 16),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: hadith.textArabic));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Arabic text copied!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            tooltip: 'Copy Arabic',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ArabicText(
                        hadith.textArabic,
                        fontSize: arabicFontSize + 2,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // English Translation Card
                if (translationPref == 'english' || translationPref == 'both') ...[
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.translate_rounded, size: 16, color: AppColors.accentTeal),
                            const SizedBox(width: 6),
                            Text(
                              'English Translation',
                              style: AppTypography.labelMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.accentTeal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          hadith.textTranslation,
                          style: AppTypography.bodyLarge.copyWith(height: 1.6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Urdu Translation Card
                if ((translationPref == 'urdu' || translationPref == 'both') &&
                    hadith.textTranslationUrdu != null) ...[
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.g_translate_rounded, size: 16, color: AppColors.accentTeal),
                            const SizedBox(width: 6),
                            Text(
                              'اردو ترجمہ',
                              style: AppTypography.labelMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.accentTeal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          hadith.textTranslationUrdu!,
                          textDirection: TextDirection.rtl,
                          style: AppTypography.bodyLarge.copyWith(
                            height: 1.8,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Sharh / Explanation Card
                if (hadith.explanation != null) ...[
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.menu_book_rounded, size: 18, color: AppColors.primaryEmerald),
                            const SizedBox(width: 8),
                            Text(
                              'Scholarly Commentary (Sharh)',
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryEmerald,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          hadith.explanation!,
                          style: AppTypography.bodyMedium.copyWith(
                            height: 1.6,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Scientific Perspective & Evidence Card
                if (hadith.scientificPerspective != null) ...[
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceCard : AppColors.lightSurfaceCard,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      border: Border.all(
                        color: AppColors.primaryEmerald.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.science_rounded, size: 20, color: AppColors.primaryEmerald),
                            const SizedBox(width: 8),
                            Text(
                              'Scientific & Empirical Perspective',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryEmerald,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          hadith.scientificPerspective!,
                          style: AppTypography.bodyMedium.copyWith(
                            height: 1.6,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        if (papersAsync != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Related Scientific Literature',
                            style: AppTypography.labelMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryEmerald,
                            ),
                          ),
                          const SizedBox(height: 8),
                          papersAsync.when(
                            data: (papers) {
                              return Column(
                                children: papers.map((p) => ResearchCitationCard(paper: p)).toList(),
                              );
                            },
                            loading: () => const LinearProgressIndicator(),
                            error: (err, _) => Text('Error loading papers: $err'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
