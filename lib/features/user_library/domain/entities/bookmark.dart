enum LibraryItemType {
  ayah,
  hadith,
  topic,
  paper;

  static LibraryItemType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'hadith':
        return LibraryItemType.hadith;
      case 'topic':
        return LibraryItemType.topic;
      case 'paper':
        return LibraryItemType.paper;
      default:
        return LibraryItemType.ayah;
    }
  }
}

class Bookmark {
  final String id;
  final LibraryItemType itemType;
  final String itemId; // e.g. "23:14" or "bukhari_3208" or topic ID
  final String title;
  final String subtitle;
  final DateTime createdAt;

  const Bookmark({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.title,
    required this.subtitle,
    required this.createdAt,
  });

  factory Bookmark.fromMap(String id, Map<String, dynamic> map) {
    return Bookmark(
      id: id,
      itemType: LibraryItemType.fromString(map['item_type'] as String?),
      itemId: map['item_id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_type': itemType.name,
      'item_id': itemId,
      'title': title,
      'subtitle': subtitle,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }
}
