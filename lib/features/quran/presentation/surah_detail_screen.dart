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
import '../../../core/widgets/custom_divider.dart';
import '../../../core/widgets/evidence_badge.dart';
import '../../../core/widgets/research_citation_card.dart';
import '../../../core/widgets/translation_text.dart';
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
            surah != null ? '${surah.nameEnglish} • ${surah.nameArabic}' : 'Surah $surahNumber',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
            ),
          ),
          loading: () => const Text('Loading...'),
          error: (err, stack) => Text('Surah $surahNumber'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size_rounded),
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
            onPressed: () => _showDisplaySettingsSheet(context, ref),
            tooltip: 'Reading Display Settings',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
            onPressed: () {
              Clipboard.setData(ClipboardData(
                text: 'Reading Surah $surahNumber in Quranic Research.',
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Surah reference copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Share Surah',
          ),
        ],
      ),
      body: AppBackground(
        child: ayahsAsync.when(
          data: (ayahs) {
            final surah = surahAsync.value;
            return ListView.separated(
              padding: AppDimensions.paddingScreen,
              itemCount: ayahs.length + 1, // +1 for Surah header
              separatorBuilder: (context, index) => const SizedBox(height: 14),
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
          error: (err, _) => Center(child: Text('Error loading Surah: $err')),
        ),
      ),
    );
  }

  void _showDisplaySettingsSheet(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.parchmentCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final currentSize = ref.watch(arabicFontSizeProvider);
            final currentPref = ref.watch(translationPreferenceProvider);

            return Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 3.5,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Manuscript Display Settings',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Arabic Calligraphy Size (${currentSize.toInt()} pt)',
                      style: AppTypography.labelMedium),
                  Slider(
                    value: currentSize,
                    min: 20.0,
                    max: 42.0,
                    divisions: 11,
                    label: '${currentSize.toInt()}',
                    activeColor: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                    onChanged: (val) {
                      ref.read(arabicFontSizeProvider.notifier).state = val;
                    },
                  ),
                  const SizedBox(height: 10),
                  Text('Translation Display', style: AppTypography.labelMedium),
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
                  const SizedBox(height: 14),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSurahHeader(BuildContext context, bool isDark, dynamic surah) {
    final nameArabic = surah?.nameArabic ?? '';
    final nameEnglish = surah?.nameEnglish ?? 'Surah $surahNumber';
    final nameTranslation = surah?.nameTranslation ?? '';
    final revelationType = surah?.revelationType ?? 'Meccan';
    final numberOfAyahs = surah?.numberOfAyahs ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.parchmentCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : AppColors.accentGold.withValues(alpha: 0.4),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF6B5848).withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (nameArabic.isNotEmpty) ...[
            Text(
              nameArabic,
              style: AppTypography.quranTextLarge.copyWith(
                color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
          ],
          Text(
            nameEnglish,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
            ),
            textAlign: TextAlign.center,
          ),
          if (nameTranslation.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              nameTranslation,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  revelationType,
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  '$numberOfAyahs Verses',
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (surahNumber != 9) ...[
            const CustomDivider(showOrnament: true, verticalPadding: 12),
            Text(
              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              style: AppTypography.quranTextLarge.copyWith(
                color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 3),
            Text(
              'In the name of Allah, the Entirely Merciful, the Especially Merciful',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
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
    return AppCard(
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. AYAH HEADER & ACTION BAR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.primaryMaroon.withValues(alpha: 0.25),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  '$surahNumber:${ayah.ayahNumber}',
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.play_circle_outline_rounded,
                      size: 20,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.primaryMaroon,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Playing Ayah $surahNumber:${ayah.ayahNumber} (Sheikh Mishary Alafasy)'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    tooltip: 'Play Recitation',
                  ),
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: isBookmarked ? AppColors.accentGold : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
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
                  IconButton(
                    icon: Icon(
                      Icons.copy_rounded,
                      size: 18,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
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
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2. ARABIC TEXT (Amiri calligraphy)
          ArabicText(
            ayah.textArabic,
            fontSize: arabicFontSize,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 14),

          // 3. TRANSLATION (English & optional Urdu)
          if (translationPref == 'english' || translationPref == 'both') ...[
            TranslationText(ayah.textTranslation),
          ],
          if ((translationPref == 'urdu' || translationPref == 'both') && ayah.textTranslationUrdu != null) ...[
            const SizedBox(height: 8),
            Text(
              ayah.textTranslationUrdu!,
              textDirection: TextDirection.rtl,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontSize: 14.5,
              ),
            ),
          ],

          // 4. CLASSICAL TAFSEER
          if (ayah.tafseer != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                  width: 0.8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        size: 15,
                        color: isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Classical Commentary (Tafseer)',
                        style: AppTypography.labelSmall.copyWith(
                          color: isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ayah.tafseer!,
                    style: AppTypography.tafseerText.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 5. SCIENTIFIC RESEARCH & EVIDENCE SECTION LINK
          if (ayah.hasScientificConnections) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _openScientificEvidenceSheet(context, ref, ayah),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2B161B) : AppColors.parchmentSubtle,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.primaryMaroon.withValues(alpha: 0.3),
                    width: 0.9,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.primaryMaroon.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.science_outlined,
                        size: 18,
                        color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Scientific Research & Empirical Inquest',
                            style: AppTypography.labelMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tap to view scientific perspective, consensus status & peer-reviewed sources',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _openScientificEvidenceSheet(BuildContext context, WidgetRef ref, dynamic ayah) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    color: isDark ? AppColors.darkBackground : AppColors.parchment,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Scientific Evidence: ${ayah.surahNumber}:${ayah.ayahNumber}',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded),
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final papersAsync = ref.watch(researchPapersProvider(conn.paperIds as List<String>));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scientific Headline & Evidence Badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            EvidenceBadge(level: conn.evidenceLevel),
            TextButton.icon(
              onPressed: () => context.push('/science/topic/${conn.topicId}'),
              icon: const Icon(Icons.category_outlined, size: 14),
              label: const Text('View Topic'),
              style: TextButton.styleFrom(
                foregroundColor: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          conn.headline,
          style: AppTypography.headlineLarge.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
          ),
        ),
        const SizedBox(height: 14),

        // 1. Classical Tafseer Context
        _buildSectionBlock(
          context,
          'Classical Commentary Context',
          conn.classicalTafseer,
          Icons.menu_book_rounded,
          isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
        ),
        const SizedBox(height: 14),

        // 2. Scientific Perspective & Explanation
        _buildSectionBlock(
          context,
          'Scientific Analysis',
          conn.explanation,
          Icons.science_outlined,
          isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
        ),
        const SizedBox(height: 14),

        // 3. Scientific Consensus Status
        _buildSectionBlock(
          context,
          'Established Scientific Consensus',
          conn.scientificConsensus,
          Icons.verified_outlined,
          AppColors.evidenceStrong,
        ),
        const SizedBox(height: 14),

        // 4. Scholarly Caveats & Boundaries
        _buildSectionBlock(
          context,
          'Contextual Caveats & Boundaries',
          conn.scholarlyCaveats,
          Icons.warning_amber_rounded,
          AppColors.evidenceEmerging,
        ),
        const SizedBox(height: 20),

        // 5. Peer-Reviewed Research Papers
        Text(
          'Peer-Reviewed Academic Sources',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
          ),
        ),
        const SizedBox(height: 8),
        papersAsync.when(
          data: (papers) {
            if (papers.isEmpty) {
              return Text(
                'No peer-reviewed papers cited for this claim.',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
          width: 0.8,
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
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
