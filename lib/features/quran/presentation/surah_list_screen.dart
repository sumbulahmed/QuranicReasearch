import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
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
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks_outlined),
            onPressed: () => context.push('/library/bookmarks'),
            tooltip: 'Bookmarks',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: surahsAsync.when(
        data: (surahs) {
          // Filter by search query and chips
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
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search Surah by name, number, or meaning...',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryEmerald),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      borderSide: const BorderSide(
                        color: AppColors.primaryEmerald,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    _buildFilterChip('All', Icons.all_inclusive_rounded),
                    const SizedBox(width: 8),
                    _buildFilterChip('Meccan', Icons.location_city_rounded),
                    const SizedBox(width: 8),
                    _buildFilterChip('Medinan', Icons.mosque_rounded),
                    const SizedBox(width: 8),
                    _buildFilterChip('Science', Icons.science_rounded),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Surah List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded, size: 48, color: theme.colorScheme.onSurfaceVariant),
                            const SizedBox(height: 12),
                            Text(
                              'No Surahs found',
                              style: AppTypography.titleMedium.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                // Surah Number Badge
                                Container(
                                  width: 42,
                                  height: 42,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryEmerald.withValues(alpha: isDark ? 0.2 : 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.primaryEmerald.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '${surah.number}',
                                    style: AppTypography.titleMedium.copyWith(
                                      color: AppColors.primaryEmerald,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Surah Details
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
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (hasScience) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.accentTeal.withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: AppColors.accentTeal.withValues(alpha: 0.3),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(Icons.science_rounded,
                                                      size: 11, color: AppColors.accentTeal),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    'Science',
                                                    style: AppTypography.labelSmall.copyWith(
                                                      fontSize: 10,
                                                      color: AppColors.accentTeal,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${surah.nameTranslation} • ${surah.numberOfAyahs} Verses • ${surah.revelationType}',
                                        style: AppTypography.bodySmall.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Arabic Name
                                Text(
                                  surah.nameArabic,
                                  style: AppTypography.quranTextSmall.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Bookmark Toggle
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                      color: isBookmarked ? AppColors.accentGold : theme.colorScheme.onSurfaceVariant,
                                      size: 20,
                                    ),
                                  ),
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
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isSelected ? Colors.white : null),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (_) {
        setState(() {
          _selectedFilter = label;
        });
      },
      selectedColor: AppColors.primaryEmerald,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }
}
