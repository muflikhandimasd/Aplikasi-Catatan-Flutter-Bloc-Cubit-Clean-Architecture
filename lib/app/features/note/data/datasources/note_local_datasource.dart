import 'package:my_note_app/objectbox.g.dart';

import '../../domain/entities/note.dart';

abstract class NoteLocalDatasource {
  Future<List<Note>> getNotes();
  Future<List<Note>> searchNotes(String query);
  Future<void> insertNote({
    String? title,
    required String content,
  });
  Future<void> updateNote({
    required int id,
    String? title,
    required String content,
  });
  Future<void> deleteNote(int id);
}

class NoteLocalDatasourceImpl implements NoteLocalDatasource {
  final Box<Note> box;

  NoteLocalDatasourceImpl({required this.box});
  @override
  Future<void> deleteNote(int id) async {
    await box.removeAsync(id);
    return;
  }

  @override
  Future<List<Note>> getNotes() async {
    final notes = await box.getAllAsync();
    return notes;
  }

  @override
  Future<void> insertNote({String? title, required String content}) async {
    final note = Note(
      title: title,
      content: content,
      lastEditedTime: DateTime.now(),
    );
    await box.putAsync(note, mode: PutMode.insert);
    return;
  }

  @override
  Future<List<Note>> searchNotes(String query) async {
    final queryBuilder = (box.query(
            Note_.title.contains(query).or(Note_.content.contains(query)))
          ..order(Note_.lastEditedTime, flags: Order.descending))
        .build();
    final notes = await queryBuilder.findAsync();
    return notes;
  }

  @override
  Future<void> updateNote(
      {required int id, String? title, required String content}) async {
    await box.putAsync(
      Note(
        id: id,
        title: title,
        content: content,
        lastEditedTime: DateTime.now(),
      ),
      mode: PutMode.update,
    );
    return;
  }
}
