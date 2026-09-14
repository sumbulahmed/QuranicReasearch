import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/science/domain/repositories/science_repository.dart';
import '../../features/science/data/repositories/mock_science_repository.dart';
import '../../features/science/domain/entities/scientific_topic.dart';
import '../../features/science/domain/entities/scientific_connection.dart';
import '../../features/science/domain/entities/research_paper.dart';

import '../../features/quran/domain/repositories/quran_repository.dart';
import '../../features/quran/data/repositories/mock_quran_repository.dart';
import '../../features/quran/domain/entities/surah.dart';
import '../../features/quran/domain/entities/ayah.dart';

import '../../features/hadith/domain/repositories/hadith_repository.dart';
import '../../features/hadith/data/repositories/mock_hadith_repository.dart';
import '../../features/hadith/domain/entities/hadith_collection.dart';
import '../../features/hadith/domain/entities/hadith.dart';

import '../../features/user_library/domain/repositories/user_library_repository.dart';
import '../../features/user_library/data/repositories/mock_user_library_repository.dart';
import '../../features/user_library/domain/entities/bookmark.dart';
import '../../features/user_library/domain/entities/personal_note.dart';

// App Settings & Preferences Providers
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
final arabicFontSizeProvider = StateProvider<double>((ref) => 24.0);
final appLanguageProvider = StateProvider<String>((ref) => 'en');
final translationPreferenceProvider = StateProvider<String>((ref) => 'english');

// Repositories
final scienceRepositoryProvider = Provider<ScienceRepository>((ref) {
  return MockScienceRepository();
});

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return MockQuranRepository();
});

final hadithRepositoryProvider = Provider<HadithRepository>((ref) {
  return MockHadithRepository();
});

final userLibraryRepositoryProvider = Provider<UserLibraryRepository>((ref) {
  return MockUserLibraryRepository();
});

// Science Providers
final scientificTopicsProvider = FutureProvider<List<ScientificTopic>>((ref) async {
  final repo = ref.watch(scienceRepositoryProvider);
  return repo.getTopics();
});

final topicDetailProvider =
    FutureProvider.family<ScientificTopic?, String>((ref, topicId) async {
  final repo = ref.watch(scienceRepositoryProvider);
  return repo.getTopicById(topicId);
});

final topicConnectionsProvider =
    FutureProvider.family<List<ScientificConnection>, String>((ref, topicId) async {
  final repo = ref.watch(scienceRepositoryProvider);
  return repo.getConnectionsForTopic(topicId);
});

final ayahConnectionsProvider =
    FutureProvider.family<List<ScientificConnection>, (int, int)>((ref, tuple) async {
  final repo = ref.watch(scienceRepositoryProvider);
  return repo.getConnectionsForAyah(tuple.$1, tuple.$2);
});

final researchPapersProvider =
    FutureProvider.family<List<ResearchPaper>, List<String>>((ref, paperIds) async {
  final repo = ref.watch(scienceRepositoryProvider);
  return repo.getResearchPapersByIds(paperIds);
});

final allResearchPapersProvider = FutureProvider<List<ResearchPaper>>((ref) async {
  final repo = ref.watch(scienceRepositoryProvider);
  return repo.getAllResearchPapers();
});

// Quran Providers
final surahsListProvider = FutureProvider<List<Surah>>((ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getAllSurahs();
});

final surahDetailProvider = FutureProvider.family<Surah?, int>((ref, surahNumber) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getSurahByNumber(surahNumber);
});

final surahAyahsProvider = FutureProvider.family<List<Ayah>, int>((ref, surahNumber) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getAyahsForSurah(surahNumber);
});

final ayahDetailProvider = FutureProvider.family<Ayah?, (int, int)>((ref, tuple) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getAyah(tuple.$1, tuple.$2);
});

// Hadith Providers
final hadithCollectionsProvider = FutureProvider<List<HadithCollection>>((ref) async {
  final repo = ref.watch(hadithRepositoryProvider);
  return repo.getCollections();
});

final hadithCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(hadithRepositoryProvider);
  return repo.getCategories();
});

final allHadithsProvider = FutureProvider<List<Hadith>>((ref) async {
  final repo = ref.watch(hadithRepositoryProvider);
  return repo.getAllHadiths();
});

final collectionHadithsProvider =
    FutureProvider.family<List<Hadith>, String>((ref, collectionKey) async {
  final repo = ref.watch(hadithRepositoryProvider);
  return repo.getHadithsForCollection(collectionKey);
});

final hadithDetailProvider =
    FutureProvider.family<Hadith?, (String, String)>((ref, tuple) async {
  final repo = ref.watch(hadithRepositoryProvider);
  return repo.getHadith(tuple.$1, tuple.$2);
});

// User Library Providers
class BookmarksNotifier extends StateNotifier<AsyncValue<List<Bookmark>>> {
  final UserLibraryRepository _repo;

  BookmarksNotifier(this._repo) : super(const AsyncValue.loading()) {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    try {
      final list = await _repo.getBookmarks();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleBookmark(Bookmark bookmark) async {
    final isBookmarked = await _repo.isBookmarked(bookmark.itemId);
    if (isBookmarked) {
      await _repo.removeBookmark(bookmark.itemId);
    } else {
      await _repo.addBookmark(bookmark);
    }
    await loadBookmarks();
  }
}

final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, AsyncValue<List<Bookmark>>>((ref) {
  final repo = ref.watch(userLibraryRepositoryProvider);
  return BookmarksNotifier(repo);
});

final personalNotesProvider = FutureProvider<List<PersonalNote>>((ref) async {
  final repo = ref.watch(userLibraryRepositoryProvider);
  return repo.getNotes();
});

