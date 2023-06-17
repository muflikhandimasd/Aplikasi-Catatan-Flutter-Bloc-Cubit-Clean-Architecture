import 'package:objectbox/objectbox.dart';

@Entity()
class Note {
  @Id()
  int id;
  String? title;
  final String content;

  @Property(type: PropertyType.date)
  final DateTime? lastEditedTime;

  Note({
    this.id = 0,
    this.title,
    required this.content,
    this.lastEditedTime,
  });
}
