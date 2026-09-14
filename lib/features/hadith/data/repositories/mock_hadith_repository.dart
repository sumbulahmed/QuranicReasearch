import '../../domain/entities/hadith_collection.dart';
import '../../domain/entities/hadith.dart';
import '../../domain/repositories/hadith_repository.dart';

class MockHadithRepository implements HadithRepository {
  static final List<HadithCollection> _collections = [
    const HadithCollection(
      key: 'bukhari',
      nameEnglish: 'Sahih al-Bukhari',
      nameArabic: 'صحيح البخاري',
      compiler: 'Imam Muhammad al-Bukhari',
      totalHadiths: 7563,
      description: 'The most authentic book of Hadith literature in Islamic tradition.',
    ),
    const HadithCollection(
      key: 'muslim',
      nameEnglish: 'Sahih Muslim',
      nameArabic: 'صحيح مسلم',
      compiler: 'Imam Muslim ibn al-Hajjaj',
      totalHadiths: 7500,
      description: 'The second most authentic collection of Sahih Hadith, renowned for thematic rigor.',
    ),
  ];

  static final List<Hadith> _hadiths = [
    const Hadith(
      collectionKey: 'bukhari',
      hadithNumber: '3208',
      bookName: 'Book of Beginning of Creation',
      chapterNumber: 6,
      textArabic:
          'إِنَّ أَحَدَكُمْ يُجْمَعُ خَلْقُهُ فِي بَطْنِ أُمِّهِ أَرْبَعِينَ يَوْمًا، ثُمَّ يَكُونُ عَلَقَةً مِثْلَ ذَلِكَ، ثُمَّ يَكُونُ مُضْغَةً مِثْلَ ذَلِكَ...',
      textTranslation:
          'The creation of each of you is compiled in his mother\'s belly for forty days, then he becomes a clot for a similar period, then he becomes a chewed lump of flesh for a similar period...',
      grading: HadithGrading.sahih,
      narrator: 'Abdullah ibn Mas\'ud',
      hasScientificConnections: true,
      scientificConnectionIds: ['conn_embryology_23_14'],
    ),
    const Hadith(
      collectionKey: 'bukhari',
      hadithNumber: '5688',
      bookName: 'Book of Medicine',
      chapterNumber: 7,
      textArabic:
          'مَا أَنْزَلَ اللَّهُ دَاءً إِلَّا أَنْزَلَ لَهُ شِفَاءً',
      textTranslation:
          'There is no disease that Allah has created, except that He also has created its treatment.',
      grading: HadithGrading.sahih,
      narrator: 'Abu Hurairah',
      hasScientificConnections: false,
    ),
    const Hadith(
      collectionKey: 'muslim',
      hadithNumber: '2645',
      bookName: 'Book of Destiny (Qadr)',
      chapterNumber: 1,
      textArabic:
          'إِذَا مَرَّ بِالنُّطْفَةِ ثِنْتَانِ وَأَرْبَعُونَ لَيْلَةً، بَعَثَ اللَّهُ إِلَيْهَا مَلَكًا، فَصَوَّرَهَا، وَخَلَقَ سَمْعَهَا وَبَصَرَهَا وَجِلْدَهَا وَلَحْمَهَا وَعِظَامَهَا...',
      textTranslation:
          'When forty-two nights have passed over the Nutfah (drop), Allah sends an angel to it, who shapes it and makes its hearing, sight, skin, flesh, and bones...',
      grading: HadithGrading.sahih,
      narrator: 'Hudhaifah ibn Asid',
      hasScientificConnections: true,
      scientificConnectionIds: ['conn_embryology_23_14'],
    ),
  ];

  @override
  Future<List<HadithCollection>> getCollections() async {
    return _collections;
  }

  @override
  Future<HadithCollection?> getCollectionByKey(String key) async {
    try {
      return _collections.firstWhere((c) => c.key == key);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Hadith>> getHadithsForCollection(String collectionKey) async {
    return _hadiths.where((h) => h.collectionKey == collectionKey).toList();
  }

  @override
  Future<Hadith?> getHadith(String collectionKey, String hadithNumber) async {
    try {
      return _hadiths.firstWhere(
          (h) => h.collectionKey == collectionKey && h.hadithNumber == hadithNumber);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Hadith>> searchHadiths(String query) async {
    final lower = query.toLowerCase();
    return _hadiths
        .where((h) =>
            h.textTranslation.toLowerCase().contains(lower) ||
            h.textArabic.contains(query) ||
            h.hadithNumber.contains(query))
        .toList();
  }
}
