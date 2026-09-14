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

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topicsAsync = ref.watch(scientificTopicsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quran & Science',
              style: AppTypography.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              'Evidence-Based Islamic Research',
              style: AppTypography.bodySmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline_rounded),
            onPressed: () => context.push('/library/bookmarks'),
            tooltip: 'Bookmarks',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: ListView(
        padding: AppDimensions.paddingScreen,
        children: [
          // Concept Sequence Flow Banner
          _buildConceptSequenceBanner(context, isDark),
          const SizedBox(height: 24),

          // Section Header: Featured Research
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Curated Scientific Research',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/science'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Topics Carousel / List
          topicsAsync.when(
            data: (topics) {
              return Column(
                children: topics.map((topic) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildTopicCard(context, topic, isDark),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, _) => Text('Error loading topics: $err'),
          ),

          const SizedBox(height: 16),

          // Epistemological Principle Card
          _buildIntegrityPrincipleCard(context, isDark),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildConceptSequenceBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.primaryEmeraldDark, const Color(0xFF14241F)]
              : [AppColors.primaryEmerald, AppColors.primaryEmeraldLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryEmerald.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'RESEARCH PARADIGM',
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Islamic Text → Tafseer → Science → Peer-Reviewed Research',
            style: AppTypography.headlineLarge.copyWith(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Grounding modern scientific parallels strictly in classical commentary, peer-reviewed literature, and objective evidence levels.',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, dynamic topic, bool isDark) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceSubtle
                            : AppColors.lightSurfaceSubtle,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                      child: Text(
                        topic.category.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryEmeraldLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      topic.title,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Prominent Evidence Badge
              if (topic.id == 'debunked_speed_of_light')
                const EvidenceBadge(level: EvidenceLevel.unsupported, compact: true)
              else if (topic.id == 'embryology' || topic.id == 'oceanography')
                const EvidenceBadge(level: EvidenceLevel.strong, compact: true)
              else
                const EvidenceBadge(level: EvidenceLevel.emerging, compact: true),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            topic.summary,
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.link_rounded, size: 16, color: AppColors.accentTeal),
                  const SizedBox(width: 4),
                  Text(
                    '${topic.connectionsCount} Linked Texts',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentTeal,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Explore Evidence',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primaryEmerald,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: AppColors.primaryEmerald,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrityPrincipleCard(BuildContext context, bool isDark) {
    return AppCard(
      backgroundColor: isDark
          ? AppColors.darkSurfaceSubtle
          : const Color(0xFFF0FDF4),
      borderColor: AppColors.evidenceStrong.withValues(alpha: 0.3),
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: AppColors.evidenceStrong,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Scholarly & Scientific Integrity',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.evidenceStrong,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'We strictly refuse to force scientific theories onto verses. Science evolves by continuous falsification, while divine text conveys immutable wisdom. Only defensible, peer-reviewed, and consensus insights are cataloged.',
            style: AppTypography.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
