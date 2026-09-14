import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/providers/app_providers.dart';
import '../domain/entities/bookmark.dart';

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  String _selectedTab = 'All';

  @override
  Widget build(BuildContext context) {
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Bookmarks',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ['All', 'Quran', 'Hadith', 'Topics', 'Research'].map((tab) {
                final isSelected = _selectedTab == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(tab),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedTab = tab),
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

          // Bookmarks List
          Expanded(
            child: bookmarksAsync.when(
              data: (bookmarks) {
                final filtered = bookmarks.where((bm) {
                  if (_selectedTab == 'Quran') {
                    return bm.itemType == LibraryItemType.ayah || bm.itemType == LibraryItemType.surah;
                  } else if (_selectedTab == 'Hadith') {
                    return bm.itemType == LibraryItemType.hadith;
                  } else if (_selectedTab == 'Topics') {
                    return bm.itemType == LibraryItemType.scientificTopic || bm.itemType == LibraryItemType.topic;
                  } else if (_selectedTab == 'Research') {
                    return bm.itemType == LibraryItemType.researchPaper;
                  }
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border_rounded,
                            size: 64,
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'No bookmarks in $_selectedTab',
                            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Bookmark Ayahs, Hadiths, or Scientific Topics while studying for instant offline access.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 8,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => context.push('/quran'),
                                icon: const Icon(Icons.menu_book_rounded, size: 16),
                                label: const Text('Read Quran'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => context.push('/science'),
                                icon: const Icon(Icons.science_rounded, size: 16),
                                label: const Text('Explore Topics'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: AppDimensions.paddingScreen,
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final bm = filtered[index];
                    return AppCard(
                      onTap: () => _navigateToBookmark(context, bm),
                      padding: AppDimensions.paddingCard,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryEmerald.withValues(alpha: isDark ? 0.2 : 0.12),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                            ),
                            child: Icon(
                              _getBookmarkIcon(bm.itemType),
                              color: AppColors.primaryEmerald,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.accentTeal.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _getBookmarkTypeLabel(bm.itemType),
                                        style: AppTypography.labelSmall.copyWith(
                                          color: AppColors.accentTeal,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        bm.title,
                                        style: AppTypography.titleMedium.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  bm.subtitle,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.bookmark_remove_rounded, color: Colors.redAccent, size: 20),
                            onPressed: () {
                              ref.read(bookmarksProvider.notifier).toggleBookmark(bm);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Removed "${bm.title}" from bookmarks'),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      ref.read(bookmarksProvider.notifier).toggleBookmark(bm);
                                    },
                                  ),
                                ),
                              );
                            },
                            tooltip: 'Remove',
                          ),
                        ],
                      ),
                    );
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

  IconData _getBookmarkIcon(LibraryItemType type) {
    switch (type) {
      case LibraryItemType.ayah:
      case LibraryItemType.surah:
        return Icons.menu_book_rounded;
      case LibraryItemType.hadith:
        return Icons.library_books_rounded;
      case LibraryItemType.scientificTopic:
      case LibraryItemType.topic:
        return Icons.science_rounded;
      case LibraryItemType.researchPaper:
        return Icons.article_rounded;
    }
  }

  String _getBookmarkTypeLabel(LibraryItemType type) {
    switch (type) {
      case LibraryItemType.ayah:
        return 'AYAH';
      case LibraryItemType.surah:
        return 'SURAH';
      case LibraryItemType.hadith:
        return 'HADITH';
      case LibraryItemType.scientificTopic:
      case LibraryItemType.topic:
        return 'TOPIC';
      case LibraryItemType.researchPaper:
        return 'PAPER';
    }
  }

  void _navigateToBookmark(BuildContext context, Bookmark bm) {
    if (bm.itemType == LibraryItemType.ayah) {
      final parts = bm.itemId.split(':');
      if (parts.length == 2) {
        final surah = int.tryParse(parts[0]) ?? 1;
        final ayah = int.tryParse(parts[1]) ?? 1;
        context.push('/quran/ayah/$surah/$ayah');
      } else if (parts.isNotEmpty) {
        context.push('/quran/surah/${parts[0]}');
      }
    } else if (bm.itemType == LibraryItemType.surah) {
      context.push('/quran/surah/${bm.itemId}');
    } else if (bm.itemType == LibraryItemType.hadith) {
      final parts = bm.itemId.split('_');
      if (parts.length >= 2) {
        context.push('/hadith/detail/${parts[0]}/${parts[1]}');
      } else {
        context.push('/hadith');
      }
    } else if (bm.itemType == LibraryItemType.topic || bm.itemType == LibraryItemType.scientificTopic) {
      context.push('/science/topic/${bm.itemId}');
    } else if (bm.itemType == LibraryItemType.researchPaper) {
      context.push('/research');
    }
  }
}

