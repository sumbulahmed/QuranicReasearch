import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_background.dart';
import '../providers/sunnah_providers.dart';
import '../widgets/sunnah_card.dart';

class SunnahListScreen extends ConsumerStatefulWidget {
  final String category;

  const SunnahListScreen({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<SunnahListScreen> createState() => _SunnahListScreenState();
}

class _SunnahListScreenState extends ConsumerState<SunnahListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _localQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isBookmarks = widget.category == 'Bookmarks';
    final bookmarkedIds = ref.watch(sunnahBookmarksProvider);

    final listAsync = ref.watch(sunnahListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
              ),
            ),
            Text(
              isBookmarks ? 'Saved Sunnah Practices' : 'Category Compendium',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
      body: AppBackground(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Filter in ${widget.category}...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _localQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _localQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurface : AppColors.parchmentCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onChanged: (val) => setState(() => _localQuery = val.trim().toLowerCase()),
              ),
            ),

            // List View
            Expanded(
              child: listAsync.when(
                data: (practices) {
                  var filtered = practices;
                  if (isBookmarks) {
                    filtered = filtered.where((p) => bookmarkedIds.contains(p.id)).toList();
                  } else if (widget.category != 'All') {
                    filtered = filtered
                        .where((p) =>
                            p.category.toLowerCase() == widget.category.toLowerCase() ||
                            p.categoryArabic == widget.category)
                        .toList();
                  }

                  if (_localQuery.isNotEmpty) {
                    filtered = filtered
                        .where((p) =>
                            p.title.toLowerCase().contains(_localQuery) ||
                            p.arabicTitle.contains(_localQuery) ||
                            p.description.toLowerCase().contains(_localQuery))
                        .toList();
                  }

                  if (filtered.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isBookmarks
                                  ? Icons.bookmark_border_rounded
                                  : Icons.menu_book_outlined,
                              size: 48,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isBookmarks
                                  ? 'No bookmarked Sunnahs yet.\nTap the bookmark icon on any Sunnah to save it here.'
                                  : 'No Sunnah practices found in this category.',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMedium.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: AppDimensions.paddingScreen,
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return SunnahCard(practice: filtered[index]);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error loading Sunnahs: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
