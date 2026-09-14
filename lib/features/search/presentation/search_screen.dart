import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/research_citation_card.dart';
import '../../../core/providers/app_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _filter = 'All';

  final List<String> _quickSuggestions = [
    'Embryology',
    'Deep Sea',
    'Prefrontal Cortex',
    'Black Seed',
    'Intermittent Fasting',
    'Mountains',
    'Expanding Universe',
    'Sleep',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final topicsAsync = ref.watch(scientificTopicsProvider);
    final papersAsync = ref.watch(allResearchPapersProvider);
    final quranRepo = ref.watch(quranRepositoryProvider);
    final hadithRepo = ref.watch(hadithRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Unified Knowledge Search',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // Search Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Quran, Hadith, Topics & Papers...',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryEmerald),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              onChanged: (val) => setState(() => _query = val.trim()),
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: ['All', 'Quran', 'Hadith', 'Science', 'Papers'].map((f) {
                final isSelected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(f),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _filter = f),
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
          const Divider(),

          // Search Results
          Expanded(
            child: _query.isEmpty
                ? _buildEmptyState(context)
                : FutureBuilder<Map<String, dynamic>>(
                    future: _performSearch(
                      quranRepo,
                      hadithRepo,
                      topicsAsync.value ?? [],
                      papersAsync.value ?? [],
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: Text('No results found.'));
                      }

                      final results = snapshot.data!;
                      final ayahs = results['ayahs'] as List<dynamic>;
                      final hadiths = results['hadiths'] as List<dynamic>;
                      final topics = results['topics'] as List<dynamic>;
                      final papers = results['papers'] as List<dynamic>;

                      final total = ayahs.length + hadiths.length + topics.length + papers.length;
                      if (total == 0) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off_rounded, size: 54, color: theme.colorScheme.onSurfaceVariant),
                              const SizedBox(height: 12),
                              Text(
                                'No matches found for "$_query"',
                                style: AppTypography.titleMedium.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Try alternative terms like "water", "embryo", "sleep", or "heart"',
                                style: AppTypography.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView(
                        padding: AppDimensions.paddingScreen,
                        children: [
                          if ((_filter == 'All' || _filter == 'Science') && topics.isNotEmpty) ...[
                            _buildResultSectionHeader('Scientific Topics (${topics.length})'),
                            ...topics.map((t) => _buildTopicResult(context, t)),
                            const SizedBox(height: 16),
                          ],
                          if ((_filter == 'All' || _filter == 'Quran') && ayahs.isNotEmpty) ...[
                            _buildResultSectionHeader('Noble Qur\'an Verses (${ayahs.length})'),
                            ...ayahs.map((a) => _buildAyahResult(context, a)),
                            const SizedBox(height: 16),
                          ],
                          if ((_filter == 'All' || _filter == 'Hadith') && hadiths.isNotEmpty) ...[
                            _buildResultSectionHeader('Prophetic Hadiths (${hadiths.length})'),
                            ...hadiths.map((h) => _buildHadithResult(context, h)),
                            const SizedBox(height: 16),
                          ],
                          if ((_filter == 'All' || _filter == 'Papers') && papers.isNotEmpty) ...[
                            _buildResultSectionHeader('Research Literature (${papers.length})'),
                            ...papers.map((p) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ResearchCitationCard(paper: p),
                                )),
                            const SizedBox(height: 16),
                          ],
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _performSearch(
    dynamic quranRepo,
    dynamic hadithRepo,
    List<dynamic> topics,
    List<dynamic> papers,
  ) async {
    final lower = _query.toLowerCase();
    final matchedAyahs = await quranRepo.searchAyahs(_query);
    final matchedHadiths = await hadithRepo.searchHadiths(_query);
    final matchedTopics = topics
        .where((t) =>
            t.title.toLowerCase().contains(lower) ||
            t.summary.toLowerCase().contains(lower) ||
            (t.description?.toLowerCase().contains(lower) ?? false) ||
            t.category.toLowerCase().contains(lower))
        .toList();
    final matchedPapers = papers
        .where((p) =>
            p.title.toLowerCase().contains(lower) ||
            p.journal.toLowerCase().contains(lower) ||
            (p.doi?.toLowerCase().contains(lower) ?? false) ||
            (p.abstractSummary?.toLowerCase().contains(lower) ?? false) ||
            p.authors.any((a) => a.toString().toLowerCase().contains(lower)))
        .toList();

    return {
      'ayahs': matchedAyahs,
      'hadiths': matchedHadiths,
      'topics': matchedTopics,
      'papers': matchedPapers,
    };
  }

  Widget _buildEmptyState(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Icon(
            Icons.manage_search_rounded,
            size: 64,
            color: AppColors.primaryEmerald.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'Explore Across All Dimensions',
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Search verses, narrations, empirical topics, and academic citations.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Popular Research Topics',
              style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickSuggestions.map((suggestion) {
              return ActionChip(
                avatar: const Icon(Icons.trending_up_rounded, size: 14, color: AppColors.primaryEmerald),
                label: Text(suggestion),
                onPressed: () {
                  _searchController.text = suggestion;
                  setState(() {
                    _query = suggestion;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.primaryEmerald,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTopicResult(BuildContext context, dynamic topic) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AppCard(
        onTap: () => context.push('/science/topic/${topic.id}'),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.science_rounded, color: AppColors.primaryEmerald),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title,
                    style: AppTypography.titleMedium.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    topic.category,
                    style: AppTypography.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildAyahResult(BuildContext context, dynamic ayah) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AppCard(
        onTap: () => context.push('/quran/ayah/${ayah.surahNumber}/${ayah.ayahNumber}'),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ayah ${ayah.surahNumber}:${ayah.ayahNumber}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primaryEmerald,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (ayah.hasScientificConnections)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accentTeal.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Scientific Evidence',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.accentTeal,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              ayah.textTranslation,
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHadithResult(BuildContext context, dynamic hadith) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AppCard(
        onTap: () => context.push('/hadith/detail/${hadith.collectionKey}/${hadith.hadithNumber}'),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${hadith.collectionKey.toUpperCase()} #${hadith.hadithNumber}',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primaryEmerald,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hadith.textTranslation,
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

