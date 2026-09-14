import '../entities/surah.dart';
import '../entities/ayah.dart';

abstract class QuranRepository {
  Future<List<Surah>> getAllSurahs();
  Future<Surah?> getSurahByNumber(int surahNumber);
  Future<List<Ayah>> getAyahsForSurah(int surahNumber);
  Future<Ayah?> getAyah(int surahNumber, int ayahNumber);
  Future<List<Ayah>> searchAyahs(String query);
}
