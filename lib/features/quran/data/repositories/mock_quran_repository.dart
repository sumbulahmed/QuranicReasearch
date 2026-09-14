import '../../domain/entities/surah.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/repositories/quran_repository.dart';

class MockQuranRepository implements QuranRepository {
  static final List<Surah> _surahs = [
    const Surah(
      number: 1,
      nameArabic: 'الفاتحة',
      nameEnglish: 'Al-Fatihah',
      nameTranslation: 'The Opening',
      revelationType: 'Meccan',
      numberOfAyahs: 7,
    ),
    const Surah(
      number: 23,
      nameArabic: 'المؤمنون',
      nameEnglish: 'Al-Mu\'minun',
      nameTranslation: 'The Believers',
      revelationType: 'Meccan',
      numberOfAyahs: 118,
    ),
    const Surah(
      number: 24,
      nameArabic: 'النور',
      nameEnglish: 'An-Nur',
      nameTranslation: 'The Light',
      revelationType: 'Medinan',
      numberOfAyahs: 64,
    ),
    const Surah(
      number: 32,
      nameArabic: 'السجدة',
      nameEnglish: 'As-Sajdah',
      nameTranslation: 'The Prostration',
      revelationType: 'Meccan',
      numberOfAyahs: 30,
    ),
    const Surah(
      number: 51,
      nameArabic: 'الذاريات',
      nameEnglish: 'Adh-Dhariyat',
      nameTranslation: 'The Winnowing Winds',
      revelationType: 'Meccan',
      numberOfAyahs: 60,
    ),
    const Surah(
      number: 96,
      nameArabic: 'العلق',
      nameEnglish: 'Al-\'Alaq',
      nameTranslation: 'The Clinging Clot',
      revelationType: 'Meccan',
      numberOfAyahs: 19,
    ),
  ];

