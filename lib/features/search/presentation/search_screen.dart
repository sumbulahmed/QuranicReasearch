import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final topicsAsync = ref.watch(scientificTopicsProvider);
    final quranRepo = ref.watch(quranRepositoryProvider);
    final hadithRepo = ref.watch(hadithRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Unified Search',
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
                hintText: 'Search Quran, Hadith, or Science (e.g. embryo, ocean, waves)...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
              onChanged: (val) => setState(() => _query = val.trim()),
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: ['All', 'Quran', 'Hadith', 'Science'].map((f) {
                final isSelected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _filter = f),
                    selectedColor: AppColors.primaryEmerald.withValues(alpha: 0.15),
                    labelStyle: AppTypography.labelSmall.copyWith(
                      color: isSelected ? AppColors.primaryEmerald : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
                    future: _performSearch(quranRepo, hadithRepo, topicsAsync.value ?? []),
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

                      final total = ayahs.length + hadiths.length + topics.length;
                      if (total == 0) {
                        return Center(
                          child: Text(
                            'No matches found for "$_query"',
                            style: AppTypography.bodyMedium.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
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
                            _buildResultSectionHeader('Quranic Ayahs (${ayahs.length})'),
                            ...ayahs.map((a) => _buildAyahResult(context, a)),
                            const SizedBox(height: 16),
                          ],
                          if ((_filter == 'All' || _filter == 'Hadith') && hadiths.isNotEmpty) ...[
                            _buildResultSectionHeader('Hadiths (${hadiths.length})'),
                            ...hadiths.map((h) => _buildHadithResult(context, h)),
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
  ) async {
    final lower = _query.toLowerCase();
    final matchedAyahs = await quranRepo.searchAyahs(_query);
    final matchedHadiths = await hadithRepo.searchHadiths(_query);
    final matchedTopics = topics
        .where((t) =>
            t.title.toLowerCase().contains(lower) ||
            t.summary.toLowerCase().contains(lower) ||
            t.tags.any((tag) => tag.toString().toLowerCase().contains(lower)))
        .toList();

    return {
      'ayahs': matchedAyahs,
      'hadiths': matchedHadiths,
      'topics': matchedTopics,
    };
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.manage_search_rounded,
            size: 56,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 12),
          Text(
            'Explore Quran, Hadith & Science',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Try typing "embryo", "waves", "deep sea", or "light"',
            style: AppTypography.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
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
        onTap: () => context.push('/quran/surah/${ayah.surahNumber}'),
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
        onTap: () => context.push('/hadith/collection/${hadith.collectionKey}'),
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
