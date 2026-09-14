import '../../../../core/models/evidence_level.dart';

class ScientificTopic {
  final String id;
  final String title;
  final String category;
  final String summary;
  final String description;
  final String islamicPerspective;
  final String scientificExplanation;
  final String whatResearchSays;
  final EvidenceLevel evidenceLevel;
  final String iconName;
  final String? coverImageUrl;
  final Map<String, int> evidenceDistribution;
  final int connectionsCount;
  final List<String> tags;
  final List<String> relatedAyahKeys;
  final List<String> relatedHadithIds;
  final List<String> researchPaperIds;
  final List<String> relatedTopicIds;
  final bool featured;

  const ScientificTopic({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    String? description,
    this.islamicPerspective = '',
    this.scientificExplanation = '',
    this.whatResearchSays = '',
    this.evidenceLevel = EvidenceLevel.possible,
    this.iconName = 'science',
    this.coverImageUrl,
    required this.evidenceDistribution,
    required this.connectionsCount,
    required this.tags,
    this.relatedAyahKeys = const [],
    this.relatedHadithIds = const [],
    this.researchPaperIds = const [],
    this.relatedTopicIds = const [],
    this.featured = false,
  }) : description = description ?? summary;

  factory ScientificTopic.fromMap(String id, Map<String, dynamic> data) {
    final summaryStr = data['summary'] as String? ?? data['description'] as String? ?? '';
    return ScientificTopic(
      id: id,
      title: data['title'] as String? ?? '',
      category: data['category'] as String? ?? '',
      summary: summaryStr,
      description: data['description'] as String? ?? summaryStr,
      islamicPerspective: data['islamic_perspective'] as String? ?? '',
      scientificExplanation: data['scientific_explanation'] as String? ?? '',
      whatResearchSays: data['what_research_says'] as String? ?? '',
      evidenceLevel: EvidenceLevel.fromString(data['evidence_level'] as String?),
      iconName: data['icon_name'] as String? ?? 'science',
      coverImageUrl: data['cover_image_url'] as String?,
      evidenceDistribution: (data['evidence_distribution'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toInt()),
          ) ??
          {},
      connectionsCount: data['connections_count'] as int? ?? 0,
      tags: (data['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      relatedAyahKeys: (data['related_ayah_keys'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      relatedHadithIds: (data['related_hadith_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      researchPaperIds: (data['research_paper_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      relatedTopicIds: (data['related_topic_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      featured: data['featured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'summary': summary,
      'description': description,
      'islamic_perspective': islamicPerspective,
      'scientific_explanation': scientificExplanation,
      'what_research_says': whatResearchSays,
      'evidence_level': evidenceLevel.name,
      'icon_name': iconName,
      'cover_image_url': coverImageUrl,
      'evidence_distribution': evidenceDistribution,
      'connections_count': connectionsCount,
      'tags': tags,
      'related_ayah_keys': relatedAyahKeys,
      'related_hadith_ids': relatedHadithIds,
      'research_paper_ids': researchPaperIds,
      'related_topic_ids': relatedTopicIds,
      'featured': featured,
    };
  }
}
