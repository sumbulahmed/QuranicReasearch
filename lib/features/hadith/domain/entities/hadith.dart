enum HadithGrading {
  sahih,
  hasan,
  daif,
  unknown;

  static HadithGrading fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'sahih':
        return HadithGrading.sahih;
      case 'hasan':
        return HadithGrading.hasan;
      case 'daif':
        return HadithGrading.daif;
      default:
        return HadithGrading.unknown;
    }
  }

  String get label {
    switch (this) {
      case HadithGrading.sahih:
        return 'Sahih (Authentic)';
      case HadithGrading.hasan:
        return 'Hasan (Good)';
      case HadithGrading.daif:
        return 'Da\'if (Weak)';
      case HadithGrading.unknown:
        return 'Not Graded';
    }
  }
}

class Hadith {
  final String collectionKey; // e.g. "bukhari", "muslim"
  final String hadithNumber;
  final String bookName;
  final int? chapterNumber;
  final String textArabic;
  final String textTranslation;
  final HadithGrading grading;
  final String? narrator;
  final bool hasScientificConnections;
  final List<String> scientificConnectionIds;

  const Hadith({
    required this.collectionKey,
    required this.hadithNumber,
    required this.bookName,
    this.chapterNumber,
    required this.textArabic,
    required this.textTranslation,
    this.grading = HadithGrading.sahih,
    this.narrator,
    this.hasScientificConnections = false,
    this.scientificConnectionIds = const [],
  });

  factory Hadith.fromMap(Map<String, dynamic> map) {
    return Hadith(
      collectionKey: map['collection_key'] as String,
      hadithNumber: map['hadith_number'] as String,
      bookName: map['book_name'] as String? ?? '',
      chapterNumber: map['chapter_number'] as int?,
      textArabic: map['text_arabic'] as String,
      textTranslation: map['text_translation'] as String,
      grading: HadithGrading.fromString(map['grading'] as String?),
      narrator: map['narrator'] as String?,
      hasScientificConnections: map['has_scientific_connections'] as bool? ?? false,
      scientificConnectionIds: (map['scientific_connection_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'collection_key': collectionKey,
      'hadith_number': hadithNumber,
      'book_name': bookName,
      'chapter_number': chapterNumber,
      'text_arabic': textArabic,
      'text_translation': textTranslation,
      'grading': grading.name,
      'narrator': narrator,
      'has_scientific_connections': hasScientificConnections,
      'scientific_connection_ids': scientificConnectionIds,
    };
  }
}
