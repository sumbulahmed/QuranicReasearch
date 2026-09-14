import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/providers/app_providers.dart';

class HadithCollectionsScreen extends ConsumerStatefulWidget {
  const HadithCollectionsScreen({super.key});

  @override
  ConsumerState<HadithCollectionsScreen> createState() => _HadithCollectionsScreenState();
}

class _HadithCollectionsScreenState extends ConsumerState<HadithCollectionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collectionsAsync = ref.watch(hadithCollectionsProvider);
    final categoriesAsync = ref.watch(hadithCategoriesProvider);
    final allHadithsAsync = ref.watch(allHadithsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final query = _searchController.text.trim().toLowerCase();
    final isSearching = query.isNotEmpty || _selectedCategory != 'All';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hadith & Sunnah',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks_outlined),
            onPressed: () => context.push('/library/bookmarks'),
            tooltip: 'Bookmarks',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search hadiths by keyword, narrator, or topic...',
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

          // Categories Filter Chips
          categoriesAsync.when(
            data: (categories) {
              final allCats = ['All', ...categories];
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: allCats.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(cat),
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                        selectedColor: AppColors.primaryEmerald,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : null,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
            loading: () => const SizedBox(height: 38),
            error: (err, stack) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 8),

          // Main View: Either Search/Filter Results OR Compendiums List
          Expanded(
            child: isSearching
                ? _buildFilteredHadithsView(allHadithsAsync, query, _selectedCategory, isDark)
                : _buildCollectionsView(collectionsAsync, allHadithsAsync, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsView(
    AsyncValue<dynamic> collectionsAsync,
    AsyncValue<dynamic> allHadithsAsync,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    return ListView(
      padding: AppDimensions.paddingScreen,
      children: [
        // Daily Featured Hadith Banner
        AppCard(
          onTap: () => context.push('/hadith/detail/bukhari/5678'),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        'Featured Hadith: Prophetic Medicine',
                        style: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentGold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accentTeal.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Scientific Link',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.accentTeal,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'عَلَيْكُمْ بِهَذِهِ الْحَبَّةِ السَّوْدَاءِ فَإِنَّ فِيهَا شِفَاءً مِنْ كُلِّ دَاءٍ إِلَّا السَّامَ',
                textDirection: TextDirection.rtl,
                style: AppTypography.quranTextSmall.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '"Use this Black Seed (Nigella sativa), for in it is healing for every disease except death."',
                style: AppTypography.bodySmall.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sahih al-Bukhari #5678 • Thymoquinone Research',
                    style: AppTypography.labelSmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Read Analysis',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primaryEmerald,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: 16, color: AppColors.primaryEmerald),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Canonical Compendiums Section Header
        Row(
          children: [
            const Icon(Icons.collections_bookmark_rounded, size: 20, color: AppColors.primaryEmerald),
            const SizedBox(width: 8),
            Text(
              'Canonical Compendiums',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Collections List
        collectionsAsync.when(
          data: (collections) {
            return Column(
              children: collections.map<Widget>((col) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
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
                              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              col.nameArabic,
                              style: AppTypography.quranTextSmall.copyWith(
                                fontSize: 18,
                                color: AppColors.primaryEmerald,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Compiled by ${col.compiler} • ${col.totalHadiths} Narrations',
                          style: AppTypography.bodySmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          col.description,
                          style: AppTypography.bodyMedium.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Explore Narrations',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primaryEmerald,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primaryEmerald),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ],
    );
  }

  Widget _buildFilteredHadithsView(
    AsyncValue<dynamic> allHadithsAsync,
    String query,
    String category,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    return allHadithsAsync.when(
      data: (hadiths) {
        final filtered = hadiths.where((h) {
          final matchesCategory = category == 'All' || h.category == category;
          final matchesQuery = query.isEmpty ||
              h.textTranslation.toLowerCase().contains(query) ||
              (h.textTranslationUrdu?.toLowerCase().contains(query) ?? false) ||
              h.textArabic.contains(query) ||
              (h.narrator?.toLowerCase().contains(query) ?? false) ||
              h.bookName.toLowerCase().contains(query) ||
              h.hadithNumber.contains(query);
          return matchesCategory && matchesQuery;
        }).toList();

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off_rounded, size: 48, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(height: 12),
                Text(
                  'No hadiths match your search or filter.',
                  style: AppTypography.titleMedium.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: AppDimensions.paddingScreen,
          itemCount: filtered.length,
          separatorBuilder: (_, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final hadith = filtered[index];
            return AppCard(
              onTap: () => context.push('/hadith/detail/${hadith.collectionKey}/${hadith.hadithNumber}'),
              padding: AppDimensions.paddingCard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                          '${hadith.collectionKey.toUpperCase()} #${hadith.hadithNumber}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primaryEmerald,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (hadith.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentTeal.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            hadith.category!,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.accentTeal,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hadith.textArabic,
                    textDirection: TextDirection.rtl,
                    style: AppTypography.quranTextSmall.copyWith(fontSize: 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hadith.textTranslation,
                    style: AppTypography.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        hadith.narrator != null ? 'Narrated by: ${hadith.narrator}' : hadith.bookName,
                        style: AppTypography.labelSmall.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'View Full Analysis',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primaryEmerald,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 14, color: AppColors.primaryEmerald),
                        ],
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
    );
  }
}

