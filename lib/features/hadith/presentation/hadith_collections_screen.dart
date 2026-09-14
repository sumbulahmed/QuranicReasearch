import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/providers/app_providers.dart';

class HadithCollectionsScreen extends ConsumerWidget {
  const HadithCollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(hadithCollectionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hadith Compendiums',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
          ),
        ),
      ),
      body: AppBackground(
        child: Column(
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            col.nameEnglish,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
                            ),
                          ),
                          Text(
                            col.nameArabic,
                            style: AppTypography.quranTextSmall.copyWith(
                              fontSize: 20,
                              color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Compiled by ${col.compiler} • ${col.totalHadiths} Narrations',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        col.description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Explore Compendium',
                            style: AppTypography.labelMedium.copyWith(
                              color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
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
          error: (err, _) => Center(child: Text('Error loading collections: $err')),
        ),
      ),
    );
  }
}
