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
      description: 'The premier authentic compendium of Hadith literature in Islamic tradition.',
    ),
    const HadithCollection(
      key: 'muslim',
      nameEnglish: 'Sahih Muslim',
      nameArabic: 'صحيح مسلم',
      compiler: 'Imam Muslim ibn al-Hajjaj',
      totalHadiths: 7500,
      description: 'The second most canonical compilation of authentic Prophetic narrations.',
    ),
    const HadithCollection(
      key: 'abudawud',
      nameEnglish: 'Sunan Abi Dawud',
      nameArabic: 'سنن أبي داود',
      compiler: 'Imam Abu Dawud as-Sijistani',
      totalHadiths: 5274,
      description: 'Celebrated collection focusing primarily on legal traditions and ethical life.',
    ),
    const HadithCollection(
      key: 'tirmidhi',
      nameEnglish: 'Jami` at-Tirmidhi',
      nameArabic: 'جامع الترمذي',
      compiler: 'Imam Abu Isa Muhammad at-Tirmidhi',
      totalHadiths: 3956,
      description: 'Renowned for rigorous comparative analysis and explicit grading of each narration.',
    ),
  ];

  static final List<Hadith> _hadiths = [
    const Hadith(
      collectionKey: 'bukhari',
      hadithNumber: '3208',
      bookName: 'Beginning of Creation (Bad\' al-Khalq)',
      chapterNumber: 6,
      textArabic:
          'إِنَّ أَحَدَكُمْ يُجْمَعُ خَلْقُهُ فِي بَطْنِ أُمِّهِ أَرْبَعِينَ يَوْمًا، ثُمَّ يَكُونُ عَلَقَةً مِثْلَ ذَلِكَ، ثُمَّ يَكُونُ مُضْغَةً مِثْلَ ذَلِكَ...',
      textTranslation:
          'The creation of each of you is gathered in his mother\'s womb for forty days, then he is a clinging clot for a similar period, then he is a chewed lump of flesh for a similar period...',
      textTranslationUrdu:
          'تم میں سے ہر ایک کی پیدائش اس کی ماں کے پیٹ میں چالیس دن نطفہ کی صورت میں جمع رہتی ہے، پھر اتنی ہی مدت جما ہوا خون رہتا ہے، پھر اتنی ہی مدت گوشت کا لوتھڑا رہتا ہے...',
      grading: HadithGrading.sahih,
      narrator: 'Abdullah ibn Mas\'ud (RA)',
      category: 'Health & Biology',
      explanation:
          'Highlights the precise temporal and morphological development of human embryogenesis in maternal custody.',
      scientificPerspective:
          'Aligns with morphological Carnegie Stages 10-14, demonstrating suspended uterine attachment and early cellular somite demarcation.',
      hasScientificConnections: true,
      scientificConnectionIds: ['conn_embryology_23_14'],
      relatedResearchIds: ['paper_moore_1982', 'paper_persaud_1992'],
    ),
    const Hadith(
      collectionKey: 'bukhari',
      hadithNumber: '1904',
      bookName: 'Book of Fasting (Sawm)',
      chapterNumber: 9,
      textArabic:
          'الصِّيَامُ جُنَّةٌ فَلَا يَرْفُثْ وَلَا يَجْهَلْ، وَإِنِ امْرُؤٌ قَاتَلَهُ أَوْ شَاتَمَهُ فَلْيَقُلْ: إِنِّي صَائِمٌ مَرَّتَيْنِ',
      textTranslation:
          'Fasting is a protective shield. So when one of you is fasting, he should neither indulge in foul language nor act foolishly. If someone fights or abuses him, let him say twice: "I am fasting."',
      textTranslationUrdu:
          'روزہ ایک ڈھال ہے۔ پس جب تم میں سے کوئی روزے سے ہو تو نہ فحش گوئی کرے اور نہ جہالت کی بات۔ اگر کوئی اس سے جھگڑے یا گالی دے تو وہ دو بار کہے: "میں روزے سے ہوں"۔',
      grading: HadithGrading.sahih,
      narrator: 'Abu Hurairah (RA)',
      category: 'Health & Fasting',
      explanation:
          'Establishes fasting as a dual shield: safeguarding spiritual character and reinforcing neurological resilience against emotional impulsivity.',
      scientificPerspective:
          'Periodic caloric restriction and deliberate fasting activate cellular autophagy, attenuate neuro-inflammation, and enhance frontal lobe executive impulse control.',
      hasScientificConnections: true,
      scientificConnectionIds: ['conn_fasting_autophagy'],
      relatedResearchIds: ['paper_mattson_2018', 'paper_ohsumi_2016'],
    ),
    const Hadith(
      collectionKey: 'muslim',
      hadithNumber: '2645',
      bookName: 'Book of Destiny (Qadr)',
      chapterNumber: 1,
      textArabic:
          'إِذَا مَرَّ بِالنُّطْفَةِ ثِنْتَانِ وَأَرْبَعُونَ لَيْلَةً، بَعَثَ اللَّهُ إِلَيْهَا مَلَكًا، فَصَوَّرَهَا، وَخَلَقَ سَمْعَهَا وَبَصَرَهَا وَجِلْدَهَا وَلَحْمَهَا وَعِظَامَهَا...',
      textTranslation:
          'When forty-two nights have passed over the Nutfah (drop), Allah sends an angel to it, who shapes it and fashions its hearing, sight, skin, flesh, and bones...',
      textTranslationUrdu:
          'جب نطفہ پر بیالیس راتیں گزر جاتی ہیں تو اللہ اس کی طرف ایک فرشتہ بھیجتا ہے جو اس کی صورت گری کرتا ہے اور اس کے کان، آنکھیں، جلد، گوشت اور ہڈیاں بناتا ہے...',
      grading: HadithGrading.sahih,
      narrator: 'Hudhaifah ibn Asid (RA)',
      category: 'Health & Biology',
      explanation:
          'Pinpoints the critical 6th week developmental transition wherein primordial facial, ocular, and cartilaginous features differentiate.',
      scientificPerspective:
          'In modern embryology (Carnegie Stage 18-19, approximately day 42-44), optical placodes, auricles, and chondrification of skeletal precursors undergo accelerated differentiation.',
      hasScientificConnections: true,
      scientificConnectionIds: ['conn_embryology_23_14'],
      relatedResearchIds: ['paper_moore_1982'],
    ),
    const Hadith(
      collectionKey: 'bukhari',
      hadithNumber: '5688',
      bookName: 'Book of Medicine (Tibb)',
      chapterNumber: 1,
      textArabic:
          'مَا أَنْزَلَ اللَّهُ دَاءً إِلَّا أَنْزَلَ لَهُ شِفَاءً',
      textTranslation:
          'There is no disease that Allah has sent down except that He also has sent down its cure.',
      textTranslationUrdu:
          'اللہ نے ایسی کوئی بیماری نہیں اتاری جس کا علاج بھی نازل نہ کیا ہو۔',
      grading: HadithGrading.sahih,
      narrator: 'Abu Hurairah (RA)',
      category: 'Medicine & Hygiene',
      explanation:
          'Epistemological mandate encouraging scientific investigation, pharmacological discovery, and the relentless pursuit of medical remedies.',
      scientificPerspective:
          'Underscores biological intelligibility: pathogenic conditions possess empirical mechanisms responsive to biochemical interventions.',
      hasScientificConnections: true,
      scientificConnectionIds: ['conn_nutrition_healing'],
      relatedResearchIds: ['paper_medicine_2021'],
    ),
    const Hadith(
      collectionKey: 'tirmidhi',
      hadithNumber: '2380',
      bookName: 'Chapters on Asceticism (Zuhd)',
      chapterNumber: 47,
      textArabic:
          'مَا مَلَأَ آدَمِيٌّ وِعَاءً شَرًّا مِنْ بَطْنٍ، بِحَسْبِ ابْنِ آدَمَ أُكُلَاتٌ يُقِمْنَ صُلْبَهُ، فَإِنْ كَانَ لَا مَحَالَةَ فَثُلُثٌ لِطَعَامِهِ وَثُلُثٌ لِشَرَابِهِ وَثُلُثٌ لِنَفَسِهِ',
      textTranslation:
          'A human fills no vessel worse than his stomach. A few morsels are sufficient for the son of Adam to keep his back straight. But if he must, then one third for his food, one third for his drink, and one third for his breath.',
      textTranslationUrdu:
          'آدم کے بیٹے نے اپنے پیٹ سے برا کوئی برتن نہیں بھرا۔ انسان کے لیے چند لقمے ہی کافی ہیں جو اس کی پیٹھ سیدھی رکھ سکیں، لیکن اگر مجبوری ہو تو ایک تہائی کھانے کے لیے، ایک تہائی پینے کے لیے اور ایک تہائی سانس کے لیے رکھے۔',
      grading: HadithGrading.sahih,
      narrator: 'Miqdam ibn Ma\'dikarib (RA)',
      category: 'Nutrition & Health',
      explanation:
          'The definitive Prophetic charter of dietary moderation, metabolic equilibrium, and gastrointestinal temperance.',
      scientificPerspective:
          'Modern gastroenterology affirms that avoiding gastric hyper-distension prevents gastroesophageal reflux, regulates ghrelin/leptin signaling, and reduces metabolic syndrome risk.',
      hasScientificConnections: true,
      scientificConnectionIds: ['conn_nutrition_moderation'],
      relatedResearchIds: ['paper_nutrition_gut_2022'],
    ),
    const Hadith(
      collectionKey: 'abudawud',
      hadithNumber: '5040',
      bookName: 'Book of General Behavior (Adab)',
      chapterNumber: 107,
      textArabic:
          'إِذَا أَوَى أَحَدُكُمْ إِلَى فِرَاشِهِ فَلْيَنْفُضْ فِرَاشَهُ بِدَاخِلَةِ إِزَارِهِ، فَإِنَّهُ لَا يَدْرِي مَا خَلَفَهُ عَلَيْهِ، ثُمَّ لِيَضْطَجِعْ عَلَى شِقِّهِ الْأَيْمَنِ...',
      textTranslation:
          'When one of you goes to his bed, let him dust off his bedding with the edge of his garment, for he does not know what came upon it after him. Then let him lie down on his right side...',
      textTranslationUrdu:
          'جب تم میں سے کوئی اپنے بستر پر جائے تو اپنے کپڑے کے کنارے سے بستر جھاڑ لے کیونکہ وہ نہیں جانتا کہ اس کے بعد اس پر کیا آ گیا۔ پھر اپنے دائیں پہلو پر لیٹ جائے...',
      grading: HadithGrading.sahih,
      narrator: 'Abu Hurairah (RA)',
      category: 'Sleep & Neurology',
      explanation:
          'Combines bed hygiene practices with right-lateral recumbent posture for physiological sleep initiation.',
      scientificPerspective:
          'Right lateral decubitus posture optimizes cardiac hemodynamics, minimizes mediastinal cardiac pressure on pulmonary tissue, and aids gastric emptying.',
      hasScientificConnections: true,
      scientificConnectionIds: ['conn_sleep_circadian'],
      relatedResearchIds: ['paper_sleep_neurology_2021'],
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
  Future<List<Hadith>> getAllHadiths() async {
    return _hadiths;
  }

  @override
  Future<List<String>> getCategories() async {
    final set = <String>{'All'};
    for (final h in _hadiths) {
      set.add(h.category);
    }
    return set.toList();
  }

  @override
  Future<List<Hadith>> searchHadiths(String query) async {
    final lower = query.toLowerCase();
    return _hadiths
        .where((h) =>
            h.textTranslation.toLowerCase().contains(lower) ||
            (h.textTranslationUrdu?.contains(query) ?? false) ||
            h.textArabic.contains(query) ||
            h.hadithNumber.contains(query) ||
            (h.narrator?.toLowerCase().contains(lower) ?? false) ||
            h.category.toLowerCase().contains(lower))
        .toList();
  }
}
