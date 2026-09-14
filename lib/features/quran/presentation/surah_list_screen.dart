import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/providers/app_providers.dart';
import '../../user_library/domain/entities/bookmark.dart';

class SurahListScreen extends ConsumerStatefulWidget {
  const SurahListScreen({super.key});

  @override
  ConsumerState<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends ConsumerState<SurahListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All'; // 'All', 'Meccan', 'Medinan', 'Science'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surahsAsync = ref.watch(surahsListProvider);
    final bookmarks = ref.watch(bookmarksProvider).value ?? [];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final scienceSurahs = {21, 23, 24, 30, 32, 51, 55, 78, 96};

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'The Noble Qur\'an',
          style: AppTypography.headlineMedium.copyWith(
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
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: AppBackground(
        child: surahsAsync.when(
          data: (surahs) {
            final query = _searchController.text.trim().toLowerCase();
            final filtered = surahs.where((s) {
              final matchesQuery = query.isEmpty ||
                  s.nameEnglish.toLowerCase().contains(query) ||
                  s.nameTranslation.toLowerCase().contains(query) ||
                  s.nameArabic.contains(query) ||
                  s.number.toString() == query;

              if (!matchesQuery) return false;

              if (_selectedFilter == 'Meccan') {
                return s.revelationType.toLowerCase().contains('meccan');
              } else if (_selectedFilter == 'Medinan') {
                return s.revelationType.toLowerCase().contains('medinan');
              } else if (_selectedFilter == 'Science') {
                return scienceSurahs.contains(s.number);
              }
              return true;
            }).toList();

            return Column(
              children: [
                // Manuscript Search Input
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search Surah by title, number, or meaning...',
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                  ),
                ),

                // Archival Category Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      _buildFilterChip('All', Icons.all_inclusive_rounded, isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('Meccan', Icons.location_city_rounded, isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('Medinan', Icons.mosque_rounded, isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('Science', Icons.science_outlined, isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Surah Index List
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No Surahs found in catalog',
                                style: AppTypography.titleMedium.copyWith(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final surah = filtered[index];
                            final hasScience = scienceSurahs.contains(surah.number);
                            final bookmarkId = 'bm_surah_${surah.number}';
                            final isBookmarked = bookmarks.any((b) => b.id == bookmarkId);

                            return AppCard(
                              onTap: () => context.push('/quran/surah/${surah.number}'),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  // Surah Number in Classic Stamp
                                  Container(
                                    width: 40,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.darkSurfaceSubtle
                                          : AppColors.parchmentSubtle,
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                                      border: Border.all(
                                        color: isDark
                                            ? AppColors.darkBorder
                                            : AppColors.primaryMaroon.withValues(alpha: 0.25),
                                        width: 0.9,
                                      ),
                                    ),
                                    child: Text(
                                      '${surah.number}',
                                      style: AppTypography.titleMedium.copyWith(
                                        color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                surah.nameEnglish,
                                                style: AppTypography.titleMedium.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.5,
                                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (hasScience) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.evidenceStrong.withValues(alpha: 0.12),
                                                  borderRadius: BorderRadius.circular(3),
                                                  border: Border.all(
                                                    color: AppColors.evidenceStrong.withValues(alpha: 0.35),
                                                    width: 0.8,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.science_outlined,
                                                      size: 11,
                                                      color: AppColors.evidenceStrong,
                                                    ),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      'Science',
                                                      style: AppTypography.labelSmall.copyWith(
                                                        fontSize: 9.5,
                                                        color: AppColors.evidenceStrong,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${surah.nameTranslation} • ${surah.numberOfAyahs} Verses • ${surah.revelationType}',
                                          style: AppTypography.bodySmall.copyWith(
                                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Arabic Calligraphy
                                  Text(
                                    surah.nameArabic,
                                    style: AppTypography.quranTextSmall.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Bookmark Toggle
                                  IconButton(
                                    icon: Icon(
                                      isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                      color: isBookmarked ? AppColors.accentGold : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      final bm = Bookmark(
                                        id: bookmarkId,
                                        itemType: LibraryItemType.surah,
                                        itemId: surah.number.toString(),
                                        title: surah.nameEnglish,
                                        subtitle: '${surah.nameTranslation} • ${surah.nameArabic}',
                                        createdAt: DateTime.now(),
                                      );
                                      ref.read(bookmarksProvider.notifier).toggleBookmark(bm);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            isBookmarked
                                                ? 'Removed ${surah.nameEnglish} from bookmarks'
                                                : 'Added ${surah.nameEnglish} to bookmarks',
                                          ),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    tooltip: 'Bookmark Surah',
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, bool isDark) {
    final isSelected = _selectedFilter == label;
    final activeColor = isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: isSelected
                ? (isDark ? Colors.black : Colors.white)
                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (_) {
        setState(() {
          _selectedFilter = label;
        });
      },
      selectedColor: activeColor,
      backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
      side: BorderSide(
        color: isSelected ? activeColor : (isDark ? AppColors.darkBorder : AppColors.parchmentBorder),
        width: 0.8,
      ),
      labelStyle: AppTypography.labelSmall.copyWith(
        color: isSelected
            ? (isDark ? Colors.black : Colors.white)
            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }
}
