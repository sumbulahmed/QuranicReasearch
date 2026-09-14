class ResearchPaper {
  final String id;
  final String title;
  final List<String> authors;
  final String journal;
  final int publicationYear;
  final String? doi;
  final String? sourceUrl;
  final String abstractSummary;
  final String methodology;
  final bool isPeerReviewed;

  const ResearchPaper({
    required this.id,
    required this.title,
    required this.authors,
    required this.journal,
    required this.publicationYear,
    this.doi,
    this.sourceUrl,
    required this.abstractSummary,
    required this.methodology,
    this.isPeerReviewed = true,
  });

  factory ResearchPaper.fromMap(String id, Map<String, dynamic> data) {
    return ResearchPaper(
      id: id,
      title: data['title'] as String? ?? '',
      authors: (data['authors'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      journal: data['journal'] as String? ?? '',
      publicationYear: data['publication_year'] as int? ?? 2020,
      doi: data['doi'] as String?,
      sourceUrl: data['source_url'] as String?,
      abstractSummary: data['abstract_summary'] as String? ?? '',
      methodology: data['methodology'] as String? ?? 'Empirical Study',
      isPeerReviewed: data['is_peer_reviewed'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'authors': authors,
      'journal': journal,
      'publication_year': publicationYear,
      'doi': doi,
      'source_url': sourceUrl,
      'abstract_summary': abstractSummary,
      'methodology': methodology,
      'is_peer_reviewed': isPeerReviewed,
    };
  }
}
