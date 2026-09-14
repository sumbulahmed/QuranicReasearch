class Surah {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String nameTranslation;
  final String revelationType; // 'Meccan' or 'Medinan'
  final int numberOfAyahs;

  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
  });

  factory Surah.fromMap(Map<String, dynamic> map) {
    return Surah(
      number: map['number'] as int,
      nameArabic: map['name_arabic'] as String,
      nameEnglish: map['name_english'] as String,
      nameTranslation: map['name_translation'] as String,
      revelationType: map['revelation_type'] as String? ?? 'Meccan',
      numberOfAyahs: map['number_of_ayahs'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'name_arabic': nameArabic,
      'name_english': nameEnglish,
      'name_translation': nameTranslation,
      'revelation_type': revelationType,
      'number_of_ayahs': numberOfAyahs,
    };
  }
}
