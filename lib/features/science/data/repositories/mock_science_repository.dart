import '../../domain/entities/scientific_topic.dart';
import '../../domain/entities/scientific_connection.dart';
import '../../domain/entities/research_paper.dart';
import '../../domain/repositories/science_repository.dart';
import '../../../../core/models/evidence_level.dart';

class MockScienceRepository implements ScienceRepository {
  static final List<ScientificTopic> _topics = [
    const ScientificTopic(
      id: 'embryology',
      title: 'Human Embryological Morphology',
      category: 'Medicine & Developmental Biology',
      summary:
          'Comparative examination of the sequential prenatal development described in Surah Al-Mu\'minun and the internationally recognized Carnegie Stages of human development.',
      iconName: 'child_care',
      evidenceDistribution: {
        'strong': 2,
        'emerging': 1,
        'possible': 0,
        'unsupported': 0,
      },
      connectionsCount: 3,
      tags: ['embryo', 'nutfah', 'alaqah', 'mudghah', 'carnegie'],
      featured: true,
    ),
    const ScientificTopic(
      id: 'oceanography',
      title: 'Internal Ocean Waves & Deep Sea Stratification',
      category: 'Earth Sciences & Physical Oceanography',
      summary:
          'Physical investigation into subsurface internal waves occurring at pycnocline density interfaces in deep marine basins, referencing Surah An-Nur.',
      iconName: 'waves',
      evidenceDistribution: {
        'strong': 1,
        'emerging': 1,
        'possible': 0,
        'unsupported': 0,
      },
      connectionsCount: 2,
      tags: ['ocean', 'internal_waves', 'pycnocline', 'marine_biology'],
      featured: true,
    ),
    const ScientificTopic(
      id: 'prefrontal_cortex',
      title: 'The Prefrontal Cortex, Executive Function & Deception',
      category: 'Neurobiology & Cognitive Psychology',
      summary:
          'Neuroanatomical roles of the frontopolar prefrontal cortex in moral conflict, intentional lying, and voluntary impulse control (Surah Al-\'Alaq).',
      iconName: 'psychology',
      evidenceDistribution: {
        'strong': 0,
        'emerging': 2,
        'possible': 0,
        'unsupported': 0,
      },
      connectionsCount: 2,
      tags: ['neuroscience', 'prefrontal_cortex', 'nasiyah', 'deception'],
      featured: true,
    ),
    const ScientificTopic(
      id: 'cosmic_expansion',
      title: 'Cosmic Metric Expansion & Astronomy',
      category: 'Astrophysics & Cosmology',
      summary:
          'Examining the cosmological expansion of the universe (Hubble-Lemaître Law) alongside classical Arabic linguistic interpretations of Surah Adh-Dhariyat (51:47).',
      iconName: 'all_inclusive',
      evidenceDistribution: {
        'strong': 0,
        'emerging': 1,
        'possible': 1,
        'unsupported': 0,
      },
      connectionsCount: 2,
      tags: ['astronomy', 'expansion', 'redshift', 'flwr_metric'],
      featured: false,
    ),
    const ScientificTopic(
      id: 'debunked_speed_of_light',
      title: 'Debunked: The "Speed of Light in Quran" Calculation',
      category: 'Scientific Myth-Busters',
      summary:
          'A critical, transparent breakdown demonstrating why popular internet formulas attempting to calculate the exact speed of light from Surah As-Sajdah (32:5) are flawed and unscientific.',
      iconName: 'cancel',
      evidenceDistribution: {
        'strong': 0,
        'emerging': 0,
        'possible': 0,
        'unsupported': 1,
      },
      connectionsCount: 1,
      tags: ['myth_buster', 'speed_of_light', 'apologetics', 'critical_thinking'],
      featured: true,
    ),
  ];

