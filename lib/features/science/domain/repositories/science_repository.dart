import '../entities/scientific_topic.dart';
import '../entities/scientific_connection.dart';
import '../entities/research_paper.dart';

abstract class ScienceRepository {
  Future<List<ScientificTopic>> getTopics();
  Future<ScientificTopic?> getTopicById(String topicId);
  Future<List<ScientificConnection>> getConnectionsForTopic(String topicId);
  Future<List<ScientificConnection>> getConnectionsForAyah(int surahNumber, int ayahNumber);
  Future<List<ScientificConnection>> getConnectionsForHadith(String collectionKey, String hadithNumber);
  Future<ResearchPaper?> getResearchPaperById(String paperId);
  Future<List<ResearchPaper>> getResearchPapersByIds(List<String> paperIds);
}
