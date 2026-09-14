class ScientificTopic {
  final String id;
  final String title;
  final String category;
  final String summary;
  final String iconName;
  final String? coverImageUrl;
  final Map<String, int> evidenceDistribution;
  final int connectionsCount;
  final List<String> tags;
  final bool featured;

  const ScientificTopic({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    this.iconName = 'science',
    this.coverImageUrl,
    required this.evidenceDistribution,
    required this.connectionsCount,
    required this.tags,
    this.featured = false,
  });

  factory ScientificTopic.fromMap(String id, Map<String, dynamic> data) {
    return ScientificTopic(
      id: id,
      title: data['title'] as String? ?? '',
      category: data['category'] as String? ?? '',
      summary: data['summary'] as String? ?? '',
      iconName: data['icon_name'] as String? ?? 'science',
      coverImageUrl: data['cover_image_url'] as String?,
      evidenceDistribution: (data['evidence_distribution'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toInt()),
          ) ??
          {},
      connectionsCount: data['connections_count'] as int? ?? 0,
      tags: (data['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      featured: data['featured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'summary': summary,
      'icon_name': iconName,
      'cover_image_url': coverImageUrl,
      'evidence_distribution': evidenceDistribution,
      'connections_count': connectionsCount,
      'tags': tags,
      'featured': featured,
    };
  }
}
