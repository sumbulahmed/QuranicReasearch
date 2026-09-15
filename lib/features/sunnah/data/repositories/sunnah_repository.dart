import '../models/sunnah_category.dart';
import '../models/sunnah_practice.dart';

abstract class SunnahRepository {
  Future<List<SunnahPractice>> getSunnahList({String? category, String? query});
  Future<SunnahPractice?> getSunnahById(String id);
  Future<SunnahPractice> getFeaturedSunnah();
  Future<List<SunnahCategory>> getCategories();
}
