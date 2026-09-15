import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/sunnah_category.dart';
import '../../data/models/sunnah_practice.dart';
import '../../data/repositories/mock_sunnah_repository.dart';
import '../../data/repositories/sunnah_repository.dart';

// Repository Provider
final sunnahRepositoryProvider = Provider<SunnahRepository>((ref) {
  return MockSunnahRepository();
});

// Categories Provider
final sunnahCategoriesProvider =
    FutureProvider<List<SunnahCategory>>((ref) async {
  final repo = ref.watch(sunnahRepositoryProvider);
  return repo.getCategories();
});

// Featured Sunnah Provider
final featuredSunnahProvider = FutureProvider<SunnahPractice>((ref) async {
  final repo = ref.watch(sunnahRepositoryProvider);
  return repo.getFeaturedSunnah();
});

// Category Filter Provider
final sunnahSelectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Search Query Provider
final sunnahSearchQueryProvider = StateProvider<String>((ref) => '');

// Filtered / Searchable Sunnah List Provider
final sunnahListProvider = FutureProvider<List<SunnahPractice>>((ref) async {
  final repo = ref.watch(sunnahRepositoryProvider);
  final category = ref.watch(sunnahSelectedCategoryProvider);
  final query = ref.watch(sunnahSearchQueryProvider);
  return repo.getSunnahList(
    category: category == 'All' ? null : category,
    query: query.isEmpty ? null : query,
  );
});

// Sunnah by Category family provider
final sunnahByCategoryProvider =
    FutureProvider.family<List<SunnahPractice>, String>((ref, categoryId) async {
  final repo = ref.watch(sunnahRepositoryProvider);
  return repo.getSunnahList(category: categoryId);
});

// Sunnah Detail Provider
final sunnahDetailProvider =
    FutureProvider.family<SunnahPractice?, String>((ref, id) async {
  final repo = ref.watch(sunnahRepositoryProvider);
  return repo.getSunnahById(id);
});

// Child-Friendly Mode Toggle Provider
final sunnahChildModeProvider = StateProvider<bool>((ref) => false);

// Bookmarking State Notifier Provider
class SunnahBookmarksNotifier extends StateNotifier<Set<String>> {
  SunnahBookmarksNotifier() : super({'drinking-water'});

  void toggleBookmark(String sunnahId) {
    if (state.contains(sunnahId)) {
      state = Set.from(state)..remove(sunnahId);
    } else {
      state = Set.from(state)..add(sunnahId);
    }
  }

  bool isBookmarked(String sunnahId) => state.contains(sunnahId);
}

final sunnahBookmarksProvider =
    StateNotifierProvider<SunnahBookmarksNotifier, Set<String>>((ref) {
  return SunnahBookmarksNotifier();
});
