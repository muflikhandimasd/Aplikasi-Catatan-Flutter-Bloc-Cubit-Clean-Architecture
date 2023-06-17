import 'package:dartz/dartz.dart';

import '../../../../app.dart';
import '../entities/note.dart';

abstract class NoteRepository {
  Future<Either<Failure, List<Note>>> getNotes();
  Future<Either<Failure, List<Note>>> searchNotes(String query);
  Future<Either<Failure, Unit>> insertNote(Note note);
  Future<Either<Failure, Unit>> updateNote(Note note);
  Future<Either<Failure, Unit>> deleteNote(int id);
}
