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
  Future<void> deleteNote(int id) {
    box.remove(id);
    return Future.value();
  }

  @override
  Future<List<Note>> getNotes() {
    final notes = box
        .query()
        .order(
          Note_.lastEditedTime,
          flags: Order.descending,
        )
        .build()
        .find();

    return Future.value(notes);
  }

  @override
  Future<void> insertNote({String? title, required String content}) {
    final note = Note(
      title: title,
      content: content,
      lastEditedTime: DateTime.now(),
    );
    box.put(note, mode: PutMode.insert);
    return Future.value();
  }

  @override
  Future<List<Note>> searchNotes(String query) {
    final queryBuilder = (box.query(
            Note_.title.contains(query).or(Note_.content.contains(query)))
          ..order(Note_.lastEditedTime, flags: Order.descending))
        .build();
    final notes = queryBuilder.find();
    return Future.value(notes);
  }

  @override
  Future<void> updateNote(
      {required int id, String? title, required String content}) {
    box.put(
      Note(
        id: id,
        title: title,
        content: content,
        lastEditedTime: DateTime.now(),
      ),
      mode: PutMode.update,
    );
    return Future.value();
  }
}
