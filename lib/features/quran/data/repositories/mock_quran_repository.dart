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
      number: 2,
      nameArabic: 'البقرة',
      nameEnglish: 'Al-Baqarah',
      nameTranslation: 'The Cow',
      revelationType: 'Medinan',
      numberOfAyahs: 286,
    ),
    const Surah(
      number: 21,
      nameArabic: 'الأنبياء',
      nameEnglish: 'Al-Anbya',
      nameTranslation: 'The Prophets',
      revelationType: 'Meccan',
      numberOfAyahs: 112,
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
      number: 30,
      nameArabic: 'الروم',
      nameEnglish: 'Ar-Rum',
      nameTranslation: 'The Romans',
      revelationType: 'Meccan',
      numberOfAyahs: 60,
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
      number: 55,
      nameArabic: 'الرحمن',
      nameEnglish: 'Ar-Rahman',
      nameTranslation: 'The Beneficent',
      revelationType: 'Medinan',
      numberOfAyahs: 78,
    ),
    const Surah(
      number: 78,
      nameArabic: 'النبأ',
      nameEnglish: 'An-Naba',
      nameTranslation: 'The Tidings',
      revelationType: 'Meccan',
      numberOfAyahs: 40,
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
        textTranslationUrdu: 'اللہ کے نام سے جو رحمان و رحیم ہے۔',
        tafseer: 'The opening invocation seeking divine blessing in all noble human endeavors.',
      ),
      const Ayah(
        surahNumber: 1,
        ayahNumber: 2,
        textArabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        textTranslation: '[All] praise is [due] to Allah, Lord of the worlds.',
        textTranslationUrdu: 'سب تعریفیں اللہ ہی کے لیے ہیں جو تمام جہانوں کا رب ہے۔',
        tafseer: 'Universal affirmation that all existential praise belongs solely to the Creator and Sustainer of the cosmos.',
      ),
      const Ayah(
        surahNumber: 1,
        ayahNumber: 3,
        textArabic: 'الرَّحْمَٰنِ الرَّحِيمِ',
        textTranslation: 'The Entirely Merciful, the Especially Merciful,',
        textTranslationUrdu: 'بڑا مہربان، نہایت رحم فرمانے والا ہے۔',
        tafseer: 'Signifying both cosmic encompassing grace (Rahman) and targeted covenantal mercy (Rahim).',
      ),
      const Ayah(
        surahNumber: 1,
        ayahNumber: 4,
        textArabic: 'مَالِكِ يَوْمِ الدِّينِ',
        textTranslation: 'Sovereign of the Day of Recompense.',
        textTranslationUrdu: 'روزِ جزا کا مالک ہے۔',
        tafseer: 'Emphasis on cosmic accountability and the ultimate moral ordering of existence.',
      ),
    ],
    2: [
      const Ayah(
        surahNumber: 2,
        ayahNumber: 183,
        textArabic:
            'يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِن قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ',
        textTranslation:
            'O you who have believed, decreed upon you is fasting as it was decreed upon those before you that you may become righteous.',
        textTranslationUrdu:
            'اے ایمان والو! تم پر روزے فرض کیے گئے ہیں جس طرح تم سے پہلے لوگوں پر فرض کیے گئے تھے تاکہ تم پرہیزگار بنو۔',
        tafseer:
            'Fasting instills self-discipline (Taqwa), curbing visceral appetite to strengthen spiritual awareness.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_fasting_autophagy'],
      ),
      const Ayah(
        surahNumber: 2,
        ayahNumber: 184,
        textArabic:
            'وَعَلَى الَّذِينَ يُطِيقُونَهُ فِدْيَةٌ طَعَامُ مِسْكِينٍ ۖ فَمَن تَطَوَّعَ خَيْرًا فَهُوَ خَيْرٌ لَّهُ ۚ وَأَن تَصُومُوا خَيْرٌ لَّكُمْ ۖ إِن كُنتُمْ تَعْلَمُونَ',
        textTranslation:
            'And upon those who are able [to fast, but with hardship] - a ransom [as substitute] of feeding a poor person. But to fast is better for you, if you only knew.',
        textTranslationUrdu:
            'اور جو لوگ اس کی طاقت رکھتے ہوں وہ فدیہ میں ایک مسکین کو کھانا دیں، اور اگر تم روزہ رکھو تو تمہارے لیے بہتر ہے اگر تم جانتے ہو۔',
        tafseer:
            'Reiterates the physiological and spiritual superiority of fasting over dispensations when physical health permits.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_fasting_autophagy'],
      ),
      const Ayah(
        surahNumber: 2,
        ayahNumber: 164,
        textArabic:
            'إِنَّ فِي خَلْقِ السَّمَاوَاتِ وَالْأَرْضِ وَاخْتِلَافِ اللَّيْلِ وَالنَّهَارِ وَالْفُلْكِ الَّتِي تَجْرِي فِي الْبَحْرِ بِمَا يَنفَعُ النَّاسَ وَمَا أَنزَلَ اللَّهُ مِنَ السَّمَاءِ مِن مَّاءٍ فَأَحْيَا بِهِ الْأَرْضَ بَعْدَ مَوْتِهَا...',
        textTranslation:
            'Indeed, in the creation of the heavens and earth, and the alternation of the night and the day, and the [great] ships which sail through the sea with that which benefits people, and what Allah has sent down from the heavens of rain, giving life thereby to the earth after its lifelessness...',
        textTranslationUrdu:
            'بے شک آسمانوں اور زمین کی پیدائش، رات اور دن کے باری باری آنے میں، اور ان کشتیوں میں جو سمندر میں لوگوں کے نفع کی چیزیں لے کر چلتی ہیں، اور اس پانی میں جسے اللہ نے آسمان سے اتارا پھر اس سے زمین کو زندہ کیا...',
        tafseer:
            'Points humanity toward empirical observation of ecological balance, hydrological cycles, and oceanic equilibrium as divine signs.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_water_cycle', 'conn_environment_mizan'],
      ),
    ],
    21: [
      const Ayah(
        surahNumber: 21,
        ayahNumber: 30,
        textArabic:
            'أَوَلَمْ يَرَ الَّذِينَ كَفَرُوا أَنَّ السَّمَاوَاتِ وَالْأَرْضَ كَانَتَا رَتْقًا فَفَتَقْنَاهُمَا ۖ وَجَعَلْنَا مِنَ الْمَاءِ كُلَّ شَيْءٍ حَيٍّ ۖ أَفَلَا يُؤْمِنُونَ',
        textTranslation:
            'Have those who disbelieved not considered that the heavens and the earth were a joined entity, and then We separated them and made from water every living thing? Then will they not believe?',
        textTranslationUrdu:
            'کیا کافروں نے نہیں دیکھا کہ آسمان اور زمین آپس میں ملے ہوئے تھے پھر ہم نے انہیں جدا کیا اور پانی سے ہر جاندار چیز بنائی؟ تو کیا وہ ایمان نہیں لاتے؟',
        tafseer:
            'Classical exegetes like Ibn Kathir and Al-Tabari explain "ratqan" as joined in primordial cohesion, separated by divine order, and water established as the essential matrix of cellular vitality.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_creation_singularity', 'conn_water_vitality'],
      ),
      const Ayah(
        surahNumber: 21,
        ayahNumber: 33,
        textArabic:
            'وَهُوَ الَّذِي خَلَقَ اللَّيْلَ وَالنَّهَارَ وَالشَّمْسَ وَالْقَمَرَ ۖ كُلٌّ فِي فَلَكٍ يَسْبَحُونَ',
        textTranslation:
            'And it is He who created the night and the day and the sun and the moon; all [heavenly bodies] in an orbit are swimming.',
        textTranslationUrdu:
            'اور وہی ہے جس نے رات اور دن اور سورج اور چاند کو پیدا کیا، سب اپنے اپنے مدار میں تیر رہے ہیں۔',
        tafseer:
            'Arabic "falak" designates a curved celestial track or orbital pathway, emphasizing perpetual gravitational motion.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_astronomy_orbits'],
      ),
    ],
    23: [
      const Ayah(
        surahNumber: 23,
        ayahNumber: 12,
        textArabic: 'وَلَقَدْ خَلَقْنَا الْإِنسَانَ مِن سُلَالَةٍ مِّن طِينٍ',
        textTranslation: 'And certainly did We create man from an extract of clay.',
        textTranslationUrdu: 'اور ہم نے انسان کو مٹی کے نچوڑ سے پیدا کیا۔',
        tafseer: 'Referring to the primordial mineral origins of biological organisms and soil chemistry.',
        hasScientificConnections: false,
      ),
      const Ayah(
        surahNumber: 23,
        ayahNumber: 13,
        textArabic: 'ثُمَّ جَعَلْنَاهُ نُطْفَةً فِي قَرَارٍ مَّكِينٍ',
        textTranslation: 'Then We placed him as a sperm-drop in a firm lodging.',
        textTranslationUrdu: 'پھر ہم نے اسے ایک محفوظ ٹھکانے میں نطفہ بنا کر رکھا۔',
        tafseer: 'Referring to the zygote implanted within the protective uterine cavity.',
        hasScientificConnections: false,
      ),
      const Ayah(
        surahNumber: 23,
        ayahNumber: 14,
        textArabic:
            'ثُمَّ خَلَقْنَا النُّطْفَةَ عَلَقَةً فَخَلَقْنَا الْعَلَقَةَ مُضْغَةً فَخَلَقْنَا الْمُضْغَةَ عِظَامًا فَكَسَوْنَا الْعِظَامَ لَحْمًا ثُمَّ أَنشَأْنَاهُ خَلْقًا آخَرَ ۚ فَتَبَارَكَ اللَّهُ أَحْسَنُ الْخَالِقِينَ',
        textTranslation:
            'Then We made the sperm-drop into a clinging clot, and We made the clot into a lump [of flesh], and We made [from] the lump, bones, and We covered the bones with flesh; then We developed him into another creation. So blessed is Allah, the best of creators.',
        textTranslationUrdu:
            'پھر ہم نے نطفہ کو جما ہوا خون بنایا، پھر جمے ہوئے خون کو گوشت کا لوتھڑا بنایا، پھر لوتھڑے کی ہڈیاں بنائیں، پھر ہڈیوں پر گوشت چڑھایا، پھر ہم نے اسے ایک نئی صورت میں پیدا کیا۔ پس بڑی برکت والا ہے اللہ جو سب سے بہترین پیدا کرنے والا ہے۔',
        tafseer:
            'Detailed sequential morphogenetic progression: suspended clinging structure (Alaqah), indented chewed-like tissue (Mudghah), cartilage/skeletal staging, and muscular enveloping.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_embryology_23_14'],
      ),
    ],
    24: [
      const Ayah(
        surahNumber: 24,
        ayahNumber: 40,
        textArabic:
            'أَوْ كَظُلُمَاتٍ فِي بَحْرٍ لُّجِّيٍّ يَغْشَاهُ مَوْجٌ مِّن فَوْقِهِ مَوْجٌ مِّن فَوْقِهِ سَحَابٌ ۚ ظُلُمَاتٌ بَعْضُهَا فَوْقَ بَعْضٍ إِذَا أَخْرَجَ يَدَهُ لَمْ يَكَدْ يَرَاهَا...',
        textTranslation:
            'Or [they are] like darknesses within an unfathomable sea which is covered by waves, upon which are waves, over which are clouds - darknesses, some of them upon others. When one puts out his hand [therein], he can hardly see it...',
        textTranslationUrdu:
            'یا جیسے گہرے سمندر کے اندھیرے، جس کے اوپر موج چھا رہی ہو، اس کے اوپر ایک اور موج ہو، اس کے اوپر بادل ہو، اندھیرے پر اندھیرے ہوں، جب وہ اپنا ہاتھ نکالے تو اسے دیکھ بھی نہ پائے...',
        tafseer:
            'Vivid physical imagery of deep marine bathymetry, subsurface internal waves at density pycnoclines, and photic attenuation in the aphotic zone.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_oceanography_internal_waves'],
      ),
    ],
    30: [
      const Ayah(
        surahNumber: 30,
        ayahNumber: 23,
        textArabic:
            'وَمِنْ آيَاتِهِ مَنَامُكُم بِاللَّيْلِ وَالنَّهَارِ وَابْتِغَاؤُكُم مِّن فَضْلِهِ ۚ إِنَّ فِي ذَٰلِكَ لَآيَاتٍ لِّقَوْمٍ يَسْمَعُونَ',
        textTranslation:
            'And of His signs is your sleep by night and day and your seeking of His bounty. Indeed in that are signs for a people who listen.',
        textTranslationUrdu:
            'اور اس کی نشانیوں میں سے تمہارا رات اور دن میں سونا اور اس کا فضل تلاش کرنا ہے، یقیناً اس میں سننے والی قوم کے لیے نشانیاں ہیں۔',
        tafseer:
            'Identifies sleep as a biological marvel and restorative requirement sustaining neurological resilience and cognitive health.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_sleep_circadian'],
      ),
    ],
    32: [
      const Ayah(
        surahNumber: 32,
        ayahNumber: 5,
        textArabic:
            'يُدَبِّرُ الْأَمْرَ مِنَ السَّمَاءِ إِلَى الْأَرْضِ ثُمَّ يَعْرُجُ إِلَيْهِ فِي يَوْمٍ كَانَ مِقْدَارُهُ أَلْفَ سَنَةٍ مِّمَّا تَعُدُّونَ',
        textTranslation:
            'He regulates all affairs from heavens to the earth; then it ascends to Him in a Day the extent of which is a thousand years of those which you count.',
        textTranslationUrdu:
            'وہ آسمان سے زمین تک کے امور کا انتظام کرتا ہے، پھر وہ معاملہ اس کی طرف چڑھے گا ایک ایسے دن میں جس کی مقدار تمہارے شمار کے مطابق ایک ہزار سال ہے۔',
        tafseer:
            'Signifies the vast relativity and timeless transcendence of divine decree. Often misapplied by modern internet apologists attempting forced speed-of-light formulas.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_myth_speed_of_light'],
      ),
    ],
    51: [
      const Ayah(
        surahNumber: 51,
        ayahNumber: 47,
        textArabic: 'وَالسَّمَاءَ بَنَيْنَاهَا بِأَيْدٍ وَإِنَّا لَمُوسِعُونَ',
        textTranslation: 'And the heaven We constructed with strength, and indeed, We are [its] expander.',
        textTranslationUrdu: 'اور آسمان کو ہم نے قوت سے بنایا اور یقیناً ہم اسے وسعت دینے والے ہیں۔',
        tafseer:
            'Classical authorities noted "mūsi‘ūn" denotes vast expanse and continual extension, paralleling astrophysical observations of spacetime metric expansion.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_cosmic_expansion_51_47'],
      ),
    ],
    55: [
      const Ayah(
        surahNumber: 55,
        ayahNumber: 19,
        textArabic: 'مَرَجَ الْبَحْرَيْنِ يَلْتَقِيَانِ',
        textTranslation: 'He released the two seas, meeting [side by side];',
        textTranslationUrdu: 'اس نے دو سمندر رواں کیے جو آپس میں مل رہے ہیں۔',
        tafseer: 'Refers to adjacent water bodies of differing salinities and temperatures meeting.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_water_halocline'],
      ),
      const Ayah(
        surahNumber: 55,
        ayahNumber: 20,
        textArabic: 'بَيْنَهُمَا بَرْزَخٌ لَّا يَبْغِيَانِ',
        textTranslation: 'Between them is a barrier [barzakh] which neither transgresses.',
        textTranslationUrdu: 'ان کے درمیان ایک پردہ (رکاوٹ) ہے جس سے وہ تجاوز نہیں کرتے۔',
        tafseer:
            'Describing the physical pycnocline/halocline dynamic boundary maintaining density stratification between waters.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_water_halocline'],
      ),
    ],
    78: [
      const Ayah(
        surahNumber: 78,
        ayahNumber: 6,
        textArabic: 'أَلَمْ نَجْعَلِ الْأَرْضَ مِهَادًا',
        textTranslation: 'Have We not made the earth a resting place?',
        textTranslationUrdu: 'کیا ہم نے زمین کو بچھونا نہیں بنایا؟',
        tafseer: 'Establishing terrestrial topography as habitable and stable for biological life.',
        hasScientificConnections: false,
      ),
      const Ayah(
        surahNumber: 78,
        ayahNumber: 7,
        textArabic: 'وَالْجِبَالَ أَوْتَادًا',
        textTranslation: 'And the mountains as stakes (pegs)?',
        textTranslationUrdu: 'اور پہاڑوں کو میخیں نہیں بنایا؟',
        tafseer:
            'Metaphor of stakes (Awtad) having deeper subterranean roots beneath the surface, paralleling geological concepts of isostatic equilibrium and deep crustal mountain roots.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_mountains_isostasy'],
      ),
    ],
    96: [
      const Ayah(
        surahNumber: 96,
        ayahNumber: 1,
        textArabic: 'اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ',
        textTranslation: 'Recite in the name of your Lord who created -',
        textTranslationUrdu: 'پڑھیے اپنے رب کے نام سے جس نے پیدا کیا -',
        tafseer: 'The inaugural revelation establishing divine imperative for literacy, inquiry, and contemplation.',
        hasScientificConnections: false,
      ),
      const Ayah(
        surahNumber: 96,
        ayahNumber: 2,
        textArabic: 'خَلَقَ الْإِنسَانَ مِنْ عَلَقٍ',
        textTranslation: 'Created man from an \'Alaq (clinging clot/suspended entity).',
        textTranslationUrdu: 'جس نے انسان کو جمے ہوئے خون (لٹکتے ہوئے لوتھڑے) سے پیدا کیا۔',
        tafseer: 'Biological inception highlighted in the very opening revelation.',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_embryology_23_14'],
      ),
      const Ayah(
        surahNumber: 96,
        ayahNumber: 15,
        textArabic: 'كَلَّا لَئِن لَّمْ يَنتَهِ لَنَسْفَعًا بِالنَّاصِيَةِ',
        textTranslation: 'No! If he does not desist, We will surely drag him by the forelock -',
        textTranslationUrdu: 'ہرگز نہیں! اگر وہ باز نہ آیا تو ہم ضرور اسے پیشانی کے بالوں سے پکڑ کر گھسیٹیں گے -',
        tafseer: 'Singling out the front crown of the head as the seat of stubborn defiance.',
        hasScientificConnections: false,
      ),
      const Ayah(
        surahNumber: 96,
        ayahNumber: 16,
        textArabic: 'نَاصِيَةٍ كَاذِبَةٍ خَاطِئَةٍ',
        textTranslation: 'A lying, sinning forelock.',
        textTranslationUrdu: 'پیشانی جو جھوٹی اور خطا کار ہے۔',
        tafseer:
            'Ascribing moral culpability and intentional deceit directly to the "Nasiyah" (prefrontal lobe area responsible for executive control and deceit).',
        hasScientificConnections: true,
        scientificConnectionIds: ['conn_prefrontal_cortex_96_16'],
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
            (ayah.textTranslationUrdu?.contains(query) ?? false) ||
            (ayah.tafseer?.toLowerCase().contains(lower) ?? false)) {
          results.add(ayah);
        }
      }
    }
    return results;
  }
}
