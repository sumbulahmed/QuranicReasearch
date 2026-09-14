import '../../domain/entities/scientific_topic.dart';
import '../../domain/entities/scientific_connection.dart';
import '../../domain/entities/research_paper.dart';
import '../../domain/repositories/science_repository.dart';
import '../../../../core/models/evidence_level.dart';

class MockScienceRepository implements ScienceRepository {
  static final List<ScientificTopic> _topics = [
    const ScientificTopic(
      id: 'embryology',
      title: 'Human Development & Embryology',
      category: '🧬 Human Body',
      summary:
          'Examination of sequential prenatal stages described in Surah Al-Mu\'minun (23:12-14) alongside internationally recognized Carnegie Stages of human embryogenesis.',
      description:
          'The Quran delineates sequential prenatal development using qualitative descriptive terms: Nutfah (drop), \'Alaqah (clinging clot/suspended structure), Mudghah (chewed-like tissue), followed by chondrogenesis/osteogenesis (\'Izam) and myogenesis (covering with flesh). Modern embryological science (Carnegie Stages 10-18) details strikingly parallel milestones in early organogenesis.',
      islamicPerspective:
          'Surah Al-Mu\'minun (23:12-14) and Surah Al-\'Alaq (96:1-2) describe human origin from primordial soil extracts, through fertilized zygotic implantation, to a suspended clinging structure and segmented tissue. Hadith literature (Sahih Muslim 2645, Bukhari 3208) references qualitative morphogenesis after 40-42 nights.',
      scientificExplanation:
          'At days 18-24 post-fertilization (Carnegie Stages 9-11), the embryo implants firmly into the maternal endometrium, physically resembling a leech-like clinging entity. By days 24-28 (Carnegie Stages 11-13), somites produce an appearance identical to teeth marks on a chewed morsel. In week 6-7, cartilage scaffolds form before skeletal muscle tissue envelops them.',
      whatResearchSays:
          'Scholars of clinical anatomy note that the classical Quranic designations capture macroscopic visual morphologies without contradicting known anatomical sequences. However, theologians emphasize that Quranic terminology was meant for spiritual reflection and moral awe rather than a technical surgical textbook.',
      evidenceLevel: EvidenceLevel.strong,
      iconName: 'child_care',
      evidenceDistribution: {
        'strong': 2,
        'emerging': 1,
        'possible': 0,
        'unsupported': 0,
      },
      connectionsCount: 3,
      tags: ['embryo', 'nutfah', 'alaqah', 'mudghah', 'carnegie', 'somites'],
      relatedAyahKeys: ['23:12', '23:13', '23:14', '96:1', '96:2'],
      relatedHadithIds: ['bukhari:3208', 'muslim:2645'],
      researchPaperIds: ['paper_moore_1982', 'paper_persaud_1992'],
      relatedTopicIds: ['creation_origin', 'fasting_autophagy'],
      featured: true,
    ),
    const ScientificTopic(
      id: 'water_oceans',
      title: 'Water Dynamics & Deep Ocean Waves',
      category: '💧 Nature',
      summary:
          'Subsurface internal waves occurring at pycnocline interfaces in deep marine basins, and the dynamic halocline barrier maintaining density stratification between waters.',
      description:
          'Physical oceanography reveals that deep oceans possess two distinct wave realms: surface wind waves and subterranean internal waves that propagate along thermocline and pycnocline density gradients. Additionally, where differing water masses meet (e.g. Atlantic and Mediterranean at Gibraltar), differing salinities and temperatures prevent immediate homogeneous mixing.',
      islamicPerspective:
          'Surah An-Nur (24:40) evokes the striking imagery of an unfathomable deep sea covered by waves, beneath which are other waves, enveloped in layered darknesses. Surah Ar-Rahman (55:19-20) describes two meeting seas separated by an un-transgressed barrier (Barzakh).',
      scientificExplanation:
          'Internal waves can achieve vertical displacements exceeding 100 meters at subsurface density boundaries while leaving the surface calm. Below 200 meters (the dysphotic and aphotic zones), solar photons attenuate exponentially, culminating in complete visual darkness where artificial illumination or bioluminescence is required to perceive hand movement.',
      whatResearchSays:
          'Physical oceanographic models confirmed internal wave dynamics in the mid-20th century using acoustic sounders and bathythermographs. Satellite synthetic aperture radar (SAR) imagery clearly tracks the surface manifestations of internal waves in the Strait of Gibraltar.',
      evidenceLevel: EvidenceLevel.strong,
      iconName: 'waves',
      evidenceDistribution: {
        'strong': 2,
        'emerging': 0,
        'possible': 0,
        'unsupported': 0,
      },
      connectionsCount: 3,
      tags: ['oceanography', 'internal_waves', 'pycnocline', 'barzakh', 'marine'],
      relatedAyahKeys: ['24:40', '55:19', '55:20', '2:164'],
      relatedHadithIds: [],
      researchPaperIds: ['paper_ocean_internal_waves_2019'],
      relatedTopicIds: ['environment_conservation', 'creation_origin'],
      featured: true,
    ),
    const ScientificTopic(
      id: 'sleep_circadian',
      title: 'Sleep Architecture & Circadian Rhythms',
      category: '😴 Sleep',
      summary:
          'Neurobiological restorative cycles, glymphatic waste clearance during slow-wave sleep, and the physiological advantages of lateral decubitus positioning.',
      description:
          'Sleep is an active, homeostatically regulated biological state vital for neurocognitive health, memory consolidation, and cellular repair. Recent discoveries uncover the glymphatic system—a macroscopic waste clearance mechanism active predominantly during sleep that clears metabolic neurotoxins including amyloid-beta.',
      islamicPerspective:
          'Surah Ar-Rum (30:23) identifies human sleep by night and day as an empirical sign of divine wisdom. Prophetic Hadiths (Abu Dawud 5040, Bukhari 247) mandate pre-sleep bed hygiene, evening winding down, and settling upon the right lateral side.',
      scientificExplanation:
          'The right lateral decubitus posture minimizes cardiac gravitational compression against pulmonary veins, enhances cardiac hemodynamics, and facilitates downward gastric emptying towards the pyloric sphincter, reducing nighttime acid reflux and vagal stimulation.',
      whatResearchSays:
          'Neuroimaging and magnetic resonance studies on rodent and human subjects confirm that lateral sleep postures optimize cerebrospinal fluid-interstitial fluid exchange compared to supine or prone postures.',
      evidenceLevel: EvidenceLevel.strong,
      iconName: 'bedtime',
      evidenceDistribution: {
        'strong': 1,
        'emerging': 1,
        'possible': 0,
        'unsupported': 0,
      },
      connectionsCount: 2,
      tags: ['sleep', 'circadian', 'glymphatic', 'neurology', 'lateral_posture'],
      relatedAyahKeys: ['30:23'],
      relatedHadithIds: ['abudawud:5040'],
      researchPaperIds: ['paper_sleep_neurology_2021'],
      relatedTopicIds: ['fasting_autophagy', 'human_psychology'],
      featured: false,
    ),
    const ScientificTopic(
      id: 'fasting_autophagy',
      title: 'Intermittent Fasting & Cellular Autophagy',
      category: '🧘 Fasting',
      summary:
          'Metabolic switching during extended fasting, induction of lysosomal autophagy, attenuation of systemic inflammation, and cellular rejuvenation.',
      description:
          'Fasting prompts the metabolic transition from glucose utilization to fatty-acid mobilization and ketone body production. Extended absence of dietary intake stimulates autophagy—a conserved cellular mechanism whereby cells degrade and recycle dysfunctional organelles, misfolded proteins, and intracellular pathogens.',
      islamicPerspective:
          'Decreed in Surah Al-Baqarah (2:183-184) as a universal spiritual discipline: "And that you fast is better for you, if you only knew." The Prophet Muhammad (peace be upon him) observed weekly intermittent fasts on Mondays and Thursdays, and described fasting as a protective shield (Bukhari 1904).',
      scientificExplanation:
          'Depletion of liver glycogen (typically after 12-16 hours of fasting) down-regulates mTOR kinase and up-regulates AMPK, initiating autophagic vacuole assembly. This cellular "housekeeping" reduces oxidative stress markers, enhances insulin sensitivity, and promotes neuroplasticity via brain-derived neurotrophic factor (BDNF).',
      whatResearchSays:
          'Dr. Yoshinori Ohsumi was awarded the 2016 Nobel Prize in Physiology or Medicine for elucidating the molecular mechanisms of autophagy. Extensive clinical trials confirm that periodic fasting schedules reduce markers of cardiovascular disease, systemic inflammation (CRP), and metabolic syndrome.',
      evidenceLevel: EvidenceLevel.strong,
      iconName: 'timer',
      evidenceDistribution: {
        'strong': 2,
        'emerging': 1,
        'possible': 0,
        'unsupported': 0,
      },
      connectionsCount: 3,
      tags: ['fasting', 'autophagy', 'metabolism', 'insulin_sensitivity', 'ketones'],
      relatedAyahKeys: ['2:183', '2:184'],
      relatedHadithIds: ['bukhari:1904'],
      researchPaperIds: ['paper_ohsumi_2016', 'paper_mattson_2018'],
      relatedTopicIds: ['nutrition_moderation', 'sleep_circadian'],
      featured: true,
    ),
    const ScientificTopic(
      id: 'nutrition_moderation',
      title: 'Nutrition, Gut Microbiome & Moderation',
      category: '🍎 Nutrition',
      summary:
          'Gastric volumetric regulation (the one-third rule), microbial gut diversity, anti-inflammatory dietary staples, and preventive gastroenterology.',
      description:
          'Nutritional science has established that over-nutrition and chronic gastric distension are primary drivers of gastroesophageal reflux disease, leptin resistance, chronic low-grade inflammation, and gut dysbiosis. Modulating caloric density and meal volume supports microbiome diversity and longevity.',
      islamicPerspective:
          'The Prophetic tradition explicitly warns against gastric over-filling (Tirmidhi 2380): "One third for food, one third for drink, one third for air." Prophetic dietary traditions highlighted honey, dates, olive oil, and barley as wholesome sustenance.',
      scientificExplanation:
          'Limiting meal size to roughly two-thirds of maximal anatomical capacity maintains intra-gastric pressures below the lower esophageal sphincter closing threshold. Bioactive polyphenols and oligosaccharides in traditional fruits act as prebiotics, fostering Akkermansia muciniphila and Bifidobacterium populations in the gut.',
      whatResearchSays:
          'Clinical gastroenterology trials uniformly validate that restricting bolus meal sizes alleviates dyspepsia, enhances postprandial glycemic control, and prevents chronic hepatic steatosis.',
      evidenceLevel: EvidenceLevel.strong,
      iconName: 'restaurant',
      evidenceDistribution: {
        'strong': 1,
        'emerging': 1,
        'possible': 0,
        'unsupported': 0,
      },
      connectionsCount: 2,
      tags: ['nutrition', 'microbiome', 'gastric_distension', 'moderation', 'gut_brain'],
      relatedAyahKeys: [],
      relatedHadithIds: ['tirmidhi:2380', 'bukhari:5688'],
      researchPaperIds: ['paper_nutrition_gut_2022'],
      relatedTopicIds: ['fasting_autophagy', 'human_psychology'],
      featured: false,
    ),
    const ScientificTopic(
      id: 'prefrontal_cortex',
      title: 'Human Psychology & Prefrontal Function',
      category: '🧠 Psychology',
      summary:
          'Neuroanatomical roles of the frontopolar prefrontal cortex in moral conflict, intentional lying, impulse inhibition, and executive self-regulation.',
      description:
          'Cognitive neuroscience locates executive control, intentional deceit, abstract moral reasoning, and voluntary inhibition within the anterior prefrontal cortex (Brodmann Area 10) and orbitofrontal regions directly situated behind the human forehead.',
      islamicPerspective:
          'Surah Al-\'Alaq (96:15-16) describes the stubborn defiance of the transgressor with the phrase: "A lying, sinning forelock (Nasiyah kâdhibah khâti\'ah)", attributing deceit and moral responsibility directly to the front of the head.',
      scientificExplanation:
          'Functional neuroimaging (fMRI) reveals significant selective activation in the frontopolar cortex and anterior cingulate when human subjects engage in deliberate deception versus baseline truth-telling. The prefrontal cortex orchestrates the suppression of spontaneous truthful recall in favor of fabricated narratives.',
      whatResearchSays:
          'While linguistic parallels are compelling, neuroscientists and theologians note that prefrontal localization is a descriptive biological substrate of consciousness rather than a mathematical proof of divine revelation.',
      evidenceLevel: EvidenceLevel.emerging,
      iconName: 'psychology',
      evidenceDistribution: {
        'strong': 0,
        'emerging': 2,
        'possible': 0,
        'unsupported': 0,
      },
      connectionsCount: 2,
      tags: ['neuroscience', 'prefrontal_cortex', 'nasiyah', 'deception', 'executive_control'],
      relatedAyahKeys: ['96:15', '96:16'],
      relatedHadithIds: [],
      researchPaperIds: ['paper_prefrontal_deception_2017'],
      relatedTopicIds: ['sleep_circadian', 'fasting_autophagy'],
      featured: true,
    ),
    const ScientificTopic(
      id: 'environment_conservation',
      title: 'Environmental Conservation & Cosmic Balance',
      category: '🌱 Environment',
      summary:
          'Ecological stewardship (Khilafah), conservation of freshwater resources, and maintaining the dynamic environmental equilibrium (Mizan).',
      description:
          'Earth\'s ecosystems function as deeply interconnected biogeochemical systems whose dynamic equilibrium (homeostasis) depends on carbon, nitrogen, and hydrological cycling. Anthropogenic degradation threatens this systemic balance.',
      islamicPerspective:
          'The Quran commands humanity to observe the Mizan (Balance) in Surah Ar-Rahman (55:7-9): "He raised the sky and set up the balance, that you do not transgress the balance." The Prophet Muhammad forbade wasting water even when performing ablution at a flowing river.',
      scientificExplanation:
          'Ecological balance reflects thermodynamic dissipative structures maintaining stable biomass and biodiversity under steady planetary boundaries. Disruption of key trophic links causes trophic cascades and habitat collapse.',
      whatResearchSays:
          'Environmental science literature underscores the necessity of ethical, long-term conservation paradigms. Islamic environmental principles provide an intrinsic theological framework for environmental stewardship.',
      evidenceLevel: EvidenceLevel.strong,
      iconName: 'eco',
      evidenceDistribution: {
        'strong': 2,
        'emerging': 0,
        'possible': 0,
        'unsupported': 0,
      },
      connectionsCount: 2,
      tags: ['ecology', 'mizan', 'conservation', 'stewardship', 'biodiversity'],
      relatedAyahKeys: ['2:164', '55:19'],
      relatedHadithIds: [],
      researchPaperIds: ['paper_ocean_internal_waves_2019'],
      relatedTopicIds: ['water_oceans', 'mountains_isostasy'],
      featured: false,
    ),
    const ScientificTopic(
      id: 'cosmic_expansion',
      title: 'Astronomy & The Expanding Universe',
      category: '🌌 Universe',
      summary:
          'Examining the cosmological expansion of the universe (Hubble-Lemaître Law) alongside classical Arabic linguistic interpretations of Surah Adh-Dhariyat (51:47).',
      description:
          'Modern astrophysics demonstrates that spacetime metric expansion drives galaxies apart at velocities proportional to their distance (Hubble-Lemaître Law), confirmed by cosmological redshift observations and the cosmic microwave background (CMB).',
      islamicPerspective:
          'Surah Adh-Dhariyat (51:47) states: "And the heaven We constructed with strength, and indeed, We are [its] expander (wa innā la-mūsi‘ūn)." Classical Arabic lexicons explain "mūsi‘ūn" as possessing vast capacity, power, and continual expanse.',
      scientificExplanation:
          'General relativity field equations allow for non-static spacetime geometries. Observational data gathered from the Hubble Space Telescope and James Webb Space Telescope confirm that the universe is not only expanding but undergoing accelerated expansion driven by dark energy.',
      whatResearchSays:
          'Physicists and linguists note that while "mūsi‘ūn" resonates remarkably with cosmological expansion, historical exegetes interpreted the verse primarily as God\'s vast abundance and celestial magnitude.',
      evidenceLevel: EvidenceLevel.emerging,
      iconName: 'all_inclusive',
      evidenceDistribution: {
        'strong': 0,
        'emerging': 2,
        'possible': 1,
        'unsupported': 0,
      },
      connectionsCount: 2,
      tags: ['astronomy', 'expansion', 'redshift', 'hubble', 'cosmology'],
      relatedAyahKeys: ['51:47', '21:33'],
      relatedHadithIds: [],
      researchPaperIds: ['paper_cosmic_metric_2020'],
      relatedTopicIds: ['creation_origin', 'mountains_isostasy'],
      featured: false,
    ),
    const ScientificTopic(
      id: 'creation_origin',
      title: 'Creation, Singularity & Aqueous Origin of Life',
      category: '🌌 Universe',
      summary:
          'Cosmological singularity models ("ratqan wa fatqan") and the universal molecular dependence of all biological life on water.',
      description:
          'Cosmology posits that the observable universe originated from an intensely hot, dense primordial state approximately 13.8 billion years ago. Simultaneously, biochemistry identifies water as the indispensable universal solvent without which macromolecular biological life cannot exist.',
      islamicPerspective:
          'Surah Al-Anbya (21:30) inquires: "Have those who disbelieved not considered that the heavens and the earth were a joined entity, and then We separated them and made from water every living thing? Then will they not believe?"',
      scientificExplanation:
          'All known cellular metabolisms occur in aqueous solutions. Water\'s unique polar hydrogen bonding, thermal capacity, and dielectric constant enable protein folding, nucleic acid stability, and membrane formation.',
      whatResearchSays:
          'Biochemists and astrobiologists regard water as the defining signature for extraterrestrial habitability. The Quranic assertion that every living thing was fashioned from water is universally corroborated by cellular biology.',
      evidenceLevel: EvidenceLevel.possible,
      iconName: 'flare',
      evidenceDistribution: {
        'strong': 1,
        'emerging': 1,
        'possible': 1,
        'unsupported': 0,
      },
      connectionsCount: 2,
      tags: ['creation', 'singularity', 'big_bang', 'water_origin', 'protoplasm'],
      relatedAyahKeys: ['21:30'],
      relatedHadithIds: [],
      researchPaperIds: ['paper_cosmic_metric_2020'],
      relatedTopicIds: ['water_oceans', 'cosmic_expansion'],
      featured: false,
    ),
    const ScientificTopic(
      id: 'mountains_isostasy',
      title: 'Mountains, Pegs & Crustal Isostasy',
      category: '⛰️ Mountains',
      summary:
          'Geological Airy-Heiskanen isostasy, deep lithospheric mountain roots, and their role in stabilizing continental crust against tectonic deformational forces.',
      description:
          'Plate tectonics and geophysics demonstrate that mountains are not merely superficial topographical features; they possess deep crustal roots projecting down into the asthenosphere, obeying Archimedean hydrostatic buoyancy principles (isostasy).',
      islamicPerspective:
          'Surah An-Naba (78:6-7) asks: "Have We not made the earth a resting place, and the mountains as pegs (Awtad)?" The Arabic word "watad" (plural "awtad") refers to a tent peg driven deeply into the ground with the larger portion hidden subterraneanly.',
      scientificExplanation:
          'Under high orogenic ranges such as the Himalayas or Alps, the continental crust deepens from an average 35 km to upwards of 70 km beneath the surface, functioning as stabilizing roots preventing crustal shear and gravitational collapse.',
      whatResearchSays:
          'Geologists note that while mountains possess deep roots and contribute to regional isostatic equilibrium, they are formed by dynamic tectonic collision zones that are themselves seismically active. Thus, the peg metaphor highlights subsurface geometry rather than absolute seismic immobility.',
      evidenceLevel: EvidenceLevel.possible,
      iconName: 'terrain',
      evidenceDistribution: {
        'strong': 0,
        'emerging': 1,
        'possible': 1,
        'unsupported': 0,
      },
      connectionsCount: 1,
      tags: ['geology', 'mountains', 'isostasy', 'crustal_roots', 'awtad'],
      relatedAyahKeys: ['78:6', '78:7'],
      relatedHadithIds: [],
      researchPaperIds: ['paper_geological_isostasy_2020'],
      relatedTopicIds: ['environment_conservation', 'water_oceans'],
      featured: false,
    ),
    const ScientificTopic(
      id: 'debunked_speed_of_light',
      title: 'Debunked: Speed of Light Formula Myth',
      category: '⚠️ Myth-Buster',
      summary:
          'A transparent, scholarly breakdown demonstrating why popular internet formulas attempting to calculate the exact speed of light from Surah As-Sajdah (32:5) are mathematically flawed and epistemologically unsound.',
      description:
          'In recent decades, popular internet apologetics claimed that calculating the distance traveled by the moon in 1,000 lunar orbits divided by 1,000 Earth days yields the exact speed of light. Rigorous physical and theological scrutiny reveals that this formula relies on arbitrary cherry-picking of orbital frameworks and misrepresents classical Quranic semantics.',
      islamicPerspective:
          'Surah As-Sajdah (32:5) speaks of God regulating all affairs from heaven to earth, which ascend in a Day the extent of which is a thousand human years. Classical exegetes universally understood this as an idiom for vast celestial distance and divine transcendence, not a mathematical equation for photons.',
      scientificExplanation:
          'The apologetic calculation selectively uses sidereal lunar orbits for distance while multiplying by synodic periods, introducing circular adjustments and disregarding gravitational time dilation, orbital eccentricity, and precession.',
      whatResearchSays:
          'Muslim astrophysicists (including Prof. Nidhal Guessoum) have published rigorous critiques warning against forced concordism. Epistemological integrity requires rejecting pseudo-scientific claims that compromise academic and Islamic scholarly credibility.',
      evidenceLevel: EvidenceLevel.unsupported,
      iconName: 'cancel',
      evidenceDistribution: {
        'strong': 0,
        'emerging': 0,
        'possible': 0,
        'unsupported': 1,
      },
      connectionsCount: 1,
      tags: ['myth_buster', 'speed_of_light', 'apologetics', 'critical_thinking', 'epistemology'],
      relatedAyahKeys: ['32:5'],
      relatedHadithIds: [],
      researchPaperIds: ['paper_critical_epistemology_2021'],
      relatedTopicIds: ['cosmic_expansion'],
      featured: true,
    ),
  ];

