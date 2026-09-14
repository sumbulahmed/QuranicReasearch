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

class SurahDetailScreen extends ConsumerWidget {
  final int surahNumber;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahAsync = ref.watch(surahDetailProvider(surahNumber));
    final ayahsAsync = ref.watch(surahAyahsProvider(surahNumber));
    final bookmarks = ref.watch(bookmarksProvider).value ?? [];
    final arabicFontSize = ref.watch(arabicFontSizeProvider);
    final translationPref = ref.watch(translationPreferenceProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: surahAsync.when(
          data: (surah) => Text(
            surah != null ? '${surah.nameEnglish} (${surah.nameArabic})' : 'Surah $surahNumber',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          loading: () => const Text('Loading...'),
          error: (err, stack) => Text('Surah $surahNumber'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size_rounded),
            onPressed: () => _showDisplaySettingsSheet(context, ref),
            tooltip: 'Reading Display Settings',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              Clipboard.setData(ClipboardData(
                text: 'Reading Surah $surahNumber in Bayan Islamic & Science App.',
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Surah link copied to clipboard!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Share Surah',
          ),
        ],
      ),
      body: ayahsAsync.when(
        data: (ayahs) {
          final surah = surahAsync.value;
          return ListView.separated(
            padding: AppDimensions.paddingScreen,
            itemCount: ayahs.length + 1, // +1 for Surah header
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildSurahHeader(context, isDark, surah);
              }
              final ayah = ayahs[index - 1];
              final bookmarkId = 'bm_${ayah.surahNumber}_${ayah.ayahNumber}';
              final isBookmarked = bookmarks.any((b) => b.id == bookmarkId);

              return _buildAyahCard(
                context,
                ref,
                ayah,
                isDark,
                arabicFontSize,
                translationPref,
                isBookmarked,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showDisplaySettingsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final currentSize = ref.watch(arabicFontSizeProvider);
            final currentPref = ref.watch(translationPreferenceProvider);

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Display & Font Settings', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text('Arabic Font Size (${currentSize.toInt()} pt)', style: AppTypography.labelMedium),
                  Slider(
                    value: currentSize,
                    min: 20.0,
                    max: 42.0,
                    divisions: 11,
                    label: '${currentSize.toInt()}',
                    activeColor: AppColors.primaryEmerald,
                    onChanged: (val) {
                      ref.read(arabicFontSizeProvider.notifier).state = val;
                    },
                  ),
                  const SizedBox(height: 12),
                  Text('Translation Mode', style: AppTypography.labelMedium),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'both', label: Text('Both')),
                      ButtonSegment(value: 'english', label: Text('English')),
                      ButtonSegment(value: 'urdu', label: Text('Urdu')),
                    ],
                    selected: {currentPref},
                    onSelectionChanged: (set) {
                      ref.read(translationPreferenceProvider.notifier).state = set.first;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSurahHeader(BuildContext context, bool isDark, dynamic surah) {
    final theme = Theme.of(context);
    final nameArabic = surah?.nameArabic ?? '';
    final nameEnglish = surah?.nameEnglish ?? 'Surah $surahNumber';
    final nameTranslation = surah?.nameTranslation ?? '';
    final revelationType = surah?.revelationType ?? 'Meccan';
    final numberOfAyahs = surah?.numberOfAyahs ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          if (nameArabic.isNotEmpty) ...[
            Text(
              nameArabic,
              style: AppTypography.quranTextLarge.copyWith(
                color: AppColors.primaryEmerald,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
          ],
          Text(
            nameEnglish,
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          if (nameTranslation.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              nameTranslation,
              style: AppTypography.bodySmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryEmerald.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  revelationType,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primaryEmerald,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentTeal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$numberOfAyahs Verses',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accentTeal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (surahNumber != 9) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              style: AppTypography.quranTextLarge.copyWith(
                color: AppColors.primaryEmerald,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'In the name of Allah, the Entirely Merciful, the Especially Merciful',
              style: AppTypography.bodySmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAyahCard(
    BuildContext context,
    WidgetRef ref,
    dynamic ayah,
    bool isDark,
    double arabicFontSize,
    String translationPref,
    bool isBookmarked,
  ) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: () => context.push('/quran/ayah/${ayah.surahNumber}/${ayah.ayahNumber}'),
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ayah Number & Action Bar
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
                  '$surahNumber:${ayah.ayahNumber}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primaryEmerald,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                children: [
                  // Play Audio Button
                  IconButton(
                    icon: const Icon(Icons.play_circle_outline_rounded, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text('Playing Ayah $surahNumber:${ayah.ayahNumber} (Reciter: Mishary Alafasy)'),
                              ),
                            ],
                          ),
                          duration: const Duration(seconds: 3),
                          action: SnackBarAction(
                            label: 'Stop',
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                    tooltip: 'Play Recitation',
                  ),
                  // Bookmark Button
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: isBookmarked ? AppColors.accentGold : null,
                      size: 20,
                    ),
                    onPressed: () {
                      final bookmark = Bookmark(
                        id: 'bm_${ayah.surahNumber}_${ayah.ayahNumber}',
                        itemType: LibraryItemType.ayah,
                        itemId: '${ayah.surahNumber}:${ayah.ayahNumber}',
                        title: 'Surah $surahNumber:${ayah.ayahNumber}',
                        subtitle: ayah.textTranslation,
                        createdAt: DateTime.now(),
                      );
                      ref.read(bookmarksProvider.notifier).toggleBookmark(bookmark);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isBookmarked
                                ? 'Removed Ayah $surahNumber:${ayah.ayahNumber} from bookmarks'
                                : 'Bookmarked Ayah $surahNumber:${ayah.ayahNumber}',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    tooltip: 'Bookmark Ayah',
                  ),
                  // Copy Button
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    onPressed: () {
                      final textToCopy = '${ayah.textArabic}\n\n"${ayah.textTranslation}"\n— Qur\'an $surahNumber:${ayah.ayahNumber}';
                      Clipboard.setData(ClipboardData(text: textToCopy));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ayah text and translation copied!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    tooltip: 'Copy Ayah',
                  ),
                  // Ayah Detail Fullpage Arrow
                  IconButton(
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    onPressed: () => context.push('/quran/ayah/${ayah.surahNumber}/${ayah.ayahNumber}'),
                    tooltip: 'Open Full Ayah Detail & Evidence',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Arabic Quranic Text (Scalable with arabicFontSize)
          ArabicText(
            ayah.textArabic,
            fontSize: arabicFontSize,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 16),

          // English Translation
          if (translationPref == 'english' || translationPref == 'both') ...[
            Text(
              ayah.textTranslation,
              style: AppTypography.bodyLarge.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.6,
              ),
            ),
          ],

          // Urdu Translation
          if ((translationPref == 'urdu' || translationPref == 'both') && ayah.textTranslationUrdu != null) ...[
            const SizedBox(height: 10),
            Text(
              ayah.textTranslationUrdu!,
              textDirection: TextDirection.rtl,
              style: AppTypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                height: 1.7,
                fontSize: 15,
              ),
            ),
          ],

          // Classical Tafseer Expandable
          if (ayah.tafseer != null) ...[
            const SizedBox(height: 14),
            Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(bottom: 8),
                title: Text(
                  'Classical Commentary (Tafseer)',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.accentTeal,
                  ),
                ),
                leading: const Icon(Icons.menu_book_rounded, size: 18, color: AppColors.accentTeal),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    child: Text(
                      ayah.tafseer!,
                      style: AppTypography.bodySmall.copyWith(
                        height: 1.5,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Scientific Research Bridge Button
          if (ayah.hasScientificConnections) ...[
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF163229), const Color(0xFF0F261E)]
                      : [const Color(0xFFE8F5EE), const Color(0xFFF0FAF4)],
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(
                  color: AppColors.primaryEmerald.withValues(alpha: 0.3),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.push('/quran/ayah/${ayah.surahNumber}/${ayah.ayahNumber}'),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.science_rounded,
                            size: 18,
                            color: AppColors.primaryEmerald,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Scientific Research Connection',
                                style: AppTypography.labelMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryEmerald,
                                ),
                              ),
                              Text(
                                'Tap to explore empirical evidence & peer-reviewed citations',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: AppColors.primaryEmerald,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _openScientificEvidenceSheet(BuildContext context, WidgetRef ref, dynamic ayah) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return Consumer(
              builder: (context, ref, _) {
                final connectionsAsync = ref.watch(
                  ayahConnectionsProvider((ayah.surahNumber as int, ayah.ayahNumber as int)),
                );

                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      // Drag handle
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Scientific Evidence: ${ayah.surahNumber}:${ayah.ayahNumber}',
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      // Content
                      Expanded(
                        child: connectionsAsync.when(
                          data: (connections) {
                            if (connections.isEmpty) {
                              return const Center(child: Text('No active connections recorded.'));
                            }
                            return ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.all(20),
                              itemCount: connections.length,
                              itemBuilder: (context, idx) {
                                final conn = connections[idx];
                                return _buildConnectionDetail(context, ref, conn);
                              },
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (err, _) => Center(child: Text('Error: $err')),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildConnectionDetail(BuildContext context, WidgetRef ref, dynamic conn) {
    final theme = Theme.of(context);
    final papersAsync = ref.watch(researchPapersProvider(conn.paperIds as List<String>));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Evidence Badge & Headline
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            EvidenceBadge(level: conn.evidenceLevel),
            TextButton.icon(
              onPressed: () => context.push('/science/topic/${conn.topicId}'),
              icon: const Icon(Icons.category_outlined, size: 14),
              label: const Text('View Topic'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          conn.headline,
          style: AppTypography.headlineLarge.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),

        // Step 1: Classical Tafseer Context
        _buildSectionBlock(
          context,
          'Classical Commentary Context',
          conn.classicalTafseer,
          Icons.menu_book_rounded,
          AppColors.accentTeal,
        ),
        const SizedBox(height: 14),

        // Step 2: Scientific Perspective & Explanation
        _buildSectionBlock(
          context,
          'Scientific Analysis',
          conn.explanation,
          Icons.science_rounded,
          AppColors.primaryEmerald,
        ),
        const SizedBox(height: 14),

        // Step 3: Scientific Consensus Status
        _buildSectionBlock(
          context,
          'Established Scientific Consensus',
          conn.scientificConsensus,
          Icons.verified_rounded,
          AppColors.evidenceStrong,
        ),
        const SizedBox(height: 14),

        // Step 4: Scholarly Caveats & Boundaries
        _buildSectionBlock(
          context,
          'Contextual Caveats & Boundaries',
          conn.scholarlyCaveats,
          Icons.warning_amber_rounded,
          AppColors.evidenceEmerging,
        ),
        const SizedBox(height: 20),

        // Step 5: Peer-Reviewed Research Papers
        Text(
          'Peer-Reviewed Academic Sources',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        papersAsync.when(
          data: (papers) {
            if (papers.isEmpty) {
              return Text(
                'No peer-reviewed papers cited for this claim.',
                style: AppTypography.bodySmall.copyWith(color: theme.colorScheme.onSurfaceVariant),
              );
            }
            return Column(
              children: papers.map((paper) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ResearchCitationCard(
                    title: paper.title,
                    authors: paper.authors,
                    journal: paper.journal,
                    publicationYear: paper.publicationYear,
                    doi: paper.doi,
                    url: paper.sourceUrl,
                    abstractSummary: paper.abstractSummary,
                    isPeerReviewed: paper.isPeerReviewed,
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Text('Error loading papers: $err'),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionBlock(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color accentColor,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
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
            children: [
              Icon(icon, size: 16, color: accentColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.labelMedium.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTypography.bodyMedium.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
