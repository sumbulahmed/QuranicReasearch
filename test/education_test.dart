import 'package:flutter_test/flutter_test.dart';
import 'package:quranic_research/core/models/evidence_level.dart';
import 'package:quranic_research/features/education/data/repositories/mock_education_repository.dart';

void main() {
  group('Sunnah of Drinking Water Feature Tests', () {
    late MockEducationRepository repository;

    setUp(() {
      repository = MockEducationRepository();
    });

    test('Loads authentic Sunnah practice data', () async {
      final practice = await repository.getSunnahDrinkingPractice();

      expect(practice.id, 'sunnah_drinking_water');
      expect(practice.titleEnglish, 'The Sunnah of Drinking Water');
      expect(practice.titleArabic, 'سُنَّةُ الشُّرْبِ');
      expect(practice.evidenceLevel, EvidenceLevel.moderate);
      expect(practice.evidenceLevel.label, 'Moderate / Contextual Evidence');
    });

    test('Contains exactly 9 practice steps with valid volume levels', () async {
      final practice = await repository.getSunnahDrinkingPractice();

      expect(practice.steps.length, 9);
      expect(practice.steps[0].title, 'Sit comfortably');
      expect(practice.steps[1].arabicPhrase, 'بِسْمِ اللهِ');
      expect(practice.steps[8].arabicPhrase, 'الْحَمْدُ لِلَّهِ');

      // Verify water volume diminishes from 1.0 down to 0.0
      expect(practice.steps.first.waterLevel, 1.0);
      expect(practice.steps.last.waterLevel, 0.0);

      // Verify breathing intervals
      final breathingSteps = practice.steps.where((s) => s.isBreathingPhase);
      expect(breathingSteps.length, 2);
    });

    test('Contains authentic Sahih Muslim narrations with scholarly nuance', () async {
      final practice = await repository.getSunnahDrinkingPractice();

      expect(practice.hadiths.length, 3);
      expect(practice.hadiths.any((h) => h.hadithNumber == '2028a'), isTrue);
      expect(practice.hadiths.any((h) => h.hadithNumber == '2028b'), isTrue);
      expect(practice.hadiths.any((h) => h.hadithNumber == '2024a'), isTrue);

      final standingHadith = practice.hadiths.firstWhere((h) => h.hadithNumber == '2024a');
      expect(standingHadith.scholarlyNuance, contains('Sunnah encourages drinking while seated'));
    });

    test('Contains 4 verified peer-reviewed research citations with DOIs', () async {
      final practice = await repository.getSunnahDrinkingPractice();

      expect(practice.researchPapers.length, 4);
      for (final paper in practice.researchPapers) {
        expect(paper.doi, isNotNull);
        expect(paper.doi!.isNotEmpty, isTrue);
        expect(paper.isPeerReviewed, isTrue);
      }

      // Check specific verified papers
      final titles = practice.researchPapers.map((p) => p.title).toList();
      expect(titles, contains('Effect of posture on swallowing'));
      expect(titles.any((t) => t.contains('Aspiration as a Function of Age')), isTrue);
      expect(titles.any((t) => t.contains('Effect of bolus volume on pharyngeal swallowing')), isTrue);
      expect(titles.any((t) => t.contains('Coordination of respiration and swallowing')), isTrue);
    });

    test('Educational disclaimer is present and non-prescriptive', () async {
      final practice = await repository.getSunnahDrinkingPractice();

      expect(practice.educationalDisclaimer, contains('does not constitute medical advice'));
      expect(practice.scientificIntro, contains('does not establish that exactly three sips or sitting is medically necessary'));
    });
  });
}
