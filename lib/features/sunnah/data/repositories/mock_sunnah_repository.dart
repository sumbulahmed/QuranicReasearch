import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/evidence_level.dart';
import '../../../science/domain/entities/research_paper.dart';
import '../models/hadith_reference.dart';
import '../models/scientific_insight.dart';
import '../models/sunnah_category.dart';
import '../models/sunnah_practice.dart';
import '../models/sunnah_step.dart';
import 'sunnah_repository.dart';

class MockSunnahRepository implements SunnahRepository {
  static const List<SunnahCategory> _categories = [
    SunnahCategory(
      id: 'eating_drinking',
      name: 'Eating & Drinking',
      arabicName: 'الأكل والشرب',
      icon: Icons.restaurant_rounded,
      count: 5,
      color: AppColors.primaryMaroon,
    ),
    SunnahCategory(
      id: 'sleep',
      name: 'Sleep',
      arabicName: 'النوم',
      icon: Icons.bedtime_rounded,
      count: 3,
      color: AppColors.accentSepia,
    ),
    SunnahCategory(
      id: 'cleanliness',
      name: 'Cleanliness',
      arabicName: 'النظافة',
      icon: Icons.clean_hands_rounded,
      count: 4,
      color: AppColors.primaryEmerald,
    ),
    SunnahCategory(
      id: 'prayer',
      name: 'Prayer',
      arabicName: 'الصلاة',
      icon: Icons.access_time_filled_rounded,
      count: 6,
      color: AppColors.accentGold,
    ),
    SunnahCategory(
      id: 'daily_life',
      name: 'Daily Life',
      arabicName: 'الحياة اليومية',
      icon: Icons.wb_sunny_rounded,
      count: 8,
      color: AppColors.primaryMaroonLight,
    ),
    SunnahCategory(
      id: 'character',
      name: 'Character',
      arabicName: 'الأخلاق',
      icon: Icons.favorite_rounded,
      count: 7,
      color: AppColors.evidenceStrong,
    ),
    SunnahCategory(
      id: 'health_hygiene',
      name: 'Health & Hygiene',
      arabicName: 'الصحة والوقاية',
      icon: Icons.health_and_safety_rounded,
      count: 5,
      color: AppColors.evidenceModerate,
    ),
    SunnahCategory(
      id: 'family',
      name: 'Family',
      arabicName: 'الأسرة',
      icon: Icons.people_alt_rounded,
      count: 4,
      color: AppColors.accentSepiaLight,
    ),
    SunnahCategory(
      id: 'travel',
      name: 'Travel',
      arabicName: 'السفر',
      icon: Icons.directions_walk_rounded,
      count: 3,
      color: AppColors.evidencePossible,
    ),
    SunnahCategory(
      id: 'morning_evening',
      name: 'Morning & Evening',
      arabicName: 'أذكار الصباح والمساء',
      icon: Icons.brightness_6_rounded,
      count: 5,
      color: AppColors.accentGoldLight,
    ),
    SunnahCategory(
      id: 'social_manners',
      name: 'Social Manners',
      arabicName: 'الآداب الاجتماعية',
      icon: Icons.forum_rounded,
      count: 6,
      color: AppColors.primaryMaroonDark,
    ),
    SunnahCategory(
      id: 'worship',
      name: 'Worship',
      arabicName: 'العبادات',
      icon: Icons.menu_book_rounded,
      count: 6,
      color: AppColors.primaryMaroon,
    ),
  ];

