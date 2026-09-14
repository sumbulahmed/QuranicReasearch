import '../entities/hadith_collection.dart';
import '../entities/hadith.dart';

abstract class HadithRepository {
  Future<List<HadithCollection>> getCollections();
  Future<HadithCollection?> getCollectionByKey(String key);
  Future<List<Hadith>> getHadithsForCollection(String collectionKey);
  Future<Hadith?> getHadith(String collectionKey, String hadithNumber);
  Future<List<Hadith>> getAllHadiths();
  Future<List<String>> getCategories();
  Future<List<Hadith>> searchHadiths(String query);
}
