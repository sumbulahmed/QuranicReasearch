import '../../domain/entities/bookmark.dart';
import '../../domain/entities/personal_note.dart';
import '../../domain/repositories/user_library_repository.dart';

class MockUserLibraryRepository implements UserLibraryRepository {
  final List<Bookmark> _bookmarks = [
    Bookmark(
      id: 'bm_1',
      itemType: LibraryItemType.ayah,
      itemId: '23:14',
      title: 'Surah Al-Mu\'minun 23:14',
      subtitle: 'Then We made the sperm-drop into a clinging clot...',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Bookmark(
      id: 'bm_2',
      itemType: LibraryItemType.topic,
      itemId: 'oceanography',
      title: 'Internal Ocean Waves & Deep Sea Stratification',
      subtitle: 'Subsurface density waves at pycnocline boundaries',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final List<PersonalNote> _notes = [
    PersonalNote(
      id: 'note_1',
      targetType: 'ayah',
      targetId: '23:14',
      targetTitle: 'Surah Al-Mu\'minun (23:14)',
      noteText:
          'Compare the Carnegie Stage 10-12 morphology notes with Dr. Keith Moore\'s paper on the macroscopic appearance of the embryo.',
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  @override
  Future<List<Bookmark>> getBookmarks() async {
    return List.unmodifiable(_bookmarks);
  }

  @override
  Future<void> addBookmark(Bookmark bookmark) async {
    _bookmarks.removeWhere((b) => b.itemId == bookmark.itemId);
    _bookmarks.insert(0, bookmark);
  }

  @override
  Future<void> removeBookmark(String bookmarkId) async {
    _bookmarks.removeWhere((b) => b.id == bookmarkId || b.itemId == bookmarkId);
  }

  @override
  Future<bool> isBookmarked(String itemId) async {
    return _bookmarks.any((b) => b.itemId == itemId);
  }

  @override
  Future<List<PersonalNote>> getNotes() async {
    return List.unmodifiable(_notes);
  }

  @override
  Future<void> saveNote(PersonalNote note) async {
    _notes.removeWhere((n) => n.id == note.id || n.targetId == note.targetId);
    _notes.insert(0, note);
  }

  @override
  Future<void> deleteNote(String noteId) async {
    _notes.removeWhere((n) => n.id == noteId);
  }

  @override
  Future<PersonalNote?> getNoteForTarget(String targetId) async {
    try {
      return _notes.firstWhere((n) => n.targetId == targetId);
    } catch (_) {
      return null;
    }
  }
}
