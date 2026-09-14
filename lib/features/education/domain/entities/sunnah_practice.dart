import '../../../../core/models/evidence_level.dart';
import '../../../science/domain/entities/research_paper.dart';
import 'hadith_reference.dart';
import 'practice_step.dart';
import 'scientific_insight.dart';

class SunnahPractice {
  final String id;
  final String titleEnglish;
  final String titleArabic;
  final String subtitle;
  final List<HadithReference> hadiths;
  final List<PracticeStep> steps;
  final String scientificIntro;
  final List<ScientificInsight> scientificFindings;
  final EvidenceLevel evidenceLevel;
  final String evidenceExplanation;
  final List<ResearchPaper> researchPapers;
  final String educationalDisclaimer;

  const SunnahPractice({
    required this.id,
    required this.titleEnglish,
    required this.titleArabic,
    required this.subtitle,
    required this.hadiths,
    required this.steps,
    required this.scientificIntro,
    required this.scientificFindings,
    required this.evidenceLevel,
    required this.evidenceExplanation,
    required this.researchPapers,
    required this.educationalDisclaimer,
  });
}
