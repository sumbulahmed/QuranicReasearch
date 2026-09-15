import 'package:flutter_test/flutter_test.dart';
import 'package:quranic_research/core/models/evidence_level.dart';
import 'package:quranic_research/features/sunnah/data/repositories/mock_sunnah_repository.dart';

void main() {
  group('Sunnah Feature Ecosystem Tests', () {
    late MockSunnahRepository repository;

    setUp(() {
      repository = MockSunnahRepository();
    });

    test('Loads 12 distinct categories with valid counts and Arabic names', () async {
      final categories = await repository.getCategories();

      expect(categories.length, 12);
      expect(categories.any((c) => c.id == 'daily-life'), isTrue);
      expect(categories.any((c) => c.id == 'food-drink'), isTrue);
      expect(categories.any((c) => c.id == 'sleep-rest'), isTrue);
      expect(categories.any((c) => c.id == 'hygiene-purification'), isTrue);
      expect(categories.any((c) => c.id == 'speech-social'), isTrue);
      expect(categories.any((c) => c.id == 'worship-remembrance'), isTrue);

      for (final cat in categories) {
        expect(cat.name.isNotEmpty, isTrue);
        expect(cat.arabicName.isNotEmpty, isTrue);
        expect(cat.count, greaterThanOrEqualTo(0));
      }
    });

    test('Contains exactly 10 initial authentic Sunnah practices', () async {
      final practices = await repository.getSunnahList();

      expect(practices.length, 10);
      final ids = practices.map((p) => p.id).toSet();
      expect(ids.contains('drinking-water'), isTrue);
      expect(ids.contains('eating-right-hand'), isTrue);
      expect(ids.contains('eating-front'), isTrue);
      expect(ids.contains('sleep-right-side'), isTrue);
      expect(ids.contains('bismillah-before-eating'), isTrue);
      expect(ids.contains('using-miswak'), isTrue);
      expect(ids.contains('sneezing-etiquette'), isTrue);
      expect(ids.contains('greeting-salam'), isTrue);
      expect(ids.contains('smiling-charity'), isTrue);
      expect(ids.contains('moderation-eating'), isTrue);
    });

    test('Featured Sunnah is The Sunnah of Drinking Water', () async {
      final featured = await repository.getFeaturedSunnah();

      expect(featured.id, 'drinking-water');
      expect(featured.title, 'The Sunnah of Drinking Water');
      expect(featured.arabicTitle, 'سُنَّةُ الشُّرْبِ');
      expect(featured.evidenceLevel, EvidenceLevel.moderate);
    });

    test('Authentic Hadith citations adhere to scholarly standards', () async {
      final drinking = await repository.getSunnahById('drinking-water');
      expect(drinking, isNotNull);
      expect(drinking!.hadithReferences.length, 3);

      final muslim2028a = drinking.hadithReferences.firstWhere((h) => h.hadithNumber == '2028a');
      expect(muslim2028a.collection, 'Sahih Muslim');
      expect(muslim2028a.arabicText, contains('كَانَ يَتَنَفَّسُ فِي الإِنَاءِ ثَلاَثًا'));
      expect(muslim2028a.scholarlyNuance, isNotNull);

      final muslim2024a = drinking.hadithReferences.firstWhere((h) => h.hadithNumber == '2024a');
      expect(muslim2024a.scholarlyNuance, contains('Sunnah encourages drinking while seated'));
    });

    test('Scientific perspective adheres to balanced, non-exaggerated principles', () async {
      final drinking = await repository.getSunnahById('drinking-water');
      expect(drinking, isNotNull);

      // Must not claim that science proves three sips or sitting is medically necessary
      expect(
        drinking!.scientificPerspective,
        contains('does not establish that drinking in exactly three sips or while seated is medically required'),
      );
      expect(drinking.scientificInsights.isNotEmpty, isTrue);
      expect(drinking.scientificInsights.first.mechanism, contains('aerodigestive'));
      expect(drinking.scientificInsights.first.limitations, contains('Modern research studies healthy physiology'));
    });

    test('Child mode information is populated for all practices', () async {
      final practices = await repository.getSunnahList();

      for (final practice in practices) {
        expect(practice.childTitle != null && practice.childTitle!.isNotEmpty, isTrue);
        expect(practice.childDescription != null && practice.childDescription!.isNotEmpty, isTrue);
        expect(practice.childSteps != null && practice.childSteps!.isNotEmpty, isTrue);
        expect(practice.childSafetyNote != null, isTrue);
      }
    });

    test('Search filters correctly by title, Arabic, and category', () async {
      final waterResults = await repository.getSunnahList(query: 'water');
      expect(waterResults.length, 1);
      expect(waterResults.first.id, 'drinking-water');

      final arabicResults = await repository.getSunnahList(query: 'سِوَاك');
      expect(arabicResults.length, 1);
      expect(arabicResults.first.id, 'using-miswak');

      final foodResults = await repository.getSunnahList(category: 'Food & Drink');
      expect(foodResults.length, 5); // drinking-water, eating-right-hand, eating-front, bismillah, moderation
    });

    test('Handles missing ID gracefully', () async {
      final missing = await repository.getSunnahById('non-existent-id');
      expect(missing, isNull);
    });
  });
}