  static final List<ResearchPaper> _papers = [
    const ResearchPaper(
      id: 'paper_moore_1982',
      title: 'A Scientist\'s Interpretation of References to Embryology in the Qur\'an',
      authors: ['Keith L. Moore, Ph.D., F.I.A.C.'],
      journal: 'Journal of the Islamic Medical Association of North America',
      publicationYear: 1982,
      doi: '10.5915/18-2-5421',
      sourceUrl: 'https://doi.org/10.5915/18-2-5421',
      abstractSummary:
          'This landmark paper analyzes 7th-century descriptions of pre-natal developmental stages and correlates the descriptive terms (Nutfah, \'Alaqah, Mudghah) with modern Carnegie staging in human anatomy.',
      methodology: 'Comparative Morphological Anatomy',
      isPeerReviewed: true,
    ),
    const ResearchPaper(
      id: 'paper_persaud_1993',
      title: 'Early Development of the Human Embryo and Carnegie Staging Criteria',
      authors: ['T. V. N. Persaud, M.D., Ph.D.', 'Keith L. Moore'],
      journal: 'The Anatomical Record',
      publicationYear: 1993,
      doi: '10.1002/ar.1092360105',
      sourceUrl: 'https://doi.org/10.1002/ar.1092360105',
      abstractSummary:
          'Detailed chronological timeline of early human organogenesis, Carnegie stages 9 through 14, highlighting the external somite segmentation resembling chewed tissue.',
      methodology: 'Histological & Microscopic Analysis',
      isPeerReviewed: true,
    ),
    const ResearchPaper(
      id: 'paper_jackson_2004',
      title: 'An Atlas of Oceanic Internal Solitary Waves and Their Global Distribution',
      authors: ['Christopher R. Jackson, Ph.D.'],
      journal: 'Global Ocean Associates / Office of Naval Research',
      publicationYear: 2004,
      doi: '10.1029/2004JC002488',
      sourceUrl: 'https://doi.org/10.1029/2004JC002488',
      abstractSummary:
          'Empirical satellite synthetic aperture radar (SAR) survey mapping subsurface internal waves at density discontinuities (pycnocline) beneath the apparent calm surface of the world\'s oceans.',
      methodology: 'Synthetic Aperture Radar (SAR) & In Situ Hydrographic Profiling',
      isPeerReviewed: true,
    ),
    const ResearchPaper(
      id: 'paper_spence_2001',
      title: 'Behavioural and Functional Anatomical Correlates of Deception in Humans',
      authors: ['Sean A. Spence, M.D.', 'T. F. Farrow', 'A. E. Herford', 'I. D. Wilkinson'],
      journal: 'NeuroReport (Rapid Communications in Neuroscience)',
      publicationYear: 2001,
      doi: '10.1097/00001756-200109210-00042',
      sourceUrl: 'https://doi.org/10.1097/00001756-200109210-00042',
      abstractSummary:
          'Using functional magnetic resonance imaging (fMRI), this study established that formulating deceptive statements selectively recruits the bilateral ventrolateral and dorsolateral prefrontal cortex.',
      methodology: 'Event-Related Functional MRI (fMRI) in Controlled Human Cohort',
      isPeerReviewed: true,
    ),
  ];

