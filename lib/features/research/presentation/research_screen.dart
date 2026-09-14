import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/research_citation_card.dart';
import '../../../core/providers/app_providers.dart';
import '../../user_library/domain/entities/bookmark.dart';

class ResearchScreen extends ConsumerStatefulWidget {
  const ResearchScreen({super.key});

  @override
  ConsumerState<ResearchScreen> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends ConsumerState<ResearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedField = 'All';

  final List<String> _fields = [
    'All',
    'Embryology & Anatomy',
    'Oceanography & Marine Physics',
    'Circadian Neurobiology',
    'Molecular Autophagy',
    'Phytochemistry & Pharmacology',
    'Prefrontal Neuropsychology',
    'Botany & Soil Ecology',
    'Geology & Geophysics',
    'Astrophysics & Cosmology',
    'Theoretical Physics',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final papersAsync = ref.watch(allResearchPapersProvider);
    final bookmarks = ref.watch(bookmarksProvider).value ?? [];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Research Literature',
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
          // Academic Disclaimer Notice
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: isDark ? const Color(0xFF1B2621) : const Color(0xFFEAF5F0),
            child: Row(
              children: [
                const Icon(Icons.science_rounded, size: 16, color: AppColors.primaryEmerald),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Demo Database: Peer-reviewed citations illustrating empirical literature integration.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primaryEmerald,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search by author, journal, keyword, or title...',
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

          // Scientific Field Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: _fields.map((field) {
                final isSelected = _selectedField == field;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(field),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedField = field),
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

          const SizedBox(height: 6),

          // Papers List
          Expanded(
            child: papersAsync.when(
              data: (papers) {
                final query = _searchController.text.trim().toLowerCase();
                final filtered = papers.where((p) {
                  final matchesField = _selectedField == 'All' ||
                      p.field.toLowerCase().contains(_selectedField.toLowerCase());
                  final matchesQuery = query.isEmpty ||
                      p.title.toLowerCase().contains(query) ||
                      p.journal.toLowerCase().contains(query) ||
                      (p.doi?.toLowerCase().contains(query) ?? false) ||
                      p.abstractSummary.toLowerCase().contains(query) ||
                      p.authors.any((a) => a.toLowerCase().contains(query));
                  return matchesField && matchesQuery;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.library_books_outlined, size: 48, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text(
                          'No research papers match your search.',
                          style: AppTypography.titleMedium.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                  itemCount: filtered.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final paper = filtered[index];
                    final bookmarkId = 'bm_paper_${paper.id}';
                    final isBookmarked = bookmarks.any((b) => b.id == bookmarkId);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ResearchCitationCard(paper: paper),
                        const SizedBox(height: 6),
                        // Action bar under paper
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                final apaCitation =
                                    '${paper.authors.join(", ")} (${paper.publicationYear}). ${paper.title}. ${paper.journal}${paper.doi != null ? ", doi:${paper.doi}" : ""}.';
                                Clipboard.setData(ClipboardData(text: apaCitation));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('APA Citation copied to clipboard!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy_rounded, size: 14),
                              label: const Text('Copy Citation (APA)'),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                color: isBookmarked ? AppColors.accentGold : null,
                                size: 20,
                              ),
                              onPressed: () {
                                final bm = Bookmark(
                                  id: bookmarkId,
                                  itemType: LibraryItemType.researchPaper,
                                  itemId: paper.id,
                                  title: paper.title,
                                  subtitle: '${paper.journal} (${paper.publicationYear})',
                                  createdAt: DateTime.now(),
                                );
                                ref.read(bookmarksProvider.notifier).toggleBookmark(bm);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isBookmarked
                                          ? 'Removed from bookmarks'
                                          : 'Bookmarked research paper',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              tooltip: 'Bookmark',
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error loading papers: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
