class Note {
  final int id;
  final String title;
  final String content;
  final DateTime createdTime;
  final DateTime lastEditedTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdTime,
    required this.lastEditedTime,
  });
}