  static final Map<int, List<Ayah>> _ayahs = {
    1: [
      const Ayah(
        surahNumber: 1,
        ayahNumber: 1,
        textArabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        textTranslation: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
        tafseer: 'The opening invocation seeking blessing in all endeavors.',
      ),
      const Ayah(
        surahNumber: 1,
        ayahNumber: 2,
        textArabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        textTranslation: '[All] praise is [due] to Allah, Lord of the worlds.',
        tafseer: 'Recognition that all praise belongs solely to the Creator and Sustainer of the cosmos.',
      ),
    ],
    23: [
      const Ayah(
        surahNumber: 23,
        ayahNumber: 12,
        textArabic: 'وَلَقَدْ خَلَقْنَا الْإِنسَانَ مِن سُلَالَةٍ مِّن طِينٍ',
        textTranslation: 'And certainly did We create man from an extract of clay.',
        tafseer: 'Referring to the elemental origin of Adam and the mineral constituents of organic life.',
        hasScientificConnections: false,
      ),
      const Ayah(
        surahNumber: 23,
        ayahNumber: 13,
        textArabic: 'ثُمَّ جَعَلْنَاهُ نُطْفَةً فِي قَرَارٍ مَّكِينٍ',
        textTranslation: 'Then We placed him as a sperm-drop in a firm lodging.',
        tafseer: 'Referring to the fertilized zygote residing securely within the maternal womb.',
        hasScientificConnections: false,
      ),
      const Ayah(
        surahNumber: 23,
        ayahNumber: 14,
        textArabic:
            'ثُمَّ خَلَقْنَا النُّطْفَةَ عَلَقَةً فَخَلَقْنَا الْعَلَقَةَ مُضْغَةً فَخَلَقْنَا الْمُضْغَةَ عِظَامًا فَكَسَوْنَا الْعِظَامَ لَحْمًا ثُمَّ أَنشَأْنَاهُ خَلْقًا آخَرَ ۚ فَتَبَارَكَ اللَّهُ أَحْسَنُ الْخَالِقِينَ',
        textTranslation:
            'Then We made the sperm-drop into a clinging clot, and We made the clot into a lump [of flesh], and We made [from] the lump, bones, and We covered the bones with flesh; then We developed him into another creation. So blessed is Allah, the best of creators.',
        tafseer:
            'Ibn Kathir outlines the progression: from a fertilized fluid to a suspended clinging structure (\'Alaqah), to a small piece of flesh shaped like a chewed morsel (Mudghah), followed by skeletal formation and muscular envelopment.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_embryology_23_14'],
      ),
    ],
    24: [
      const Ayah(
        surahNumber: 24,
        ayahNumber: 40,
        textArabic:
            'أَوْ كَظُلُمَاتٍ فِي بَحْرٍ لُّجِّيٍّ يَغْشَاهُ مَوْجٌ مِّن فَوْقِهِ مَوْجٌ مِّن فَوْقِهِ سَحَابٌ ۚ ظُلُمَاتٌ بَعْضُهَا فَوْقَ بَعْضٍ إِذَا أَخْرَجَ يَدَهُ لَمْ يَكَدْ يَرَاهَا ۗ وَمَن لَّمْ يَجْعَلِ اللَّهُ لَهُ نُورًا فَمَا لَهُ مِن نُّورٍ',
        textTranslation:
            'Or [they are] like darknesses within an unfathomable sea which is covered by waves, upon which are waves, over which are clouds - darknesses, some of them upon others. When one puts out his hand [therein], he can hardly see it. And he to whom Allah has not granted light - for him there is no light.',
        tafseer:
            'A vivid parable of spiritual confusion. The imagery describes layered oceanic depths where internal waves and surface waves compound total photic extinction.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_oceanography_24_40'],
      ),
    ],
    96: [
      const Ayah(
        surahNumber: 96,
        ayahNumber: 15,
        textArabic: 'كَلَّا لَئِن لَّمْ يَنتَهِ لَنَسْفَعًا بِالنَّاصِيَةِ',
        textTranslation: 'No! If he does not desist, We will surely drag him by the forelock -',
      ),
      const Ayah(
        surahNumber: 96,
        ayahNumber: 16,
        textArabic: 'نَاصِيَةٍ كَاذِبَةٍ خَاطِئَةٍ',
        textTranslation: 'A lying, sinning forelock.',
        tafseer:
            'Classical commentators remark on the attribution of lying and sinning directly to the forehead (Nāsiyah), which modern neuroanatomy associates with prefrontal executive control.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_neuro_96_16'],
      ),
    ],
    32: [
      const Ayah(
        surahNumber: 32,
        ayahNumber: 5,
        textArabic:
            'يُدَبِّرُ الْأَمْرَ مِنَ السَّمَاءِ إِلَى الْأَرْضِ ثُمَّ يَعْرُجُ إِلَيْهِ فِي يَوْمٍ كَانَ مِقْدَارُهُ أَلْفَ سَنَةٍ مِّمَّا تَعُدُّونَ',
        textTranslation:
            'He arranges [each] matter from the heaven to the earth; then it will ascend to Him in a Day, the extent of which is a thousand years of those which you count.',
        tafseer:
            'Classical scholars interpret this as the cosmic descent and ascent of divine command and angelic administration across earthly human time.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_myth_speed_of_light'],
      ),
    ],
  };

  @override
  Future<List<Surah>> getAllSurahs() async {
    return _surahs;
  }

  @override
  Future<Surah?> getSurahByNumber(int surahNumber) async {
    try {
      return _surahs.firstWhere((s) => s.number == surahNumber);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Ayah>> getAyahsForSurah(int surahNumber) async {
    return _ayahs[surahNumber] ?? [];
  }

  @override
  Future<Ayah?> getAyah(int surahNumber, int ayahNumber) async {
    final list = _ayahs[surahNumber];
    if (list == null) return null;
    try {
      return list.firstWhere((a) => a.ayahNumber == ayahNumber);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Ayah>> searchAyahs(String query) async {
    final lower = query.toLowerCase();
    final results = <Ayah>[];
    for (final list in _ayahs.values) {
      for (final ayah in list) {
        if (ayah.textTranslation.toLowerCase().contains(lower) ||
            ayah.textArabic.contains(query) ||
            (ayah.tafseer?.toLowerCase().contains(lower) ?? false)) {
          results.add(ayah);
        }
      }
    }
    return results;
  }
}
