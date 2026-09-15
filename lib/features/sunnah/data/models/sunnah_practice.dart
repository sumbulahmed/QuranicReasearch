import '../../../../core/models/evidence_level.dart';
import '../../../science/domain/entities/research_paper.dart';
import 'hadith_reference.dart';
import 'scientific_insight.dart';
import 'sunnah_step.dart';

class SunnahPractice {
  final String id;
  final String title;
  final String arabicTitle;
  final String description;
  final String category;
  final String categoryArabic;
  final List<HadithReference> hadithReferences;
  final List<SunnahStep> steps;
  final String? scientificPerspective;
  final List<ScientificInsight> scientificInsights;
  final List<ResearchPaper> researchStudies;
  final EvidenceLevel evidenceLevel;
  final String evidenceExplanation;
  final String? videoAsset;
  final List<String> keywords;

  // Child-friendly mode fields
  final String? childTitle;
  final String? childDescription;
  final List<String>? childSteps;
  final String? childSafetyNote;

  const SunnahPractice({
    required this.id,
    required this.title,
    required this.arabicTitle,
    required this.description,
    required this.category,
    required this.categoryArabic,
    required this.hadithReferences,
    required this.steps,
    this.scientificPerspective,
    this.scientificInsights = const [],
    this.researchStudies = const [],
    this.evidenceLevel = EvidenceLevel.possible,
    this.evidenceExplanation = '',
    this.videoAsset,
    this.keywords = const [],
    this.childTitle,
    this.childDescription,
    this.childSteps,
    this.childSafetyNote,
  });

  bool get hasScience =>
      scientificPerspective != null &&
      scientificPerspective!.trim().isNotEmpty &&
      (scientificInsights.isNotEmpty || researchStudies.isNotEmpty);
}
