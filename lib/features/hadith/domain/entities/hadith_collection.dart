class HadithCollection {
  final String key; // 'bukhari', 'muslim', etc.
  final String nameEnglish;
  final String nameArabic;
  final String compiler;
  final int totalHadiths;
  final String description;

  const HadithCollection({
    required this.key,
    required this.nameEnglish,
    required this.nameArabic,
    required this.compiler,
    required this.totalHadiths,
    required this.description,
  });

  factory HadithCollection.fromMap(Map<String, dynamic> map) {
    return HadithCollection(
      key: map['key'] as String,
      nameEnglish: map['name_english'] as String,
      nameArabic: map['name_arabic'] as String,
      compiler: map['compiler'] as String,
      totalHadiths: map['total_hadiths'] as int? ?? 0,
      description: map['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'name_english': nameEnglish,
      'name_arabic': nameArabic,
      'compiler': compiler,
      'total_hadiths': totalHadiths,
      'description': description,
    };
  }
}
