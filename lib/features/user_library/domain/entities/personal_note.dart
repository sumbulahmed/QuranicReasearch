class PersonalNote {
  final String id;
  final String targetType; // 'ayah', 'hadith', 'topic'
  final String targetId;
  final String targetTitle;
  final String noteText;
  final DateTime updatedAt;

  const PersonalNote({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.targetTitle,
    required this.noteText,
    required this.updatedAt,
  });

  factory PersonalNote.fromMap(String id, Map<String, dynamic> map) {
    return PersonalNote(
      id: id,
      targetType: map['target_type'] as String? ?? 'ayah',
      targetId: map['target_id'] as String? ?? '',
      targetTitle: map['target_title'] as String? ?? '',
      noteText: map['note_text'] as String? ?? '',
      updatedAt: map['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'target_type': targetType,
      'target_id': targetId,
      'target_title': targetTitle,
      'note_text': noteText,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }
}
