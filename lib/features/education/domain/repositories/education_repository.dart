import '../entities/sunnah_practice.dart';

abstract class EducationRepository {
  Future<SunnahPractice> getSunnahDrinkingPractice();
  Future<List<SunnahPractice>> getAllSunnahPractices();
}
