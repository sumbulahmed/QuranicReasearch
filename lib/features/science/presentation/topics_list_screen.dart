import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/evidence_level.dart';
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
          'Scientific Research',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: () => context.push('/research'),
            tooltip: 'Research Papers Library',
          ),
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search scientific topics, biology, astronomy...',
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

          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: _categories.map((catTuple) {
                final isSelected = _selectedCategory == catTuple.$1;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(catTuple.$2),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = catTuple.$1),
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
                  selectedColor: AppColors.primaryEmerald.withValues(alpha: 0.2),
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('Strong'),
                  selected: _selectedLevel == EvidenceLevel.strong,
                  onSelected: (_) => setState(() => _selectedLevel = _selectedLevel == EvidenceLevel.strong ? null : EvidenceLevel.strong),
                  selectedColor: AppColors.evidenceStrong.withValues(alpha: 0.2),
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('Emerging'),
                  selected: _selectedLevel == EvidenceLevel.emerging,
                  onSelected: (_) => setState(() => _selectedLevel = _selectedLevel == EvidenceLevel.emerging ? null : EvidenceLevel.emerging),
                  selectedColor: AppColors.evidenceEmerging.withValues(alpha: 0.2),
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('Possible'),
                  selected: _selectedLevel == EvidenceLevel.possible,
                  onSelected: (_) => setState(() => _selectedLevel = _selectedLevel == EvidenceLevel.possible ? null : EvidenceLevel.possible),
                  selectedColor: AppColors.evidencePossible.withValues(alpha: 0.2),
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('Myth-Buster'),
                  selected: _selectedLevel == EvidenceLevel.unsupported,
                  onSelected: (_) => setState(() => _selectedLevel = _selectedLevel == EvidenceLevel.unsupported ? null : EvidenceLevel.unsupported),
                  selectedColor: AppColors.evidenceUnsupported.withValues(alpha: 0.2),
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
                      t.description.toLowerCase().contains(query) ||
                      t.category.toLowerCase().contains(query);
                  return matchesCat && matchesLevel && matchesQuery;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.science_outlined, size: 48, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text('No topics match your criteria.', style: AppTypography.titleMedium.copyWith(color: theme.colorScheme.onSurfaceVariant)),
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
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
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
    final theme = Theme.of(context);
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
                    Text(
                      topic.category.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primaryEmeraldLight,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      topic.title,
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              EvidenceBadge(level: level, compact: true),
              const SizedBox(width: 4),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
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
          const SizedBox(height: 8),
          Text(
            topic.summary,
            style: AppTypography.bodyMedium.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.menu_book_rounded, size: 14, color: AppColors.accentTeal),
                  const SizedBox(width: 4),
                  Text(
                    '${topic.connectionsCount} Linked Verses & Hadith',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.accentTeal,
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
                      color: AppColors.primaryEmerald,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.primaryEmerald),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

