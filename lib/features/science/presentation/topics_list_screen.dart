import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/evidence_level.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/evidence_badge.dart';
import '../../../core/providers/app_providers.dart';
import '../../user_library/domain/entities/bookmark.dart';

class TopicsListScreen extends ConsumerStatefulWidget {
  const TopicsListScreen({super.key});

  @override
  ConsumerState<TopicsListScreen> createState() => _TopicsListScreenState();
}

class _TopicsListScreenState extends ConsumerState<TopicsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  EvidenceLevel? _selectedLevel;

  final List<(String, String)> _categories = [
    ('All', 'All Topics'),
    ('Medicine & Developmental Biology', '🧬 Embryology & Medicine'),
    ('Earth Sciences & Physical Oceanography', '💧 Water & Oceans'),
    ('Sleep & Circadian Biology', '😴 Sleep & Rest'),
    ('Metabolic Science & Autophagy', '🧘 Fasting & Metabolism'),
    ('Nutrition & Prophetic Dietetics', '🍎 Nutrition & Diet'),
    ('Neurobiology & Cognitive Psychology', '🧠 Psychology & Mind'),
    ('Environmental Science & Ecology', '🌱 Ecology & Earth'),
    ('Astrophysics & Cosmology', '🌌 Cosmology & Stars'),
    ('Geology & Geophysics', '⛰️ Mountains & Geology'),
    ('Scientific Myth-Busters', '⚖️ Myth-Busters'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topicsAsync = ref.watch(scientificTopicsProvider);
    final bookmarks = ref.watch(bookmarksProvider).value ?? [];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scientific Research Layer',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_outlined),
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
            onPressed: () => context.push('/research'),
            tooltip: 'Research Papers Library',
          ),
          IconButton(
            icon: const Icon(Icons.bookmarks_outlined),
            color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
            onPressed: () => context.push('/library/bookmarks'),
            tooltip: 'Bookmarks',
          ),
        ],
      ),
      body: AppBackground(
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search scientific topics, biology, astronomy...',
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

            // Category Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: _categories.map((catTuple) {
                  final isSelected = _selectedCategory == catTuple.$1;
                  final activeColor = isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(catTuple.$2),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = catTuple.$1),
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
                    ),
                  );
                }).toList(),
              ),
            ),

            // Evidence Level Sub-Filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All Levels'),
                    selected: _selectedLevel == null,
                    onSelected: (_) => setState(() => _selectedLevel = null),
                    selectedColor: isDark ? AppColors.primaryMaroonLight.withValues(alpha: 0.3) : AppColors.primaryMaroon.withValues(alpha: 0.15),
                    backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                    side: BorderSide(
                      color: _selectedLevel == null ? AppColors.primaryMaroon : (isDark ? AppColors.darkBorder : AppColors.parchmentBorder),
                      width: 0.8,
                    ),
                    labelStyle: AppTypography.labelSmall.copyWith(
                      color: _selectedLevel == null
                          ? (isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon)
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      fontWeight: _selectedLevel == null ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: const Text('Strong'),
                    selected: _selectedLevel == EvidenceLevel.strong,
                    onSelected: (_) => setState(() => _selectedLevel = _selectedLevel == EvidenceLevel.strong ? null : EvidenceLevel.strong),
                    selectedColor: AppColors.evidenceStrong.withValues(alpha: 0.2),
                    backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                    side: BorderSide(
                      color: _selectedLevel == EvidenceLevel.strong ? AppColors.evidenceStrong : (isDark ? AppColors.darkBorder : AppColors.parchmentBorder),
                      width: 0.8,
                    ),
                    labelStyle: AppTypography.labelSmall.copyWith(
                      color: _selectedLevel == EvidenceLevel.strong
                          ? AppColors.evidenceStrong
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      fontWeight: _selectedLevel == EvidenceLevel.strong ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: const Text('Emerging'),
                    selected: _selectedLevel == EvidenceLevel.emerging,
                    onSelected: (_) => setState(() => _selectedLevel = _selectedLevel == EvidenceLevel.emerging ? null : EvidenceLevel.emerging),
                    selectedColor: AppColors.evidenceEmerging.withValues(alpha: 0.2),
                    backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                    side: BorderSide(
                      color: _selectedLevel == EvidenceLevel.emerging ? AppColors.evidenceEmerging : (isDark ? AppColors.darkBorder : AppColors.parchmentBorder),
                      width: 0.8,
                    ),
                    labelStyle: AppTypography.labelSmall.copyWith(
                      color: _selectedLevel == EvidenceLevel.emerging
                          ? AppColors.evidenceEmerging
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      fontWeight: _selectedLevel == EvidenceLevel.emerging ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: const Text('Possible'),
                    selected: _selectedLevel == EvidenceLevel.possible,
                    onSelected: (_) => setState(() => _selectedLevel = _selectedLevel == EvidenceLevel.possible ? null : EvidenceLevel.possible),
                    selectedColor: AppColors.evidencePossible.withValues(alpha: 0.2),
                    backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                    side: BorderSide(
                      color: _selectedLevel == EvidenceLevel.possible ? AppColors.evidencePossible : (isDark ? AppColors.darkBorder : AppColors.parchmentBorder),
                      width: 0.8,
                    ),
                    labelStyle: AppTypography.labelSmall.copyWith(
                      color: _selectedLevel == EvidenceLevel.possible
                          ? AppColors.evidencePossible
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      fontWeight: _selectedLevel == EvidenceLevel.possible ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: const Text('Myth-Buster'),
                    selected: _selectedLevel == EvidenceLevel.unsupported,
                    onSelected: (_) => setState(() => _selectedLevel = _selectedLevel == EvidenceLevel.unsupported ? null : EvidenceLevel.unsupported),
                    selectedColor: AppColors.evidenceUnsupported.withValues(alpha: 0.2),
                    backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                    side: BorderSide(
                      color: _selectedLevel == EvidenceLevel.unsupported ? AppColors.evidenceUnsupported : (isDark ? AppColors.darkBorder : AppColors.parchmentBorder),
                      width: 0.8,
                    ),
                    labelStyle: AppTypography.labelSmall.copyWith(
                      color: _selectedLevel == EvidenceLevel.unsupported
                          ? AppColors.evidenceUnsupported
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      fontWeight: _selectedLevel == EvidenceLevel.unsupported ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Topics List
            Expanded(
              child: topicsAsync.when(
                data: (topics) {
                  final query = _searchController.text.trim().toLowerCase();
                  final filtered = topics.where((t) {
                    final matchesCat = _selectedCategory == 'All' || t.category == _selectedCategory;
                    final matchesLevel = _selectedLevel == null || t.evidenceLevel == _selectedLevel;
                    final matchesQuery = query.isEmpty ||
                        t.title.toLowerCase().contains(query) ||
                        t.summary.toLowerCase().contains(query) ||
                        (t.description?.toLowerCase().contains(query) ?? false) ||
                        t.category.toLowerCase().contains(query);
                    return matchesCat && matchesLevel && matchesQuery;
                  }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.science_outlined,
                            size: 48,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No topics match your inquiry criteria.',
                            style: AppTypography.titleMedium.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final topic = filtered[index];
                      final bookmarkId = 'bm_topic_${topic.id}';
                      final isBookmarked = bookmarks.any((b) => b.id == bookmarkId);
                      return _buildTopicCard(context, ref, topic, isDark, isBookmarked);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error loading topics: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(
    BuildContext context,
    WidgetRef ref,
    dynamic topic,
    bool isDark,
    bool isBookmarked,
  ) {
    final EvidenceLevel level = topic.evidenceLevel ?? EvidenceLevel.possible;

    return AppCard(
      onTap: () => context.push('/science/topic/${topic.id}'),
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.parchmentSubtle,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.parchmentBorder,
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        topic.category.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          color: isDark ? AppColors.accentGoldLight : AppColors.primaryMaroon,
                          fontWeight: FontWeight.w700,
                          fontSize: 9.5,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      topic.title,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.5,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextHeading,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              EvidenceBadge(level: level, compact: true),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isBookmarked ? AppColors.accentGold : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  size: 20,
                ),
                onPressed: () {
                  final bm = Bookmark(
                    id: 'bm_topic_${topic.id}',
                    itemType: LibraryItemType.scientificTopic,
                    itemId: topic.id,
                    title: topic.title,
                    subtitle: topic.category,
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
                tooltip: 'Bookmark Topic',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            topic.summary,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 14,
                    color: isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${topic.connectionsCount} Linked Verses & Hadith',
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark ? AppColors.accentGoldLight : AppColors.accentSepia,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Explore Evidence',
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 12,
                    color: isDark ? AppColors.darkTextHeading : AppColors.primaryMaroon,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
