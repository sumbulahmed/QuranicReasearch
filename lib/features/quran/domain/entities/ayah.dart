class Ayah {
  final int surahNumber;
  final int ayahNumber;
  final String textArabic;
  final String textTranslation;
  final String? textTranslationUrdu;
  final String? tafseer;
  final bool hasScientificConnections;
  final List<String> scientificConnectionIds;

  const Ayah({
    required this.surahNumber,
    required this.ayahNumber,
    required this.textArabic,
    required this.textTranslation,
    this.textTranslationUrdu,
    this.tafseer,
    this.hasScientificConnections = false,
    this.scientificConnectionIds = const [],
  });

  String get ayahKey => '$surahNumber:$ayahNumber';

  factory Ayah.fromMap(Map<String, dynamic> map) {
    return Ayah(
      surahNumber: map['surah_number'] as int,
      ayahNumber: map['ayah_number'] as int,
      textArabic: map['text_arabic'] as String,
      textTranslation: map['text_translation'] as String,
      textTranslationUrdu: map['text_translation_urdu'] as String?,
      tafseer: map['tafseer'] as String?,
      hasScientificConnections: map['has_scientific_connections'] as bool? ?? false,
      scientificConnectionIds: (map['scientific_connection_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'text_arabic': textArabic,
      'text_translation': textTranslation,
      'text_translation_urdu': textTranslationUrdu,
      'tafseer': tafseer,
      'has_scientific_connections': hasScientificConnections,
      'scientific_connection_ids': scientificConnectionIds,
    };
  }
}
