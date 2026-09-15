class HadithReference {
  final String id;
  final String collection;
  final String book;
  final String hadithNumber;
  final String arabicText;
  final String englishTranslation;
  final String authenticity;
  final String? commentary;
  final String? scholarlyNuance;
  final String? sourceUrl;

  const HadithReference({
    required this.id,
    required this.collection,
    required this.book,
    required this.hadithNumber,
    required this.arabicText,
    required this.englishTranslation,
    this.authenticity = 'Sahih',
    this.commentary,
    this.scholarlyNuance,
    this.sourceUrl,
  });
}
