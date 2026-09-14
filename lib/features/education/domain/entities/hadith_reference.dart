class HadithReference {
  final String id;
  final String collection;
  final String hadithNumber;
  final String book;
  final String textArabic;
  final String textEnglish;
  final String commentary;
  final String? scholarlyNuance;
  final String grade;

  const HadithReference({
    required this.id,
    required this.collection,
    required this.hadithNumber,
    required this.book,
    required this.textArabic,
    required this.textEnglish,
    required this.commentary,
    this.scholarlyNuance,
    this.grade = 'Sahih',
  });
}
