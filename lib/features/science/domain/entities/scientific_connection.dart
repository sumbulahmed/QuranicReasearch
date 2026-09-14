import '../../../../core/models/evidence_level.dart';

enum IslamicTextType {
  quran,
  hadith;

  static IslamicTextType fromString(String? value) {
    return value?.toLowerCase() == 'hadith' ? IslamicTextType.hadith : IslamicTextType.quran;
  }
}

class ScientificConnection {
  final String id;
  final String topicId;
  final IslamicTextType textType;
  final int? surahNumber;
  final int? ayahNumber;
  final String? ayahKey; // e.g. "23:14"
  final String? hadithCollection;
  final String? hadithNumber;
  final EvidenceLevel evidenceLevel;
  final String headline;
  final String explanation;
  final String classicalTafseer;
  final String scientificConsensus;
  final String scholarlyCaveats;
  final List<String> paperIds;
  final bool verifiedByScholars;

  const ScientificConnection({
    required this.id,
    required this.topicId,
    required this.textType,
    this.surahNumber,
    this.ayahNumber,
    this.ayahKey,
    this.hadithCollection,
    this.hadithNumber,
    required this.evidenceLevel,
    required this.headline,
    required this.explanation,
    required this.classicalTafseer,
    required this.scientificConsensus,
    required this.scholarlyCaveats,
    required this.paperIds,
    this.verifiedByScholars = true,
  });

  factory ScientificConnection.fromMap(String id, Map<String, dynamic> data) {
    return ScientificConnection(
      id: id,
      topicId: data['topic_id'] as String? ?? '',
      textType: IslamicTextType.fromString(data['text_type'] as String?),
      surahNumber: data['surah_number'] as int?,
      ayahNumber: data['ayah_number'] as int?,
      ayahKey: data['ayah_key'] as String?,
      hadithCollection: data['hadith_collection'] as String?,
      hadithNumber: data['hadith_number'] as String?,
      evidenceLevel: EvidenceLevel.fromString(data['evidence_level'] as String?),
      headline: data['headline'] as String? ?? '',
      explanation: data['explanation'] as String? ?? '',
      classicalTafseer: data['classical_tafseer'] as String? ?? '',
      scientificConsensus: data['scientific_consensus'] as String? ?? '',
      scholarlyCaveats: data['scholarly_caveats'] as String? ?? '',
      paperIds: (data['paper_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      verifiedByScholars: data['verified_by_scholars'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topic_id': topicId,
      'text_type': textType.name,
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'ayah_key': ayahKey,
      'hadith_collection': hadithCollection,
      'hadith_number': hadithNumber,
      'evidence_level': evidenceLevel.name,
      'headline': headline,
      'explanation': explanation,
      'classical_tafseer': classicalTafseer,
      'scientific_consensus': scientificConsensus,
      'scholarly_caveats': scholarlyCaveats,
      'paper_ids': paperIds,
      'verified_by_scholars': verifiedByScholars,
    };
  }
}
