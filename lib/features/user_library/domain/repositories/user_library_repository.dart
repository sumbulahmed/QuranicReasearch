import '../entities/bookmark.dart';
import '../entities/personal_note.dart';

abstract class UserLibraryRepository {
  Future<List<Bookmark>> getBookmarks();
  Future<void> addBookmark(Bookmark bookmark);
  Future<void> removeBookmark(String bookmarkId);
  Future<bool> isBookmarked(String itemId);

  Future<List<PersonalNote>> getNotes();
  Future<void> saveNote(PersonalNote note);
  Future<void> deleteNote(String noteId);
  Future<PersonalNote?> getNoteForTarget(String targetId);
}