  static final List<ScientificConnection> _connections = [
    const ScientificConnection(
      id: 'conn_embryology_23_14',
      topicId: 'embryology',
      textType: IslamicTextType.quran,
      surahNumber: 23,
      ayahNumber: 14,
      ayahKey: '23:14',
      evidenceLevel: EvidenceLevel.strong,
      headline: 'Sequential Embryo Stages: Nutfah, \'Alaqah, and Mudghah',
      explanation:
          'The Quranic progression matches visible morphological shifts. The word \'Alaqah describes: (1) a clinging entity (blastocyst implanting into the uterine endometrium), (2) a leech-like structure (curved shape of Carnegie stage 10 embryo with internal neural tube), and (3) a blood clot (primitive cardiovascular system filled with nucleated erythroblasts). Following this, "Mudghah" describes a chewed mass, closely mirroring the segmented appearance of bilateral somites in weeks 4-5.',
      classicalTafseer:
          'Ibn Kathir (Tafseer Al-Qur\'an Al-\'Azeem): Clarifies that \'Alaqah signifies coagulated red substance that suspends in the womb, which subsequently develops into flesh (Mudghah) with early differentiation.',
      scientificConsensus:
          'The morphological transformation from Carnegie Stage 9 (day 20) to Carnegie Stage 13 (day 28) matches these macroscopic physical descriptors in sequential order.',
      scholarlyCaveats:
          'The Quran utilizes observational descriptive vocabulary intended for contemplation by 7th-century people, not 21st-century histological cellular terminology. It is a sign of divine craftsmanship, not a medical treatise.',
      paperIds: ['paper_moore_1982', 'paper_persaud_1993'],
      verifiedByScholars: true,
    ),
    const ScientificConnection(
      id: 'conn_oceanography_24_40',
      topicId: 'oceanography',
      textType: IslamicTextType.quran,
      surahNumber: 24,
      ayahNumber: 40,
      ayahKey: '24:40',
      evidenceLevel: EvidenceLevel.strong,
      headline: 'Subsurface Internal Waves Beneath Marine Surface Waters',
      explanation:
          'Surah An-Nur 24:40 describes: "A deep sea covered by waves, above which are waves, above which are clouds; darknesses upon one another." Physical oceanography verifies that deep seas have two distinct wave layers: surface gravity waves and underwater internal waves breaking at density boundary pycnoclines beneath the surface.',
      classicalTafseer:
          'At-Tabari and Al-Qurtubi noted the literal phrasing of wave upon wave, observing that the ocean interior contains turbulent movement layered beneath the visible surface.',
      scientificConsensus:
          'Internal waves exist at interfaces between ocean layers of different density (thermocline/pycnocline) and can reach heights exceeding 100 meters while the sea surface remains calm.',
      scholarlyCaveats:
          'The primary literary function of the verse is an evocative spiritual parable depicting the psychological state of disbelief. The empirical correspondence with ocean stratification is a profound corroborating observation.',
      paperIds: ['paper_jackson_2004'],
      verifiedByScholars: true,
    ),
    const ScientificConnection(
      id: 'conn_neuro_96_16',
      topicId: 'prefrontal_cortex',
      textType: IslamicTextType.quran,
      surahNumber: 96,
      ayahNumber: 16,
      ayahKey: '96:16',
      evidenceLevel: EvidenceLevel.emerging,
      headline: 'The "Forelock" (Nāsiyah): Executive Intent and Deception',
      explanation:
          'Surah Al-\'Alaq singles out "A lying, sinning forelock" (Nāsiyah). Functional neuroimaging indicates that the prefrontal cortex—positioned directly behind the frontal bone of the forehead—is the seat of executive function, moral inhibition, and conscious deceit.',
      classicalTafseer:
          'Classical commentators like As-Sa\'di explained that the forelock is used metonymously to represent the person\'s willful rebellion and intentional scheming.',
      scientificConsensus:
          'Neuroscience identifies the frontopolar and dorsolateral prefrontal cortex as critical for inhibiting truthful responses during deliberate deceit.',
      scholarlyCaveats:
          'Metonymy (Majāz) is a standard classical Arabic rhetorical device where the forehead symbolizes the individual or their pride; attributing modern cognitive neuroscience directly to the ancient term requires cautious nuance.',
      paperIds: ['paper_spence_2001'],
      verifiedByScholars: true,
    ),
    const ScientificConnection(
      id: 'conn_myth_speed_of_light',
      topicId: 'debunked_speed_of_light',
      textType: IslamicTextType.quran,
      surahNumber: 32,
      ayahNumber: 5,
      ayahKey: '32:5',
      evidenceLevel: EvidenceLevel.unsupported,
      headline: 'Critique: Attempting to Derive "c" (Speed of Light) from 32:5',
      explanation:
          'Viral internet claims assert that 32:5 ("He directs each affair... in a day whose measure is a thousand years") calculates the speed of light to 299,792 km/s. Rigorous analysis reveals that this formula arbitrarily manipulates sidereal vs synodic lunar months, introduces unjustified velocity factors, and forces mathematical constants onto a theological verse about the cosmic timescale of divine decree.',
      classicalTafseer:
          'Ibn Abbas and Mujahid uniformly explained this verse as referring to the descent of the angelic decree from the highest heaven to earth and back, emphasizing vast divine majesty, not the physics of electromagnetic radiation.',
      scientificConsensus:
          'The calculation relies on numerological confirmation bias and violates basic dimensional physics.',
      scholarlyCaveats:
          'Educating Muslim youth about why this claim is invalid protects faith from being tied to flimsy apologetics that collapse under scientific scrutiny.',
      paperIds: [],
      verifiedByScholars: true,
    ),
  ];

  @override
  Future<List<ScientificTopic>> getTopics() async {
    return _topics;
  }

  @override
  Future<ScientificTopic?> getTopicById(String topicId) async {
    try {
      return _topics.firstWhere((t) => t.id == topicId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ScientificConnection>> getConnectionsForTopic(String topicId) async {
    return _connections.where((c) => c.topicId == topicId).toList();
  }

  @override
  Future<List<ScientificConnection>> getConnectionsForAyah(int surahNumber, int ayahNumber) async {
    final key = '$surahNumber:$ayahNumber';
    return _connections.where((c) => c.ayahKey == key).toList();
  }

  @override
  Future<List<ScientificConnection>> getConnectionsForHadith(
      String collectionKey, String hadithNumber) async {
    return _connections
        .where((c) =>
            c.hadithCollection?.toLowerCase() == collectionKey.toLowerCase() &&
            c.hadithNumber == hadithNumber)
        .toList();
  }

  @override
  Future<ResearchPaper?> getResearchPaperById(String paperId) async {
    try {
      return _papers.firstWhere((p) => p.id == paperId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ResearchPaper>> getResearchPapersByIds(List<String> paperIds) async {
    return _papers.where((p) => paperIds.contains(p.id)).toList();
  }
}
