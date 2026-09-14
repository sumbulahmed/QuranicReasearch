import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/arabic_text.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/evidence_badge.dart';
import '../../../core/widgets/research_citation_card.dart';
import '../../../core/providers/app_providers.dart';
import '../../user_library/domain/entities/bookmark.dart';

class AyahDetailScreen extends ConsumerWidget {
  final int surahNumber;
  final int ayahNumber;

  const AyahDetailScreen({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayahAsync = ref.watch(ayahDetailProvider((surahNumber, ayahNumber)));
    final surahAsync = ref.watch(surahDetailProvider(surahNumber));
    final connectionsAsync = ref.watch(ayahConnectionsProvider((surahNumber, ayahNumber)));
    final bookmarks = ref.watch(bookmarksProvider).value ?? [];
    final arabicFontSize = ref.watch(arabicFontSizeProvider);
    final translationPref = ref.watch(translationPreferenceProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bookmarkId = 'bm_${surahNumber}_$ayahNumber';
    final isBookmarked = bookmarks.any((b) => b.id == bookmarkId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ayah $surahNumber:$ayahNumber',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isBookmarked ? AppColors.accentGold : null,
            ),
            onPressed: () {
              final ayah = ayahAsync.value;
              if (ayah == null) return;
              final bm = Bookmark(
                id: bookmarkId,
                itemType: LibraryItemType.ayah,
                itemId: '$surahNumber:$ayahNumber',
                title: 'Surah $surahNumber:$ayahNumber',
                subtitle: ayah.textTranslation,
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
              final ayah = ayahAsync.value;
              if (ayah == null) return;
              Clipboard.setData(ClipboardData(
                text: '${ayah.textArabic}\n\n"${ayah.textTranslation}"\n— Qur\'an $surahNumber:$ayahNumber',
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ayah copied for sharing!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Share Ayah',
          ),
        ],
      ),
      body: ayahAsync.when(
        data: (ayah) {
          if (ayah == null) {
            return const Center(child: Text('Ayah not found.'));
          }

          final surah = surahAsync.value;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Surah info badge
                if (surah != null) ...[
                  InkWell(
                    onTap: () => context.push('/quran/surah/$surahNumber'),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${surah.nameEnglish} (${surah.nameTranslation})',
                                style: AppTypography.titleSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryEmerald,
                                ),
                              ),
                              Text(
                                '${surah.revelationType} • Verse $ayahNumber of ${surah.numberOfAyahs}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            surah.nameArabic,
                            style: AppTypography.quranTextSmall.copyWith(
                              fontSize: 18,
                              color: AppColors.primaryEmerald,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Arabic Quran Card
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              'Verse $surahNumber:$ayahNumber',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primaryEmerald,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          // Recitation play button
                          TextButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text('Playing reciter Mishary Rashid Alafasy for Ayah $surahNumber:$ayahNumber'),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            },
                            icon: const Icon(Icons.volume_up_rounded, size: 16, color: AppColors.primaryEmerald),
                            label: Text(
                              'Listen',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primaryEmerald,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ArabicText(
                        ayah.textArabic,
                        fontSize: arabicFontSize + 4,
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
                              'English Translation (Sahih International)',
                              style: AppTypography.labelMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.accentTeal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ayah.textTranslation,
                          style: AppTypography.bodyLarge.copyWith(height: 1.6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Urdu Translation Card
                if ((translationPref == 'urdu' || translationPref == 'both') && ayah.textTranslationUrdu != null) ...[
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
                              'اردو ترجمہ (فتح محمد جالندھری)',
                              style: AppTypography.labelMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.accentTeal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ayah.textTranslationUrdu!,
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

                // Classical Tafseer Card
                if (ayah.tafseer != null) ...[
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
                              'Classical Exegesis (Tafseer)',
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryEmerald,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ayah.tafseer!,
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

                // Scientific Connections Section
                connectionsAsync.when(
                  data: (connections) {
                    if (connections.isEmpty) {
                      return AppCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, color: AppColors.accentTeal),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'No empirical scientific research mapping is currently indexed for this verse.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

          _buildInfoBlock(
            context,
            'Linguistic & Classical Context',
            conn.classicalTafseer,
            Icons.menu_book_rounded,
            isDark,
          ),
          const SizedBox(height: 12),

          // Scientific Explanation
          _buildInfoBlock(
            context,
            'Modern Scientific Evidence',
            conn.scientificContext,
            Icons.biotech_rounded,
            isDark,
          ),
          const SizedBox(height: 16),

          // Peer Reviewed Papers
          Text(
            'Peer-Reviewed Empirical Literature',
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
      ),
    );
  }

  Widget _buildInfoBlock(
    BuildContext context,
    String title,
    String body,
    IconData icon,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primaryEmerald),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryEmerald,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: AppTypography.bodySmall.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