  static const List<SunnahPractice> _practices = [
    // 1. Drinking Water
    SunnahPractice(
      id: 'drinking-water',
      title: 'The Sunnah of Drinking Water',
      arabicTitle: 'سُنَّةُ الشُّرْبِ',
      description:
          'Learn about drinking calmly in three intervals, pausing between drinks, and upright posture.',
      category: 'Eating & Drinking',
      categoryArabic: 'الأكل والشرب',
      keywords: ['water', 'drinking', 'sip', 'swallowing', 'posture', 'shurb', 'thirst'],
      hadithReferences: [
        HadithReference(
          id: 'h_muslim_2028a',
          collection: 'Sahih Muslim',
          book: 'The Book of Drinks',
          hadithNumber: '2028a',
          arabicText: 'كَانَ يَتَنَفَّسُ فِي الإِنَاءِ ثَلاَثًا',
          englishTranslation:
              '“The Messenger of Allah ﷺ would breathe three times during drinking.”',
          commentary:
              'Scholars clarify that this refers to drinking in three distinct pauses or gulps, moving the cup away from the lips during breathing rather than breathing into the vessel.',
          sourceUrl: 'https://sunnah.com/muslim:2028a',
        ),
        HadithReference(
          id: 'h_muslim_2028b',
          collection: 'Sahih Muslim',
          book: 'The Book of Drinks',
          hadithNumber: '2028b',
          arabicText:
              'أَنَّ رَسُولَ اللَّهِ صلى الله عليه وسلم كَانَ يَتَنَفَّسُ فِي الشَّرَابِ ثَلاَثًا وَيَقُولُ: إِنَّهُ أَرْوَى وَأَبْرَأُ وَأَمْرَأُ',
          englishTranslation:
              '“The Messenger of Allah ﷺ took three breaths during drinking and stated: It is more thirst-quenching, healthier, and more wholesome.”',
          commentary:
              'Anas reported that dividing intake into intervals quenches thirst more effectively, prevents rapid abdominal distension, and aids digestion.',
          sourceUrl: 'https://sunnah.com/muslim:2028b',
        ),
        HadithReference(
          id: 'h_muslim_2024a',
          collection: 'Sahih Muslim',
          book: 'The Book of Drinks',
          hadithNumber: '2024a',
          arabicText: 'زَجَرَ عَنِ الشُّرْبِ قَائِمًا',
          englishTranslation: '“He ﷺ disapproved of drinking while standing.”',
          scholarlyNuance:
              '“The Sunnah encourages drinking while seated. However, other authentic narrations report that the Prophet ﷺ also drank while standing on some occasions. Therefore, the app should not tell users that drinking while standing is medically dangerous or forbidden in every circumstance.”',
          sourceUrl: 'https://sunnah.com/muslim:2024a',
        ),
      ],
      steps: [
        SunnahStep(
          stepNumber: 1,
          title: 'Sit comfortably',
          description: 'Settle into a calm upright sitting position before drinking.',
          iconName: 'chair',
        ),
        SunnahStep(
          stepNumber: 2,
          title: 'Say Bismillah',
          description: 'Begin with mindfulness by remembering Allah.',
          arabicPhrase: 'بِسْمِ اللهِ',
          iconName: 'menu_book',
        ),
        SunnahStep(
          stepNumber: 3,
          title: 'Take the first drink',
          description: 'Take a moderate first sip calmly without rushing.',
          iconName: 'water_drop',
          progressValue: 0.67,
        ),
        SunnahStep(
          stepNumber: 4,
          title: 'Move the cup away',
          description: 'Separate the vessel from your mouth to maintain hygiene.',
          iconName: 'pan_tool',
          progressValue: 0.67,
        ),
        SunnahStep(
          stepNumber: 5,
          title: 'Breathe',
          description: 'Take a natural, calm breath outside of the vessel.',
          iconName: 'air',
          progressValue: 0.67,
        ),
        SunnahStep(
          stepNumber: 6,
          title: 'Drink again',
          description: 'Take the second drink with unhurried cadence.',
          iconName: 'water_drop',
          progressValue: 0.33,
        ),
        SunnahStep(
          stepNumber: 7,
          title: 'Pause and breathe',
          description: 'Lower the cup once more and breathe gently outside the cup.',
          iconName: 'air',
          progressValue: 0.33,
        ),
        SunnahStep(
          stepNumber: 8,
          title: 'Drink the third time',
          description: 'Take the third and final sip, comfortably satisfying your thirst.',
          iconName: 'local_drink',
          progressValue: 0.05,
        ),
        SunnahStep(
          stepNumber: 9,
          title: 'Praise Allah',
          description: 'Conclude by expressing gratitude to Allah for pure water.',
          arabicPhrase: 'الْحَمْدُ لِلَّهِ',
          iconName: 'favorite',
          progressValue: 0.0,
        ),
      ],
      scientificPerspective:
          'Modern research on swallowing and drinking provides possible physiological context for some aspects of this practice, but it does not establish that exactly three sips or sitting is medically necessary for every person.',
      scientificInsights: [
        ScientificInsight(
          title: 'Upright Posture & Esophageal Transit',
          summary:
              'Research involving healthy adults found that swallowing was perceived as easiest in an upright sitting position compared with several other tested postures.',
          mechanism:
              'Gravity assists bolus clearance through the upper esophageal sphincter while optimizing laryngeal inlet closure.',
          evidenceLevel: 'Moderate Evidence',
          limitations:
              'An upright posture can facilitate swallowing mechanics, although this study does not prove the religious instruction itself.',
        ),
        ScientificInsight(
          title: 'Drink Volume & Pharyngeal Pressure',
          summary:
              'Research on swallowing physiology shows that bolus/liquid volume affects swallowing mechanics.',
          mechanism:
              'Smaller single-sip boluses demand lower peak driving pressures and shorter pharyngeal contraction durations.',
          evidenceLevel: 'Moderate Evidence',
          limitations:
              'Taking smaller individual amounts may reduce the size of each swallowed bolus, but this does not prove that three specific sips are required.',
        ),
        ScientificInsight(
          title: 'Aspiration Risks & Volume Control',
          summary:
              'Research has found that larger bolus volumes can increase the likelihood of penetration/aspiration in swallowing studies.',
          mechanism:
              'Larger fluid masses can challenge the rapid elevation and anterior movement of the hyolaryngeal complex.',
          evidenceLevel: 'Moderate Evidence',
          limitations:
              'This is particularly relevant to people with swallowing difficulties, but healthy people should not interpret this as evidence that normal drinking is dangerous.',
        ),
        ScientificInsight(
          title: 'Breathing and Swallowing Coordination',
          summary:
              'Swallowing temporarily interacts with respiration. Research indicates that drinking volume can influence the coordination between breathing and swallowing.',
          mechanism:
              'Each swallow triggers swallow apnea (brief breath pause). Continuous gulping strains oxygen delivery; pausing resets respiration.',
          evidenceLevel: 'Moderate Evidence',
          limitations:
              'Pausing between drinks naturally creates opportunities to breathe rather than continuously drinking.',
        ),
      ],
      researchStudies: [
        ResearchPaper(
          id: 'paper_alghadir_2017',
          title: 'Effect of posture on swallowing',
          authors: ['Ahmad H. Alghadir', 'Hamayun Zafar', 'Einas S. Al-Eisa', 'Zaheen A. Iqbal'],
          journal: 'African Health Sciences',
          publicationYear: 2017,
          doi: '10.4314/ahs.v17i1.17',
          sourceUrl: 'https://doi.org/10.4314/ahs.v17i1.17',
          abstractSummary:
              'Evaluated perceived swallowing difficulty across distinct bodily postures in healthy adults, showing that an upright sitting posture yielded the lowest swallowing difficulty ratings compared with reclined or supine positions.',
          methodology: 'Prospective observational study on healthy adult volunteers',
          field: 'Physical Therapy & Rehabilitation',
          isPeerReviewed: true,
          isMockDemo: false,
        ),
        ResearchPaper(
          id: 'paper_butler_2011',
          title:
              'Aspiration as a Function of Age, Sex, Liquid Type, Bolus Volume, and Bolus Delivery Across the Healthy Adult Life Span',
          authors: ['Stephanie G. Butler', 'Andrew Stuart', 'Landon Markley', 'Clark Rees'],
          journal: 'Annals of Otology, Rhinology & Laryngology',
          publicationYear: 2011,
          doi: '10.1177/000348941112000707',
          sourceUrl: 'https://doi.org/10.1177/000348941112000707',
          abstractSummary:
              'Investigated penetration and aspiration parameters across diverse liquid volumes and delivery methods in healthy adults, finding that larger single-bolus volumes significantly increase laryngeal penetration frequency.',
          methodology: 'Videofluoroscopic Swallowing Study (VFSS) across lifespan cohorts',
          field: 'Otolaryngology & Speech Pathology',
          isPeerReviewed: true,
          isMockDemo: false,
        ),
      ],
      evidenceLevel: EvidenceLevel.moderate,
      evidenceExplanation:
          'The scientific literature provides physiological evidence concerning upright posture, swallowing volume, and breathing-swallow coordination. However, there is insufficient evidence to conclude that exactly three drinking intervals are medically necessary.',
      videoAsset: 'assets/videos/drinking_water_animation.mp4',
      childTitle: 'Drinking Like the Prophet ﷺ',
      childDescription:
          'Let’s learn how to sit down, say Bismillah, take 3 small calm sips of water, and breathe outside the cup!',
      childSteps: [
        'Sit down in a comfy chair',
        'Hold your cup with your right hand and say Bismillah',
        'Take a small gentle sip',
        'Move the cup away and take a soft breath',
        'Take your second sip, then pause and breathe',
        'Take your third sip and say Alhamdulillah!',
      ],
      childSafetyNote: 'Always sit down while drinking so you do not choke or spill your water.',
    ),

    // 2. Eating with the Right Hand
    SunnahPractice(
      id: 'eating-right-hand',
      title: 'Eating with the Right Hand',
      arabicTitle: 'الأَكْلُ بِالْيَمِينِ',
      description:
          'Practicing intentional eating and drinking using the right hand, dedicating the left hand to personal hygiene.',
      category: 'Eating & Drinking',
      categoryArabic: 'الأكل والشرب',
      keywords: ['eating', 'right hand', 'hygiene', 'food', 'table manners', 'yameen'],
      hadithReferences: [
        HadithReference(
          id: 'h_muslim_2020a',
          collection: 'Sahih Muslim',
          book: 'The Book of Drinks',
          hadithNumber: '2020a',
          arabicText: 'إِذَا أَكَلَ أَحَدُكُمْ فَلْيَأْكُلْ بِيَمِينِهِ وَإِذَا شَرِبَ فَلْيَشْرَبْ بِيَمِينِهِ',
          englishTranslation:
              '“When any one of you eats, he should eat with his right hand, and when he drinks he should drink with his right hand.”',
          commentary:
              'Separating the functions of the right hand (eating, noble interactions) from the left hand (hygiene, cleaning) establishes a high standard of personal cleanliness and conscious mindfulness.',
          sourceUrl: 'https://sunnah.com/muslim:2020a',
        ),
      ],
      steps: [
        SunnahStep(
          stepNumber: 1,
          title: 'Wash Hands',
          description: 'Cleanse both hands thoroughly before touching any food.',
          iconName: 'clean_hands',
        ),
        SunnahStep(
          stepNumber: 2,
          title: 'Dedicate the Right Hand',
          description: 'Use the right hand exclusively for lifting food and handling utensils.',
          iconName: 'pan_tool',
        ),
        SunnahStep(
          stepNumber: 3,
          title: 'Reserve the Left Hand',
          description: 'Keep the left hand reserved for sanitization and non-ingestion tasks.',
          iconName: 'wash',
        ),
      ],
      scientificPerspective:
          'Behavioral science and public health hygiene recognize that functional hand segregation (dedicating one hand for food and the other for personal sanitation) is a classic preventative measure against microbial cross-contamination, especially in shared eating environments.',
      scientificInsights: [
        ScientificInsight(
          title: 'Cross-Contamination Mitigation',
          summary:
              'Assigning discrete behavioral roles to hands reduces hand-to-mouth transmission of enteric pathogens.',
          mechanism:
              'The dominant food hand remains unexposed to personal bodily hygiene contamination.',
          evidenceLevel: 'Moderate Evidence',
          limitations:
              'Both hands still require rigorous washing; segregation alone does not replace handwashing.',
        ),
      ],
      evidenceLevel: EvidenceLevel.possible,
      evidenceExplanation:
          'Behavioral hygiene principles corroborate the hygienic value of hand segregation, though it is primarily a prophetic discipline and spiritual etiquette.',
      childTitle: 'The Right Hand for Yummy Food',
      childDescription:
          'We use our right hand for eating food and holding our cups, just like the Prophet ﷺ did!',
      childSteps: [
        'Wash your hands with warm water and soap',
        'Hold your fork or bread in your right hand',
        'Eat politely and smile with your family',
      ],
    ),

    // 3. Eating from What Is in Front of You
    SunnahPractice(
      id: 'eating-front',
      title: 'Eating from What Is in Front of You',
      arabicTitle: 'الأَكْلُ مِمَّا يَلِي',
      description:
          'Eating from the area directly facing you when sharing a communal platter, demonstrating consideration and contentment.',
      category: 'Eating & Drinking',
      categoryArabic: 'الأكل والشرب',
      keywords: ['communal food', 'platter', 'table manners', 'consideration', 'front'],
      hadithReferences: [
        HadithReference(
          id: 'h_bukhari_5376',
          collection: 'Sahih Bukhari',
          book: 'Book of Food',
          hadithNumber: '5376',
          arabicText: 'يَا غُلاَمُ سَمِّ اللَّهَ، وَكُلْ بِيَمِينِكَ، وَكُلْ مِمَّا يَلِيكَ',
          englishTranslation:
              '“O young boy! Say Bismillah, eat with your right hand, and eat from what is directly in front of you.”',
          commentary:
              'The Prophet ﷺ taught young Umar ibn Abi Salama courteous dining manners to prevent stretching across communal plates and making others uncomfortable.',
          sourceUrl: 'https://sunnah.com/bukhari:5376',
        ),
      ],
      steps: [
        SunnahStep(
          stepNumber: 1,
          title: 'Say Bismillah',
          description: 'Begin meal with the name of Allah.',
          arabicPhrase: 'بِسْمِ اللهِ',
          iconName: 'menu_book',
        ),
        SunnahStep(
          stepNumber: 2,
          title: 'Eat from your perimeter',
          description: 'Take food only from the portion of the dish directly adjacent to you.',
          iconName: 'restaurant',
        ),
        SunnahStep(
          stepNumber: 3,
          title: 'Avoid reaching across',
          description: 'Do not stretch over other diners’ portions or reach into the dish center.',
          iconName: 'pan_tool',
        ),
      ],
      scientificPerspective:
          'Studies in social psychology and nutritional ergonomics indicate that defined eating boundaries encourage portion self-regulation and reduce viral/bacterial transfer between diners sharing family-style meals.',
      evidenceLevel: EvidenceLevel.possible,
      evidenceExplanation:
          'Demonstrates wholesome social etiquette and hygiene; current research highlights portion awareness and courteous communal dining.',
      childTitle: 'Sharing at the Table',
      childDescription:
          'When eating with family, always eat from the food closest to you without reaching across!',
      childSteps: [
        'Sit politely at the table',
        'Take bites only from the food right in front of you',
        'Say please if you want something further away',
      ],
    ),

    // 4. Sleeping on the Right Side
    SunnahPractice(
      id: 'sleep-right-side',
      title: 'Sleeping on the Right Side',
      arabicTitle: 'آدَابُ النَّوْمِ عَلَى الشِّقِّ الأَيْمَنِ',
      description:
          'Performing ablution, reciting evening remembrances, and resting on the right side upon going to sleep.',
      category: 'Sleep',
      categoryArabic: 'النوم',
      keywords: ['sleep', 'right side', 'wudu', 'posture', 'night', 'rest'],
      hadithReferences: [
        HadithReference(
          id: 'h_bukhari_247',
          collection: 'Sahih Bukhari',
          book: 'Book of Ablution',
          hadithNumber: '247',
          arabicText: 'إِذَا أَتَيْتَ مَضْجَعَكَ فَتَوَضَّأْ وَضُوءَكَ لِلصَّلاَةِ، ثُمَّ اضْطَجِعْ عَلَى شِقِّكَ الأَيْمَنِ',
          englishTranslation:
              '“When you intend to go to bed, perform ablution as you do for prayer, then lie down on your right side.”',
          commentary:
              'The Prophet ﷺ recommended starting sleep in a state of purification and lying on the right lateral side while reciting night supplications.',
          sourceUrl: 'https://sunnah.com/bukhari:247',
        ),
      ],
      steps: [
        SunnahStep(
          stepNumber: 1,
          title: 'Perform Wudu',
          description: 'Cleanse with ablution before turning in for sleep.',
          iconName: 'water_drop',
        ),
        SunnahStep(
          stepNumber: 2,
          title: 'Lie on the right side',
          description: 'Rest on your right lateral side, placing the right hand under your cheek.',
          iconName: 'bedtime',
        ),
        SunnahStep(
          stepNumber: 3,
          title: 'Recite Night Dhikr',
          description: 'Conclude your waking hours in peaceful remembrance of Allah.',
          iconName: 'menu_book',
        ),
      ],
      scientificPerspective:
          'Medical literature examining sleep posture indicates that right lateral decubitus positioning may reduce cardiac load by minimizing compression of the mediastinum and heart, while facilitating gastric emptying due to the anatomical curvature of the stomach.',
      scientificInsights: [
        ScientificInsight(
          title: 'Cardiac Autonomic Modulation',
          summary:
              'Clinical cardiac physiology demonstrates that right-lateral sleep posture lowers sympathetic nervous tone and minimizes heart displacement in healthy individuals.',
          mechanism:
              'Lying on the right prevents the heavier left lung and visceral mass from resting upon the pericardial sac.',
          evidenceLevel: 'Moderate Evidence',
          limitations:
              'Natural nocturnal turning is normal; patients with severe acid reflux may require individualized head elevation.',
        ),
      ],
      evidenceLevel: EvidenceLevel.moderate,
      evidenceExplanation:
          'Corroborated by physiological studies on cardiac autonomic tone and sleep ergonomics, though individuals naturally change postures during nocturnal sleep.',
      childTitle: 'Sleeping Peacefully on Your Right Side',
      childDescription:
          'Brush your teeth, cuddle with your pillow on your right side, and say Bismika Allahumma Amutu wa Ahya!',
      childSteps: [
        'Get cozy in your bed',
        'Turn gently onto your right side',
        'Close your eyes and thank Allah for a wonderful day',
      ],
    ),

    // 5. Saying Bismillah Before Meals
    SunnahPractice(
      id: 'bismillah-before-eating',
      title: 'Saying Bismillah Before Eating',
      arabicTitle: 'التَّسْمِيَةُ عِنْدَ الطَّعَامِ',
      description:
          'Beginning every meal with the remembrance of Allah, expressing gratitude and cultivating mindful ingestion.',
      category: 'Eating & Drinking',
      categoryArabic: 'الأكل والشرب',
      keywords: ['bismillah', 'eating', 'mindfulness', 'gratitude', 'blessing', 'barakah'],
      hadithReferences: [
        HadithReference(
          id: 'h_abudawud_3767',
          collection: 'Sunan Abi Dawud',
          book: 'Book of Foods',
          hadithNumber: '3767',
          arabicText: 'إِذَا أَكَلَ أَحَدُكُمْ فَلْيَذْكُرِ اسْمَ اللَّهِ تَعَالَى',
          englishTranslation:
              '“When one of you eats, he should mention the name of Allah the Most High.”',
          commentary:
              'Uttering Bismillah instills reverence, consciousness of provision, and spiritual barakah into the meal.',
          sourceUrl: 'https://sunnah.com/abudawud:3767',
        ),
      ],
      steps: [
        SunnahStep(
          stepNumber: 1,
          title: 'Pause before touching food',
          description: 'Bring your awareness to the food before you.',
          iconName: 'pause_circle',
        ),
        SunnahStep(
          stepNumber: 2,
          title: 'Say Bismillah',
          description: 'Say “Bismillah” aloud or quietly before the first bite.',
          arabicPhrase: 'بِسْمِ اللهِ',
          iconName: 'menu_book',
        ),
        SunnahStep(
          stepNumber: 3,
          title: 'If forgotten, say Bismillahi awwalahu wa akhirahu',
          description: 'If forgotten initially, mention Allah’s name as soon as remembered.',
          arabicPhrase: 'بِسْمِ اللهِ أَوَّلَهُ وَآخِرَهُ',
          iconName: 'replay',
        ),
      ],
      scientificPerspective:
          'Nutritional and psychological research on mindful eating demonstrates that deliberate pre-meal pauses reduce impulsive overeating, stimulate the parasympathetic cephalic phase of digestion, and foster healthier emotional relationships with nutrition.',
      scientificInsights: [
        ScientificInsight(
          title: 'Cephalic Phase Digestive Stimulation',
          summary:
              'Taking a mindful pause before eating activates parasympathetic salivary and gastric secretion.',
          mechanism:
              'Mindful recognition prepares enzyme release for optimized carbohydrate and protein digestion.',
          evidenceLevel: 'Moderate Evidence',
          limitations:
              'The religious practice is spiritual in essence; physiological priming is an organic byproduct of calm mindfulness.',
        ),
      ],
      evidenceLevel: EvidenceLevel.possible,
      evidenceExplanation:
          'Strong behavioral science ties exist between pre-meal mindfulness and digestive health, though Bismillah is primarily an act of worship and gratitude.',
      childTitle: 'Always Remember Bismillah!',
      childDescription:
          'Before you take your first delicious bite, say Bismillah to thank Allah for your yummy food!',
      childSteps: [
        'Look at your food and smile',
        'Say: Bismillah!',
        'Take your first bite calmly',
      ],
    ),

    // 6. Using the Miswak
    SunnahPractice(
      id: 'using-miswak',
      title: 'Using the Miswak (Natural Tooth-Stick)',
      arabicTitle: 'السِّوَاكُ',
      description:
          'Maintaining oral hygiene and freshness by cleaning the teeth and gums with the twig of the Salvadora persica tree.',
      category: 'Cleanliness',
      categoryArabic: 'النظافة',
      keywords: ['miswak', 'teeth', 'hygiene', 'mouth', 'siwak', 'cleanliness'],
      hadithReferences: [
        HadithReference(
          id: 'h_bukhari_887',
          collection: 'Sahih Bukhari',
          book: 'Friday Prayer',
          hadithNumber: '887',
          arabicText: 'لَوْلاَ أَنْ أَشُقَّ عَلَى أُمَّتِي لأَمَرْتُهُمْ بِالسِّوَاكِ عِنْدَ كُلِّ صَلاَةٍ',
          englishTranslation:
              '“Were it not that it would be hard upon my nation, I would have ordered them to use the miswak before every prayer.”',
          commentary:
              'The Prophet ﷺ placed immense emphasis on oral hygiene, using the miswak before prayer, after waking, and when entering his home.',
          sourceUrl: 'https://sunnah.com/bukhari:887',
        ),
      ],
      steps: [
        SunnahStep(
          stepNumber: 1,
          title: 'Prepare the Miswak tip',
          description: 'Chew the tip lightly until natural bristles form.',
          iconName: 'brush',
        ),
        SunnahStep(
          stepNumber: 2,
          title: 'Brush across the teeth',
          description: 'Gently brush horizontally and vertically across the enamel and gumline.',
          iconName: 'clean_hands',
        ),
        SunnahStep(
          stepNumber: 3,
          title: 'Rinse and preserve',
          description: 'Rinse the miswak bristles after use and store in an airy, clean place.',
          iconName: 'water_drop',
        ),
      ],
      scientificPerspective:
          'Numerous peer-reviewed dental and chemical studies confirm that Salvadora persica (Miswak) contains natural antimicrobial compounds including benzyl isothiocyanate, silica, fluoride, tannins, and vitamin C that effectively reduce plaque, gingivitis, and cariogenic bacteria.',
      scientificInsights: [
        ScientificInsight(
          title: 'Phytochemical Antimicrobial Action',
          summary:
              'Dental research indicates Salvadora persica extracts exhibit potent bactericidal effects against Streptococcus mutans and periodontal pathogens.',
          mechanism:
              'Natural isothiocyanates break down microbial cell membranes, while silica acts as a mild mechanical abrasive.',
          evidenceLevel: 'Strong Evidence',
          limitations:
              'Miswak should be used with gentle technique to avoid mechanical gingival recession.',
        ),
      ],
      evidenceLevel: EvidenceLevel.strong,
      evidenceExplanation:
          'Extensively corroborated by contemporary international dentistry research, systematic reviews, and the World Health Organization (WHO) oral health recommendations.',
      childTitle: 'Cleaning Teeth Like the Prophet ﷺ',
      childDescription:
          'Keeping your teeth clean and shiny makes your smile look great and pleases Allah!',
      childSteps: [
        'Get your toothbrush or miswak',
        'Brush top and bottom teeth gently',
        'Rinse your mouth and show off your bright smile',
      ],
    ),

    // 7. Sneezing Etiquette
    SunnahPractice(
      id: 'sneezing-etiquette',
      title: 'Etiquette of Sneezing',
      arabicTitle: 'آدَابُ الْعُطَاسِ',
      description:
          'Covering the mouth and nose during sneezing, softening the sound, praising Allah, and wishing mercy upon fellow believers.',
      category: 'Social Manners',
      categoryArabic: 'الآداب الاجتماعية',
      keywords: ['sneezing', 'alhamdulillah', 'yarhamukallah', 'manners', 'hygiene', 'utas'],
      hadithReferences: [
        HadithReference(
          id: 'h_tirmidhi_2745',
          collection: 'Jami` at-Tirmidhi',
          book: 'Chapters on Manners',
          hadithNumber: '2745',
          arabicText: 'كَانَ رَسُولُ اللَّهِ صلى الله عليه وسلم إِذَا عَطَسَ وَضَعَ يَدَهُ أَوْ ثَوْبَهُ عَلَى فِيهِ وَخَفَضَ أَوْ غَضَّ بِهَا صَوْتَهُ',
          englishTranslation:
              '“When the Messenger of Allah ﷺ sneezed, he would place his hand or his garment over his face and soften or subdue his sound with it.”',
          commentary:
              'Prophetic etiquette combines physical hygiene (covering aerosols) with courtesy (not startling others with loud noise).',
          sourceUrl: 'https://sunnah.com/tirmidhi:2745',
        ),
      ],
      steps: [
        SunnahStep(
          stepNumber: 1,
          title: 'Cover face and mouth',
          description: 'Use a cloth, tissue, or your sleeve/hand to cover your nose and mouth.',
          iconName: 'masks',
        ),
        SunnahStep(
          stepNumber: 2,
          title: 'Mute the sound',
          description: 'Subdue the expulsion volume so as not to startle those around you.',
          iconName: 'volume_down',
        ),
        SunnahStep(
          stepNumber: 3,
          title: 'Say Alhamdulillah',
          description: 'Praise Allah immediately after sneezing.',
          arabicPhrase: 'الْحَمْدُ لِلَّهِ',
          iconName: 'favorite',
        ),
      ],
      scientificPerspective:
          'Epidemiology and fluid biomechanics demonstrate that human sneezes can propel turbulent gas clouds carrying infectious respiratory droplets at high velocity across several meters. Covering the face significantly arrests droplet dispersion.',
      scientificInsights: [
        ScientificInsight(
          title: 'Aerosol Plume Containment',
          summary:
              'High-speed visualization studies confirm that covering sneezes prevents the wide distribution of pathogenic bioaerosols.',
          mechanism:
              'Physical barrier absorption arrests high-momentum droplet clusters before airborne dispersal.',
          evidenceLevel: 'Strong Evidence',
          limitations:
              'Tissues or the inner elbow are preferred in modern healthcare to avoid contaminating hands.',
        ),
      ],
      evidenceLevel: EvidenceLevel.strong,
      evidenceExplanation:
          'A universal cornerstone of modern respiratory epidemiology and public health transmission prevention.',
      childTitle: 'Covering Your Sneeze',
      childDescription:
          'When you sneeze, cover your nose and mouth like a superhero into your sleeve, and say Alhamdulillah!',
      childSteps: [
        'Catch your sneeze in your elbow or tissue',
        'Say: Alhamdulillah!',
        'Smile when someone says Yarhamukallah to you',
      ],
    ),

    // 8. Greeting with Salam
    SunnahPractice(
      id: 'greeting-salam',
      title: 'Initiating and Spreading the Salam',
      arabicTitle: 'إِفْشَاءُ السَّلاَمِ',
      description:
          'Actively offering the greeting of peace (As-salamu alaykum) to those you know and those you do not know.',
      category: 'Social Manners',
      categoryArabic: 'الآداب الاجتماعية',
      keywords: ['salam', 'greeting', 'peace', 'social', 'kindness', 'manners'],
      hadithReferences: [
        HadithReference(
          id: 'h_muslim_54',
          collection: 'Sahih Muslim',
          book: 'The Book of Faith',
          hadithNumber: '54',
          arabicText: 'أَفْشُوا السَّلاَمَ بَيْنَكُمْ تَحَابُّوا',
          englishTranslation:
              '“Spread peace among yourselves and you will love one another.”',
          commentary:
              'Greeting with Salam is an explicit prayer of peace, mercy, and security, creating bonds of mutual trust.',
          sourceUrl: 'https://sunnah.com/muslim:54',
        ),
      ],
      steps: [
        SunnahStep(
          stepNumber: 1,
          title: 'Initiate the greeting',
          description: 'Be the first to say As-salamu alaykum with warmth.',
          arabicPhrase: 'السَّلاَمُ عَلَيْكُمْ',
          iconName: 'handshake',
        ),
        SunnahStep(
          stepNumber: 2,
          title: 'Respond generously',
          description: 'Reply with an equal or better blessing: Wa alaykumu s-salam wa rahmatullah.',
          arabicPhrase: 'وَعَلَيْكُمُ السَّلاَمُ وَرَحْمَةُ اللهِ',
          iconName: 'chat',
        ),
      ],
      scientificPerspective:
          'Social psychology and neurobiology confirm that prosocial micro-affirmations and deliberate verbal warm greetings lower perceived social threat, foster reciprocal empathy, and promote communal psychological well-being.',
      evidenceLevel: EvidenceLevel.possible,
      evidenceExplanation:
          'Strong qualitative alignment with social psychology and behavioral cohesion research.',
      childTitle: 'Saying Salam to Everyone!',
      childDescription:
          'Whenever you meet a friend or family member, say As-salamu Alaykum with a happy smile!',
      childSteps: [
        'Look at your friend kindly',
        'Say: As-salamu Alaykum!',
        'Listen happily to their answer',
      ],
    ),

    // 9. Smiling as Charity
    SunnahPractice(
      id: 'smiling-charity',
      title: 'Smiling as an Act of Charity',
      arabicTitle: 'التَّبَسُّمُ فِي وَجْهِ أَخِيكَ',
      description:
          'Meeting others with a joyful, sincere smile, radiating warmth and kindness without monetary expense.',
      category: 'Character',
      categoryArabic: 'الأخلاق',
      keywords: ['smile', 'charity', 'kindness', 'sadqa', 'joy', 'tabassum'],
      hadithReferences: [
        HadithReference(
          id: 'h_tirmidhi_1956',
          collection: 'Jami` at-Tirmidhi',
          book: 'Chapters on Righteousness',
          hadithNumber: '1956',
          arabicText: 'تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ لَكَ صَدَقَةٌ',
          englishTranslation:
              '“Your smiling in the face of your brother is charity for you.”',
          commentary:
              'Charity in Islam is not confined to wealth; uplifting human spirits and demonstrating benevolence is a rewarded worship.',
          sourceUrl: 'https://sunnah.com/tirmidhi:1956',
        ),
      ],
      steps: [
        SunnahStep(
          stepNumber: 1,
          title: 'Notice people around you',
          description: 'Acknowledge people with presence rather than ignoring them.',
          iconName: 'visibility',
        ),
        SunnahStep(
          stepNumber: 2,
          title: 'Offer a sincere smile',
          description: 'Smile from the heart with warm eyes and genuine compassion.',
          iconName: 'sentiment_very_satisfied',
        ),
      ],
      scientificPerspective:
          'The facial feedback hypothesis and neuroimaging confirm that smiling stimulates dopamine and endorphin release, while engaging mirror neurons in onlookers to trigger reciprocal positive affect and reduce biological cortisol stress.',
      scientificInsights: [
        ScientificInsight(
          title: 'Mirror Neurons & Neurochemical Release',
          summary:
              'Psychoneuroimmunology studies demonstrate that facial muscle movement during smiling signals the amygdala and releases mood-elevating neurotransmitters.',
          mechanism:
              'Contraction of the zygomaticus major muscle promotes bidirectional emotional feedback and lowers heart rate recovery latency.',
          evidenceLevel: 'Strong Evidence',
          limitations:
              'Genuine social engagement is more effective than artificial or forced emotional display.',
        ),
      ],
      evidenceLevel: EvidenceLevel.strong,
      evidenceExplanation:
          'Extensively documented across contemporary cognitive neuroscience and social psychology literature.',
      childTitle: 'A Big Beautiful Smile!',
      childDescription:
          'Did you know smiling at someone gives you good deeds like giving a present? Share your smile today!',
      childSteps: [
        'Look at your mom, dad, or friend',
        'Give them your biggest, kindest smile',
        'Notice how happy it makes everyone feel!',
      ],
    ),

    // 10. Moderation in Eating
    SunnahPractice(
      id: 'moderation-eating',
      title: 'Moderation in Eating (The One-Third Rule)',
      arabicTitle: 'الاقْتِصَادُ فِي الطَّعَامِ',
      description:
          'Avoiding overeating by budgeting stomach capacity: one-third for food, one-third for drink, and one-third for breath.',
      category: 'Eating & Drinking',
      categoryArabic: 'الأكل والشرب',
      keywords: ['moderation', 'stomach', 'one third', 'diet', 'metabolism', 'iqtisad'],
      hadithReferences: [
        HadithReference(
          id: 'h_tirmidhi_2380',
          collection: 'Jami` at-Tirmidhi',
          book: 'Chapters on Zuhd',
          hadithNumber: '2380',
          arabicText: 'مَا مَلأَ آدَمِيٌّ وِعَاءً شَرًّا مِنْ بَطْنٍ... فَثُلُثٌ لِطَعَامِهِ وَثُلُثٌ لِشَرَابِهِ وَثُلُثٌ لِنَفَسِهِ',
          englishTranslation:
              '“A human being fills no vessel worse than his stomach... If he must fill it, then one third for his food, one third for his drink, and one third for his breath.”',
          commentary:
              'The Prophet ﷺ discouraged overconsumption, establishing a foundational guideline for metabolic balance, energy, and mental clarity.',
          sourceUrl: 'https://sunnah.com/tirmidhi:2380',
        ),
      ],
      steps: [
        SunnahStep(
          stepNumber: 1,
          title: 'Eat to sustain strength',
          description: 'A few morsels that satisfy hunger and keep your back straight.',
          iconName: 'fitness_center',
        ),
        SunnahStep(
          stepNumber: 2,
          title: 'Divide your intake',
          description: 'One-third for solid food, one-third for liquid, leaving space for easy breathing.',
          iconName: 'pie_chart',
        ),
        SunnahStep(
          stepNumber: 3,
          title: 'Stop before full',
          description: 'Cease eating before reaching feeling bloated or lethargic.',
          iconName: 'stop_circle',
        ),
      ],
      scientificPerspective:
          'Gastroenterology and metabolic endocrinology strongly validate caloric moderation. Satiety hormones (leptin, GLP-1) require approximately 15–20 minutes to register in the hypothalamus. Eating to 70–80% fullness prevents gastric distension, metabolic overload, insulin spikes, and gastroesophageal reflux.',
      scientificInsights: [
        ScientificInsight(
          title: 'Gastric Stretch Receptors & Satiety Lag',
          summary:
              'Neurogastroenterology demonstrates that mechanical gastric distention and hormone signaling have an inherent latency.',
          mechanism:
              'Stopping at one-third volume prevents blunt vagal inhibition and preserves metabolic efficiency.',
          evidenceLevel: 'Strong Evidence',
          limitations:
              'Specific caloric needs vary with basal metabolic rate and physical expenditure.',
        ),
      ],
      evidenceLevel: EvidenceLevel.strong,
      evidenceExplanation:
          'Unanimous agreement across modern clinical nutrition, preventive cardiology, and metabolic syndrome literature.',
      childTitle: 'Eating Just What You Need',
      childDescription:
          'Eat until your tummy feels nicely happy, but do not eat so much that your belly hurts!',
      childSteps: [
        'Take nice, calm bites of your food',
        'Drink a little water',
        'When your tummy feels good, stop and say Alhamdulillah!',
      ],
    ),
  ];

  @override
  Future<List<SunnahCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 40));
    return _categories;
  }

  @override
  Future<List<SunnahPractice>> getSunnahList({String? category, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 40));
    var results = _practices;

    if (category != null && category.isNotEmpty && category != 'All') {
      results = results.where((p) {
        return p.category.toLowerCase() == category.toLowerCase() ||
            p.categoryArabic == category;
      }).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      results = results.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.arabicTitle.contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.keywords.any((k) => k.toLowerCase().contains(q));
      }).toList();
    }

    return results;
  }

  @override
  Future<SunnahPractice?> getSunnahById(String id) async {
    await Future.delayed(const Duration(milliseconds: 30));
    final normalized = id.toLowerCase().replaceAll('_', '-');
    try {
      return _practices.firstWhere(
        (p) => p.id.toLowerCase().replaceAll('_', '-') == normalized,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SunnahPractice> getFeaturedSunnah() async {
    await Future.delayed(const Duration(milliseconds: 30));
    return _practices.first; // Drinking Water
  }
}
