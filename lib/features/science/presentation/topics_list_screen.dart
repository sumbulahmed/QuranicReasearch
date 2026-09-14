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

class TopicsListScreen extends ConsumerStatefulWidget {
  const TopicsListScreen({super.key});

  @override
  ConsumerState<TopicsListScreen> createState() => _TopicsListScreenState();
}

class _TopicsListScreenState extends ConsumerState<TopicsListScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Medicine & Developmental Biology',
    'Earth Sciences & Physical Oceanography',
    'Neurobiology & Cognitive Psychology',
    'Astrophysics & Cosmology',
    'Scientific Myth-Busters',
  ];

  @override
  Widget build(BuildContext context) {
    final topicsAsync = ref.watch(scientificTopicsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scientific Research Layer',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cat == 'All' ? 'All Domains' : cat.split('&').first.trim()),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: AppColors.primaryEmerald.withValues(alpha: 0.15),
                    checkmarkColor: AppColors.primaryEmerald,
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

          // Topics List
          Expanded(
            child: topicsAsync.when(
              data: (topics) {
                final filtered = _selectedCategory == 'All'
                    ? topics
                    : topics.where((t) => t.category == _selectedCategory).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No topics found in this category.'));
                }

                return ListView.separated(
                  padding: AppDimensions.paddingScreen,
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final topic = filtered[index];
                    return _buildTopicCard(context, topic, isDark);
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

  Widget _buildTopicCard(BuildContext context, dynamic topic, bool isDark) {
    EvidenceLevel representativeLevel = EvidenceLevel.possible;
    if (topic.id == 'debunked_speed_of_light') {
      representativeLevel = EvidenceLevel.unsupported;
    } else if (topic.id == 'embryology' || topic.id == 'oceanography') {
      representativeLevel = EvidenceLevel.strong;
    } else {
      representativeLevel = EvidenceLevel.emerging;
    }

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
              EvidenceBadge(level: representativeLevel, compact: true),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            topic.summary,
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                    '${topic.connectionsCount} Linked Texts',
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
                    'Review Research & Papers',
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