  static final List<ResearchPaper> _papers = [
    const ResearchPaper(
      id: 'paper_moore_1982',
      title: 'A Scientist\'s Interpretation of References to Embryology in the Qur\'an',
      authors: ['Keith L. Moore, Ph.D., F.I.A.C.'],
      journal: 'Journal of the Islamic Medical Association',
      publicationYear: 1982,
      doi: '10.5915/14-2-12345',
      sourceUrl: 'https://jima.imana.org/article/view/moore-embryology',
      abstractSummary:
          'Analysis correlating early human morphogenetic milestones with 7th-century descriptions in the Quran, specifically comparing the somite development stage with the \'chewed lump\' (Mudghah) description.',
      methodology: 'Comparative Morphological Analysis',
      field: 'Embryology & Developmental Biology',
      isPeerReviewed: true,
      isMockDemo: true,
    ),
    const ResearchPaper(
      id: 'paper_persaud_1992',
      title: 'Early Human Morphogenesis in Historical and Textual Perspective',
      authors: ['T.V.N. Persaud, M.D., Ph.D., D.Sc.'],
      journal: 'Journal of Anatomical Sciences',
      publicationYear: 1992,
      doi: '10.1002/ar.109282',
      sourceUrl: 'https://doi.org/10.1002/ar.109282',
      abstractSummary:
          'Examination of early embryological terminologies across antiquity, exploring Greek, Indian, and Arabic textual traditions regarding prenatal human staging.',
      methodology: 'Historical Anatomical Review',
      field: 'Embryology & Developmental Biology',
      isPeerReviewed: true,
      isMockDemo: true,
    ),
    const ResearchPaper(
      id: 'paper_ohsumi_2016',
      title: 'Molecular Mechanisms of Autophagy and Fasting-Induced Lysosomal Recycling',
      authors: ['Yoshinori Ohsumi, Ph.D.'],
      journal: 'Nature Cell Biology',
      publicationYear: 2016,
      doi: '10.1038/ncb.2016.32',
      sourceUrl: 'https://doi.org/10.1038/ncb.2016.32',
      abstractSummary:
          'Landmark investigation detailing the genetic machinery and signaling cascades regulating autophagic vacuole formation during nutrient deprivation in eukaryotic cells.',
      methodology: 'Molecular Genetics & Cell Biology',
      field: 'Cellular Biology & Genetics',
      isPeerReviewed: true,
      isMockDemo: true,
    ),
    const ResearchPaper(
      id: 'paper_mattson_2018',
      title: 'Intermittent Metabolic Switching, Neuroplasticity and Brain Health',
      authors: ['Mark P. Mattson, Ph.D.', 'Valter D. Longo, Ph.D.'],
      journal: 'Nature Reviews Neuroscience',
      publicationYear: 2018,
      doi: '10.1038/nrn.2017.156',
      sourceUrl: 'https://doi.org/10.1038/nrn.2017.156',
      abstractSummary:
          'Reviews cellular and systemic responses to periodic caloric restriction, demonstrating BDNF up-regulation, cellular stress resistance, and cognitive enhancement.',
      methodology: 'Systematic Neurobiological Review',
      field: 'Neuroscience & Metabolism',
      isPeerReviewed: true,
      isMockDemo: true,
    ),
    const ResearchPaper(
      id: 'paper_sleep_neurology_2021',
      title: 'Right Lateral Sleep Position and Glymphatic Clearance Optimization',
      authors: ['Hedok Lee, Ph.D.', 'Maiken Nedergaard, M.D., Ph.D.'],
      journal: 'Journal of Neuroscience',
      publicationYear: 2021,
      doi: '10.1523/JNEUROSCI.2021.09',
      sourceUrl: 'https://doi.org/10.1523/JNEUROSCI.2021.09',
      abstractSummary:
          'Dynamic optical imaging and MRI study comparing cerebrospinal fluid tracer transport across lateral, supine, and prone sleep postures.',
      methodology: 'Preclinical In Vivo Neuroimaging',
      field: 'Neuroscience & Sleep Medicine',
      isPeerReviewed: true,
      isMockDemo: true,
    ),
    const ResearchPaper(
      id: 'paper_ocean_internal_waves_2019',
      title: 'Subsurface Density Stratification and Solitary Internal Waves in Deep Marine Basins',
      authors: ['Karl R. Helfrich, Ph.D.', 'Melvin G. Jackson, Ph.D.'],
      journal: 'Annual Review of Fluid Mechanics',
      publicationYear: 2019,
      doi: '10.1146/annurev.fluid.2019',
      sourceUrl: 'https://doi.org/10.1146/annurev.fluid.2019',
      abstractSummary:
          'Physical investigation into nonlinear internal solitary wave propagation generated along thermoclines in stratified marine channels.',
      methodology: 'Hydrodynamic Field Observation & Modeling',
      field: 'Oceanography & Earth Sciences',
      isPeerReviewed: true,
      isMockDemo: true,
    ),
    const ResearchPaper(
      id: 'paper_nutrition_gut_2022',
      title: 'Caloric Moderation, Gastric Distension, and Gut-Brain Peptide Signalling',
      authors: ['Eamonn M. Quigley, M.D., FRCP'],
      journal: 'Gastroenterology Clinics',
      publicationYear: 2022,
      doi: '10.1016/j.gtc.2022.04',
      sourceUrl: 'https://doi.org/10.1016/j.gtc.2022.04',
      abstractSummary:
          'Investigates the physiological impact of meal volume on lower esophageal competence, ghrelin cessation thresholds, and short-chain fatty acid microbiome fermentation.',
      methodology: 'Clinical Human Trial',
      field: 'Gastroenterology & Nutrition',
      isPeerReviewed: true,
      isMockDemo: true,
    ),
    const ResearchPaper(
      id: 'paper_prefrontal_deception_2017',
      title: 'Neural Correlates of Intentional Deception: An fMRI Prefrontal Lobe Analysis',
      authors: ['Giorgio Ganis, Ph.D.', 'Stephen M. Kosslyn, Ph.D.'],
      journal: 'NeuroImage',
      publicationYear: 2017,
      doi: '10.1016/j.neuroimage.2017.02',
      sourceUrl: 'https://doi.org/10.1016/j.neuroimage.2017.02',
      abstractSummary:
          'Neuroimaging study isolating executive activity in the frontopolar cortex and anterior cingulate during the production of spontaneous versus deliberate lies.',
      methodology: 'Functional Magnetic Resonance Imaging (fMRI)',
      field: 'Cognitive Neuroscience & Psychology',
      isPeerReviewed: true,
      isMockDemo: true,
    ),
    const ResearchPaper(
      id: 'paper_cosmic_metric_2020',
      title: 'Precision Cosmology and the Accelerating Expansion Rate of Spacetime',
      authors: ['Adam G. Riess, Ph.D.', 'Brian P. Schmidt, Ph.D.'],
      journal: 'The Astrophysical Journal',
      publicationYear: 2020,
      doi: '10.3847/1538-4357',
      sourceUrl: 'https://doi.org/10.3847/1538-4357',
      abstractSummary:
          'Observational measurements using Type Ia supernovae and Cepheid variable stars providing high-precision constraints on the Hubble constant and cosmic metric expansion.',
      methodology: 'Astrophysical Observation & Photometry',
      field: 'Astrophysics & Cosmology',
      isPeerReviewed: true,
      isMockDemo: true,
    ),
    const ResearchPaper(
      id: 'paper_geological_isostasy_2020',
      title: 'Crustal Thickness, Moho Depth Variations and Isostatic Roots in Orogenic Belts',
      authors: ['Peter Molnar, Ph.D.', 'Paul Tapponnier, Ph.D.'],
      journal: 'Tectonophysics',
      publicationYear: 2020,
      doi: '10.1016/j.tecto.2020',
      sourceUrl: 'https://doi.org/10.1016/j.tecto.2020',
      abstractSummary:
          'Seismic reflection and gravity anomaly data detailing deep lithospheric roots beneath major continental collision mountain ranges supporting Airy isostatic balance.',
      methodology: 'Seismic Reflection & Gravimetric Modeling',
      field: 'Geophysics & Tectonics',
      isPeerReviewed: true,
      isMockDemo: true,
    ),
    const ResearchPaper(
      id: 'paper_critical_epistemology_2021',
      title: 'Methodological Fallacies in Concordist Numerology: The Speed of Light Case Study',
      authors: ['Nidhal Guessoum, Ph.D.'],
      journal: 'Zygon: Journal of Religion and Science',
      publicationYear: 2021,
      doi: '10.1111/zygo.12680',
      sourceUrl: 'https://doi.org/10.1111/zygo.12680',
      abstractSummary:
          'Rigorous epistemological critique demonstrating the mathematical inconsistencies, orbital arbitrary parameters, and exegetical errors inherent in popular "Speed of Light in Quran" claims.',
      methodology: 'Critical Methodological Analysis',
      field: 'Epistemology & Science-Religion Dialogue',
      isPeerReviewed: true,
      isMockDemo: true,
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
      headline: 'Sequential Embryogenesis & Carnegie Staging (23:14)',
      explanation:
          'The chronological sequence outlined—from fluid (Nutfah), to suspended clinging mass (\'Alaqah), to indented tissue (Mudghah), to skeletal framework (\'Izam), and muscular wrapping (Lahm)—mirrors the sequential Carnegie Stages of human development.',
      classicalTafseer:
          'Ibn Kathir notes that the progression describes morphological phases where each state is followed by a structural transformation.',
      scientificConsensus:
          'Somite appearance and subsequent chondrogenic differentiation of limb buds followed by myogenesis is universally documented in human embryology.',
      scholarlyCaveats:
          'These terms are qualitative visual benchmarks suited for 7th-century understanding; they should not be conflated with microscopic histological manuals.',
      paperIds: ['paper_moore_1982', 'paper_persaud_1992'],
      verifiedByScholars: true,
    ),
    const ScientificConnection(
      id: 'conn_oceanography_internal_waves',
      topicId: 'water_oceans',
      textType: IslamicTextType.quran,
      surahNumber: 24,
      ayahNumber: 40,
      ayahKey: '24:40',
      evidenceLevel: EvidenceLevel.strong,
      headline: 'Deep Marine Internal Stratification & Aphotic Darkness (24:40)',
      explanation:
          'The verse specifically details "waves upon waves" in an unfathomable deep sea, matching the physical reality of subsurface internal waves operating along density interfaces beneath surface waves.',
      classicalTafseer:
          'Al-Tabari describes layered depths where upper turbulence is superimposed upon deeper subterranean ocean disturbances.',
      scientificConsensus:
          'Internal waves are fundamental oceanographic phenomena occurring along pycnoclines in all stratified oceanic basins.',
      scholarlyCaveats:
          'The verse serves primarily as a theological metaphor for compounding spiritual blindness rather than an oceanography textbook.',
      paperIds: ['paper_ocean_internal_waves_2019'],
      verifiedByScholars: true,
    ),
    const ScientificConnection(
      id: 'conn_water_halocline',
      topicId: 'water_oceans',
      textType: IslamicTextType.quran,
      surahNumber: 55,
      ayahNumber: 20,
      ayahKey: '55:20',
      evidenceLevel: EvidenceLevel.strong,
      headline: 'The Dynamic Halocline Barrier Between Adjacent Waters (55:20)',
      explanation:
          'The barrier (Barzakh) between two meeting bodies of water corresponds to density, salinity, and temperature gradients that maintain boundary stratification.',
      classicalTafseer:
          'Al-Qurtubi explains the Barzakh as an invisible dividing limit ordained by God preventing one water body from immediately overwhelming the other.',
      scientificConsensus:
          'Haloclines and pycnoclines act as hydrodynamic barriers maintaining water mass integrity in straits and estuarine fronts.',
      scholarlyCaveats:
          'Waters do slowly mix at the interface over time; the barrier is a dynamic physical equilibrium, not an impervious stone wall.',
      paperIds: ['paper_ocean_internal_waves_2019'],
      verifiedByScholars: true,
    ),
    const ScientificConnection(
      id: 'conn_sleep_circadian',
      topicId: 'sleep_circadian',
      textType: IslamicTextType.hadith,
      hadithCollection: 'abudawud',
      hadithNumber: '5040',
      evidenceLevel: EvidenceLevel.strong,
      headline: 'Right Lateral Decubitus Posture & Neuro-Hemodynamics',
      explanation:
          'The Prophetic recommendation to sleep on the right side corresponds to optimal cardiac positioning, reduced mediastinal pressure, and enhanced glymphatic waste clearance.',
      classicalTafseer:
          'Ibn al-Qayyim highlighted that resting on the right side prevents deep respiratory torpor and keeps the heart relaxed without compression.',
      scientificConsensus:
          'Lateral sleep posture enhances cerebrospinal fluid clearance of neurotoxic metabolic byproducts compared to supine positioning.',
      scholarlyCaveats:
          'Sleep posture is a sunnah hygiene recommendation; occasional turning during sleep is natural and physiologically necessary.',
      paperIds: ['paper_sleep_neurology_2021'],
      verifiedByScholars: true,
    ),
    const ScientificConnection(
      id: 'conn_fasting_autophagy',
      topicId: 'fasting_autophagy',
      textType: IslamicTextType.quran,
      surahNumber: 2,
      ayahNumber: 184,
      ayahKey: '2:184',
      evidenceLevel: EvidenceLevel.strong,
      headline: 'Metabolic Rejuvenation & Autophagy Induced by Fasting (2:184)',
      explanation:
          'Fasting triggers cellular recycling and metabolic switching from glucose to ketones, activating protective autophagy.',
      classicalTafseer:
          'Scholars emphasize that the divine phrase "and that you fast is better for you" encompasses comprehensive physical and spiritual purification.',
      scientificConsensus:
          'Fasting periods exceeding 12-16 hours systematically up-regulate autophagic flux and lower chronic inflammatory biomarkers.',
      scholarlyCaveats:
          'Fasting must be conducted responsibly; individuals with certain metabolic illnesses are exempt under Islamic jurisprudence.',
      paperIds: ['paper_ohsumi_2016', 'paper_mattson_2018'],
      verifiedByScholars: true,
    ),
    const ScientificConnection(
      id: 'conn_prefrontal_cortex_96_16',
      topicId: 'prefrontal_cortex',
      textType: IslamicTextType.quran,
      surahNumber: 96,
      ayahNumber: 16,
      ayahKey: '96:16',
      evidenceLevel: EvidenceLevel.emerging,
      headline: 'Prefrontal Cortical Function & Executive Deception (96:16)',
      explanation:
          'The attribution of deliberate deceit and sinful transgression directly to the forelock (Nasiyah) correlates with the role of the anterior prefrontal cortex in executive decision-making and deceit.',
      classicalTafseer:
          'Ibn Kathir notes that the person who lies is called by his forelock because that is the most prominent crown of pride and voluntary action.',
      scientificConsensus:
          'fMRI studies consistently show elevated metabolic activity in the frontopolar cortex and anterior cingulate when formulating deceit.',
      scholarlyCaveats:
          'The Quran uses the forelock (Nasiyah) as an idiom of dignity and control; attributing an exact Brodmann Area mapping is a modern conceptual parallel.',
      paperIds: ['paper_prefrontal_deception_2017'],
      verifiedByScholars: true,
    ),
    const ScientificConnection(
      id: 'conn_cosmic_expansion_51_47',
      topicId: 'cosmic_expansion',
      textType: IslamicTextType.quran,
      surahNumber: 51,
      ayahNumber: 47,
      ayahKey: '51:47',
      evidenceLevel: EvidenceLevel.emerging,
      headline: 'Cosmological Spacetime Metric Expansion (51:47)',
      explanation:
          'The description of the cosmos being continuously expanded ("wa innā la-mūsi‘ūn") parallels contemporary relativistic expansion models.',
      classicalTafseer:
          'Al-Razi and classical lexicons recognize "mūsi‘ūn" as continuous expanse, power, and boundless capacity.',
      scientificConsensus:
          'Spacetime is undergoing accelerated metric expansion as verified by cosmic microwave background and standard candle observations.',
      scholarlyCaveats:
          'Classical exegetes also interpreted the term as divine omnipotence and vast richness; linguistic concordance should not replace theological meaning.',
      paperIds: ['paper_cosmic_metric_2020'],
      verifiedByScholars: true,
    ),
    const ScientificConnection(
      id: 'conn_mountains_isostasy',
      topicId: 'mountains_isostasy',
      textType: IslamicTextType.quran,
      surahNumber: 78,
      ayahNumber: 7,
      ayahKey: '78:7',
      evidenceLevel: EvidenceLevel.possible,
      headline: 'Mountains as Stabilizing Pegs with Deep Roots (78:7)',
      explanation:
          'The peg metaphor (Awtad) corresponds to subterranean crustal roots beneath orogenic belts according to Airy isostatic equilibrium.',
      classicalTafseer:
          'Classical commentators like Al-Jalalayn remark that mountains stabilize the earth so that it does not shake beneath its inhabitants.',
      scientificConsensus:
          'Mountains have deep crustal roots extending into the mantle. However, mountain belts are themselves tectonic boundaries with recurrent seismic activity.',
      scholarlyCaveats:
          'Describing mountains as pegs refers to their anchoring geometry; claims that mountains prevent all earthquakes are geologically incorrect.',
      paperIds: ['paper_geological_isostasy_2020'],
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
      headline: 'Debunked: Invalidation of "Speed of Light in Quran" Numerology',
      explanation:
          'Popular internet calculations claiming Surah 32:5 reveals the speed of light are based on inconsistent lunar orbital constants and circular mathematical assumptions.',
      classicalTafseer:
          'Classical scholars universally understand 32:5 as an expression of divine transcendence across earthly human time, not a physics formula.',
      scientificConsensus:
          'Astrophysicists and academic Muslim scholars dismiss the calculation as pseudo-scientific concordism.',
      scholarlyCaveats:
          'Maintaining academic integrity requires rejecting unfounded numeric claims.',
      paperIds: ['paper_critical_epistemology_2021'],
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

  @override
  Future<List<ResearchPaper>> getAllResearchPapers() async {
    return _papers;
  }

  @override
  Future<List<ResearchPaper>> searchResearchPapers(String query, {String? field, int? minYear}) async {
    final lower = query.toLowerCase();
    return _papers.where((p) {
      final matchesQuery = query.isEmpty ||
          p.title.toLowerCase().contains(lower) ||
          p.abstractSummary.toLowerCase().contains(lower) ||
          p.authors.any((a) => a.toLowerCase().contains(lower)) ||
          p.journal.toLowerCase().contains(lower);
      final matchesField = field == null || field == 'All' || p.field.toLowerCase().contains(field.toLowerCase());
      final matchesYear = minYear == null || p.publicationYear >= minYear;
      return matchesQuery && matchesField && matchesYear;
    }).toList();
  }
}
