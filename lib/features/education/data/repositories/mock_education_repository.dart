import '../../../../core/models/evidence_level.dart';
import '../../../science/domain/entities/research_paper.dart';
import '../entities/hadith_reference.dart';
import '../entities/practice_step.dart';
import '../entities/scientific_insight.dart';
import '../entities/sunnah_practice.dart';
import '../repositories/education_repository.dart';

class MockEducationRepository implements EducationRepository {
  static const SunnahPractice _sunnahDrinking = SunnahPractice(
    id: 'sunnah_drinking_water',
    titleEnglish: 'The Sunnah of Drinking Water',
    titleArabic: 'سُنَّةُ الشُّرْبِ',
    subtitle: 'Drink calmly, pause, breathe, and follow the Sunnah.',
    hadiths: [
      HadithReference(
        id: 'hadith_muslim_2028a',
        collection: 'Sahih Muslim',
        hadithNumber: '2028a',
        book: 'The Book of Drinks (Kitab Al-Ashriba)',
        textArabic: 'كَانَ يَتَنَفَّسُ فِي الإِنَاءِ ثَلاَثًا',
        textEnglish: '“The Messenger of Allah ﷺ would breathe three times during drinking.”',
        commentary:
            'Scholars of Hadith clarify that this refers to drinking in three distinct gulps or intervals, with the vessel moved away from the mouth when inhaling or exhaling, rather than exhaling into the drinking vessel itself.',
        scholarlyNuance: null,
        grade: 'Sahih',
      ),
      HadithReference(
        id: 'hadith_muslim_2028b',
        collection: 'Sahih Muslim',
        hadithNumber: '2028b',
        book: 'The Book of Drinks (Kitab Al-Ashriba)',
        textArabic:
            'أَنَّ رَسُولَ اللَّهِ صلى الله عليه وسلم كَانَ يَتَنَفَّسُ فِي الشَّرَابِ ثَلاَثًا وَيَقُولُ: إِنَّهُ أَرْوَى وَأَبْرَأُ وَأَمْرَأُ',
        textEnglish:
            '“The Messenger of Allah ﷺ took three breaths during drinking and stated: It is more thirst-quenching, healthier, and more wholesome.”',
        commentary:
            'Anas ibn Malik reported that dividing one’s intake into measured intervals provides complete quenching of thirst (أَرْوَى), guards against digestive distress or ailment (أَبْرَأُ), and is easily and pleasantly digested (أَمْرَأُ).',
        scholarlyNuance: null,
        grade: 'Sahih',
      ),
      HadithReference(
        id: 'hadith_muslim_2024a',
        collection: 'Sahih Muslim',
        hadithNumber: '2024a',
        book: 'The Book of Drinks (Kitab Al-Ashriba)',
        textArabic: 'زَجَرَ عَنِ الشُّرْبِ قَائِمًا',
        textEnglish: '“He ﷺ disapproved of drinking while standing.”',
        commentary:
            'The Prophet ﷺ encouraged drinking in a calm, seated posture as standard prophetic etiquette (Adab).',
        scholarlyNuance:
            '“The Sunnah encourages drinking while seated. However, other authentic narrations report that the Prophet ﷺ also drank while standing on some occasions. Therefore, the app should not tell users that drinking while standing is medically dangerous or forbidden in every circumstance.”',
        grade: 'Sahih',
      ),
    ],
    steps: [
      PracticeStep(
        stepNumber: 1,
        title: 'Sit comfortably',
        instruction:
            'Settle into a calm, upright seated posture before bringing the cup to your lips. Sitting fosters mindfulness and composure.',
        arabicPhrase: null,
        waterLevel: 1.0,
        isBreathingPhase: false,
        iconName: 'airline_seat_recline_normal_rounded',
      ),
      PracticeStep(
        stepNumber: 2,
        title: 'Say Bismillah',
        instruction:
            'Commence by remembering the Creator who provided pure water as the sustenance of all life.',
        arabicPhrase: 'بِسْمِ اللهِ',
        waterLevel: 1.0,
        isBreathingPhase: false,
        iconName: 'auto_stories_rounded',
      ),
      PracticeStep(
        stepNumber: 3,
        title: 'Take the first drink',
        instruction:
            'Take a moderate first sip calmly without rushing or gulping down large quantities.',
        arabicPhrase: null,
        waterLevel: 0.67,
        isBreathingPhase: false,
        iconName: 'water_drop_rounded',
      ),
      PracticeStep(
        stepNumber: 4,
        title: 'Move the cup away',
        instruction:
            'Gently separate the cup from your mouth, following prophetic hygiene etiquette.',
        arabicPhrase: null,
        waterLevel: 0.67,
        isBreathingPhase: false,
        iconName: 'pan_tool_alt_rounded',
      ),
      PracticeStep(
        stepNumber: 5,
        title: 'Breathe',
        instruction:
            'Take a gentle breath outside of the vessel, resetting your respiratory rhythm comfortably.',
        arabicPhrase: null,
        waterLevel: 0.67,
        isBreathingPhase: true,
        iconName: 'air_rounded',
      ),
      PracticeStep(
        stepNumber: 6,
        title: 'Drink again',
        instruction:
            'Take a second moderate drink with measured cadence and unhurried composure.',
        arabicPhrase: null,
        waterLevel: 0.33,
        isBreathingPhase: false,
        iconName: 'water_drop_rounded',
      ),
      PracticeStep(
        stepNumber: 7,
        title: 'Pause and breathe',
        instruction:
            'Lower the vessel once more and take a natural breath away from the cup.',
        arabicPhrase: null,
        waterLevel: 0.33,
        isBreathingPhase: true,
        iconName: 'air_rounded',
      ),
      PracticeStep(
        stepNumber: 8,
        title: 'Drink the third time',
        instruction:
            'Complete your drink on the third sip, leaving your body refreshed and hydrated.',
        arabicPhrase: null,
        waterLevel: 0.05,
        isBreathingPhase: false,
        iconName: 'local_drink_rounded',
      ),
      PracticeStep(
        stepNumber: 9,
        title: 'Praise Allah',
        instruction:
            'Conclude by expressing heartfelt gratitude to Allah for wholesome and thirst-quenching water.',
        arabicPhrase: 'الْحَمْدُ لِلَّهِ',
        waterLevel: 0.0,
        isBreathingPhase: false,
        iconName: 'favorite_rounded',
      ),
    ],
    scientificIntro:
        '“Modern research on swallowing and drinking provides possible physiological context for some aspects of this practice, but it does not establish that exactly three sips or sitting is medically necessary for every person.”',
    scientificFindings: [
      ScientificInsight(
        id: 'finding_posture',
        title: 'Finding 1 — Upright Posture',
        finding:
            'Research involving healthy adults found that swallowing was perceived as easiest in an upright sitting position compared with several other tested postures.',
        relevanceNuance:
            '“An upright posture can facilitate swallowing mechanics, although this study does not prove the religious instruction itself.”',
        domain: 'Posture & Biomechanics',
        iconName: 'accessibility_new_rounded',
      ),
      ScientificInsight(
        id: 'finding_volume',
        title: 'Finding 2 — Drink Volume',
        finding:
            'Research on swallowing physiology shows that bolus/liquid volume affects swallowing mechanics, requiring varied muscular driving pressure and pharyngeal transit duration.',
        relevanceNuance:
            '“Taking smaller individual amounts may reduce the size of each swallowed bolus, but this does not prove that three specific sips are required.”',
        domain: 'Fluid Dynamics & Deglutition',
        iconName: 'opacity_rounded',
      ),
      ScientificInsight(
        id: 'finding_aspiration',
        title: 'Finding 3 — Aspiration Risks',
        finding:
            'Research has found that larger bolus volumes can increase the likelihood of penetration/aspiration into the laryngeal vestibule during swallowing studies.',
        relevanceNuance:
            '“This is particularly relevant to people with swallowing difficulties, but healthy people should not interpret this as evidence that normal drinking is dangerous.”',
        domain: 'Laryngeal Physiology',
        iconName: 'health_and_safety_rounded',
      ),
      ScientificInsight(
        id: 'finding_respiration',
        title: 'Finding 4 — Breathing & Swallowing Coordination',
        finding:
            'Swallowing temporarily interacts with respiration by producing obligatory swallow apnea. Research indicates that drinking volume directly influences the duration and coordination between breathing and swallowing.',
        relevanceNuance:
            '“Pausing between drinks naturally creates opportunities to breathe rather than continuously drinking.”',
        domain: 'Cardiorespiratory Coupling',
        iconName: 'air_rounded',
      ),
    ],
    evidenceLevel: EvidenceLevel.moderate,
    evidenceExplanation:
        '“The scientific literature provides physiological evidence concerning upright posture, swallowing volume, and breathing-swallow coordination. However, there is insufficient evidence to conclude that exactly three drinking intervals are medically necessary.”',
    researchPapers: [
      ResearchPaper(
        id: 'paper_alghadir_2017',
        title: 'Effect of posture on swallowing',
        authors: [
          'Ahmad H. Alghadir',
          'Hamayun Zafar',
          'Einas S. Al-Eisa',
          'Zaheen A. Iqbal'
        ],
        journal: 'African Health Sciences',
        publicationYear: 2017,
        doi: '10.4314/ahs.v17i1.17',
        sourceUrl: 'https://doi.org/10.4314/ahs.v17i1.17',
        abstractSummary:
            'Investigated the impact of various body postures on perceived swallowing difficulty in healthy adults. Subjective evaluation demonstrated that an upright sitting posture yielded the lowest difficulty scores, facilitating gravity-assisted esophageal clearance compared to tilted or supine orientations.',
        methodology: 'Prospective observational study on healthy adult volunteers',
        field: 'Physical Therapy & Rehabilitation',
        isPeerReviewed: true,
        isMockDemo: false,
      ),
      ResearchPaper(
        id: 'paper_butler_2011',
        title:
            'Aspiration as a Function of Age, Sex, Liquid Type, Bolus Volume, and Bolus Delivery Across the Healthy Adult Life Span',
        authors: [
          'Stephanie G. Butler',
          'Andrew Stuart',
          'Landon Markley',
          'Clark Rees'
        ],
        journal: 'Annals of Otology, Rhinology & Laryngology',
        publicationYear: 2011,
        doi: '10.1177/000348941112000707',
        sourceUrl: 'https://doi.org/10.1177/000348941112000707',
        abstractSummary:
            'Examined videofluoroscopic swallowing data across healthy adults. Results demonstrated that larger bolus volumes (cup sips vs. measured increments) significantly increased the incidence of airway penetration, illustrating that controlled volume delivery supports airway safety.',
        methodology: 'Videofluoroscopic Swallowing Study (VFSS) across lifespan cohorts',
        field: 'Otolaryngology & Speech-Language Pathology',
        isPeerReviewed: true,
        isMockDemo: false,
      ),
      ResearchPaper(
        id: 'paper_mcculloch_2010',
        title:
            'Effect of bolus volume on pharyngeal swallowing assessed by high-resolution manometry',
        authors: [
          'Timothy M. McCulloch',
          'Matthew R. Hoffman',
          'Michelle R. Ciucci'
        ],
        journal: 'Dysphagia',
        publicationYear: 2010,
        doi: '10.1007/s00455-009-9243-7',
        sourceUrl: 'https://doi.org/10.1007/s00455-009-9243-7',
        abstractSummary:
            'Used high-resolution manometry to record intrabolus pressures during pharyngeal deglutition. Demonstrates that pharyngeal contraction duration and peak pressures adjust with increased liquid volume, confirming that smaller liquid amounts optimize bolus driving mechanics.',
        methodology: 'Solid-state high-resolution manometry in adult subjects',
        field: 'Gastroenterology & Deglutology',
        isPeerReviewed: true,
        isMockDemo: false,
      ),
      ResearchPaper(
        id: 'paper_martin_harris_2005',
        title:
            'Coordination of respiration and swallowing: effect of bolus volume in normal adults',
        authors: [
          'Bonnie Martin-Harris',
          'Martin B. Brodsky',
          'Yvon Michel',
          'Frank S. Lee',
          'Bernard Trouche'
        ],
        journal: 'Respiratory Physiology & Neurobiology',
        publicationYear: 2005,
        doi: '10.1016/j.resp.2004.10.006',
        sourceUrl: 'https://doi.org/10.1016/j.resp.2004.10.006',
        abstractSummary:
            'Evaluated respiratory-swallow phase relationships and swallow apnea duration across discrete liquid bolus volumes. Shows that swallow apnea duration lengthens significantly with larger volumes, confirming that deliberate pauses between drinking actions naturally create space for normalized respiratory cycles.',
        methodology: 'Concurrent submental electromyography, nasal airflow, and respiratory plethysmography',
        field: 'Neurobiology & Respiratory Physiology',
        isPeerReviewed: true,
        isMockDemo: false,
      ),
    ],
    educationalDisclaimer:
        '“This feature is educational and does not constitute medical advice. Scientific research is presented to provide context and should not be interpreted as proof that every aspect of a Sunnah has a medically established mechanism or necessity.”',
  );

  @override
  Future<SunnahPractice> getSunnahDrinkingPractice() async {
    // Local mock with simulated micro-delay for realistic UI rendering
    await Future.delayed(const Duration(milliseconds: 60));
    return _sunnahDrinking;
  }

  @override
  Future<List<SunnahPractice>> getAllSunnahPractices() async {
    await Future.delayed(const Duration(milliseconds: 60));
    return [_sunnahDrinking];
  }
}
