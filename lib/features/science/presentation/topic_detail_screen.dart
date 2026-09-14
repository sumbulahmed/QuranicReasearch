import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/evidence_badge.dart';
import '../../../core/widgets/research_citation_card.dart';
import '../../../core/providers/app_providers.dart';

class TopicDetailScreen extends ConsumerWidget {
  final String topicId;

  const TopicDetailScreen({
    super.key,
    required this.topicId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicAsync = ref.watch(topicDetailProvider(topicId));
    final connectionsAsync = ref.watch(topicConnectionsProvider(topicId));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: topicAsync.when(
          data: (topic) => Text(
            topic?.title ?? 'Topic Detail',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          loading: () => const Text('Loading...'),
          error: (err, stack) => const Text('Topic Detail'),
        ),
      ),
      body: topicAsync.when(
        data: (topic) {
          if (topic == null) {
            return const Center(child: Text('Topic not found.'));
          }

          return ListView(
            padding: AppDimensions.paddingScreen,
            children: [
              // Topic Header Card
              AppCard(
                padding: AppDimensions.paddingCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryEmerald.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                      child: Text(
                        topic.category,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primaryEmerald,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      topic.title,
                      style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      topic.summary,
                      style: AppTypography.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Evidence Distribution Bar
                    Text(
                      'Evidence Breakdown',
                      style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    _buildEvidenceDistribution(context, topic.evidenceDistribution),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section Header
              Text(
                'Linked Islamic Texts & Scientific Corroboration',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              // Connections List
              connectionsAsync.when(
                data: (connections) {
                  if (connections.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text('No connections documented yet.'),
                      ),
                    );
                  }

                  return Column(
                    children: connections.map((conn) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: _buildConnectionCard(context, ref, conn, isDark),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error loading connections: $err'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildEvidenceDistribution(BuildContext context, Map<String, int> dist) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        _buildMiniEvidenceTag('Strong', dist['strong'] ?? 0, AppColors.evidenceStrong),
        _buildMiniEvidenceTag('Emerging', dist['emerging'] ?? 0, AppColors.evidenceEmerging),
        _buildMiniEvidenceTag('Possible', dist['possible'] ?? 0, AppColors.evidencePossible),
        _buildMiniEvidenceTag('Unsupported', dist['unsupported'] ?? 0, AppColors.evidenceUnsupported),
      ],
    );
  }

  Widget _buildMiniEvidenceTag(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $count',
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(BuildContext context, WidgetRef ref, dynamic conn, bool isDark) {
    final theme = Theme.of(context);
    final papersAsync = ref.watch(researchPapersProvider(conn.paperIds as List<String>));

    return AppCard(
      padding: AppDimensions.paddingCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Anchor Badge (Ayah or Hadith) & Evidence Level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentTeal.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Text(
                  conn.textType.name == 'quran'
                      ? 'Surah ${conn.ayahKey}'
                      : '${conn.hadithCollection} #${conn.hadithNumber}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accentTeal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              EvidenceBadge(level: conn.evidenceLevel, compact: true),
            ],
          ),
          const SizedBox(height: 12),

          // Headline
          Text(
            conn.headline,
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          // Step 1: Classical Tafseer
          _buildInfoSubsection(
            context,
            '1. Classical Commentary (Tafseer)',
            conn.classicalTafseer,
            Icons.menu_book_rounded,
            AppColors.accentTeal,
            isDark,
          ),
          const SizedBox(height: 10),

          // Step 2: Scientific Perspective
          _buildInfoSubsection(
            context,
            '2. Scientific Perspective & Analysis',
            conn.explanation,
            Icons.science_rounded,
            AppColors.primaryEmerald,
            isDark,
          ),
          const SizedBox(height: 10),

          // Step 3: Scientific Consensus Status
          _buildInfoSubsection(
            context,
            '3. Consensus & Empirical Status',
            conn.scientificConsensus,
            Icons.verified_rounded,
            AppColors.evidenceStrong,
            isDark,
          ),
          const SizedBox(height: 10),

          // Step 4: Caveats
          _buildInfoSubsection(
            context,
            '4. Scholarly Caveats & Boundaries',
            conn.scholarlyCaveats,
            Icons.warning_amber_rounded,
            AppColors.evidenceEmerging,
            isDark,
          ),
          const SizedBox(height: 16),

          // Step 5: Research Papers
          Text(
            'Cited Peer-Reviewed Papers',
            style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),

          papersAsync.when(
            data: (papers) {
              if (papers.isEmpty) {
                return Text(
                  'No academic papers indexed for this connection.',
                  style: AppTypography.bodySmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                );
              }

              return Column(
                children: papers.map((p) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ResearchCitationCard(
                      title: p.title,
                      authors: p.authors,
                      journal: p.journal,
                      publicationYear: p.publicationYear,
                      doi: p.doi,
                      url: p.sourceUrl,
                      abstractSummary: p.abstractSummary,
                      isPeerReviewed: p.isPeerReviewed,
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error: $err'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSubsection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: AppTypography.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
