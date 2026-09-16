import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/section_header.dart';
import '../providers/sunnah_providers.dart';
import '../widgets/featured_sunnah_card.dart';
import '../widgets/sunnah_card.dart';
import '../widgets/sunnah_category_card.dart';

class SunnahHomeScreen extends ConsumerStatefulWidget {
  const SunnahHomeScreen({super.key});

  @override
  ConsumerState<SunnahHomeScreen> createState() => _SunnahHomeScreenState();
}

class _SunnahHomeScreenState extends ConsumerState<SunnahHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final featuredAsync = ref.watch(featuredSunnahProvider);
    final categoriesAsync = ref.watch(sunnahCategoriesProvider);
    final sunnahsAsync = ref.watch(sunnahListProvider);
    final selectedCategory = ref.watch(sunnahSelectedCategoryProvider);
    final isChildMode = ref.watch(sunnahChildModeProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sunnah',
              style: AppTypography.appTitle.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isChildMode
                  ? 'Child-Friendly Mode • Fun & Gentle Learning'
                  : 'Learn, practice and understand the beautiful way of the Prophet ﷺ.',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          // Child Mode Switch
          Tooltip(
            message: isChildMode ? 'Switch to Standard Mode' : 'Switch to Child Mode',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.child_care_rounded,
                  size: 18,
                  color: isChildMode
                      ? AppColors.accentGoldLight
                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
                Switch(
                  value: isChildMode,
                  activeThumbColor: AppColors.accentGoldLight,
                  onChanged: (val) {
                    ref.read(sunnahChildModeProvider.notifier).state = val;
                  },
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmarks_outlined),
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
            tooltip: 'Bookmarked Sunnahs',
            onPressed: () => context.push('/sunnah/category/Bookmarks'),
          ),
        ],
      ),
      body: AppBackground(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(featuredSunnahProvider);
            ref.invalidate(sunnahCategoriesProvider);
            ref.invalidate(sunnahListProvider);
          },
          child: ListView(
            padding: AppDimensions.paddingScreen,
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Sunnahs (e.g. drinking, sleep, right hand)...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(sunnahSearchQueryProvider.notifier).state = '';
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (val) {
                  ref.read(sunnahSearchQueryProvider.notifier).state = val;
                },
              ),
              const SizedBox(height: 18),

              // Featured Sunnah Card
              featuredAsync.when(
                data: (featured) => FeaturedSunnahCard(practice: featured),
                loading: () => const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, _) => const SizedBox(),
              ),
              const SizedBox(height: 22),

              // Categories Header & Grid
              SectionHeader(
                title: 'Sunnah Categories',
                subtitle: '12 Comprehensive Spheres of Prophetic Guidance',
              ),
              const SizedBox(height: 10),

              categoriesAsync.when(
                data: (categories) => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.3,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = selectedCategory == cat.name;
                    return SunnahCategoryCard(
                      category: cat,
                      isSelected: isSelected,
                      onTap: () {
                        ref.read(sunnahSelectedCategoryProvider.notifier).state =
                            selectedCategory == cat.name ? 'All' : cat.name;
                      },
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error loading categories: $err')),
              ),
              const SizedBox(height: 24),

              // Filter Section Header with Action
              SectionHeader(
                title: selectedCategory == 'All' ? 'Curated Sunnahs' : selectedCategory,
                subtitle: 'Authentic Practices & Evidence Reviews',
                trailing: selectedCategory != 'All'
                    ? TextButton(
                        onPressed: () {
                          ref.read(sunnahSelectedCategoryProvider.notifier).state = 'All';
                        },
                        child: const Text('Show All'),
                      )
                    : null,
              ),
              const SizedBox(height: 10),

              // Sunnah Practices List
              sunnahsAsync.when(
                data: (practices) {
                  if (practices.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 36),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No Sunnah practices found matching your criteria.',
                              style: AppTypography.titleSmall.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: practices.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return SunnahCard(practice: practices[index]);
                    },
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
