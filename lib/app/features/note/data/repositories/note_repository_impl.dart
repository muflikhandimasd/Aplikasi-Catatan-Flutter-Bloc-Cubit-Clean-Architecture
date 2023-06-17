import 'package:dartz/dartz.dart';
import 'package:my_note_app/app/core/exception/exception.dart';
import 'package:my_note_app/app/core/failure/failure.dart';
import 'package:my_note_app/app/features/note/data/datasources/note_local_datasource.dart';
import 'package:my_note_app/app/features/note/domain/entities/note.dart';
import 'package:my_note_app/app/features/note/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDatasource localDatasource;

  NoteRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, Unit>> deleteNote(int id) async {
    try {
      await localDatasource.deleteNote(id);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    try {
      final notes = await localDatasource.getNotes();
      return Right(notes);
    } catch (e) {
      return Left(CacheFailure(message: 'Error get Notes'));
    }
  }

  @override
  Future<Either<Failure, Unit>> insertNote(Note note) async {
    try {
      await localDatasource.insertNote(
          title: note.title, content: note.content);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: 'Error Insert Data'));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> searchNotes(String query) async {
    try {
      final notes = await localDatasource.searchNotes(query);
      return Right(notes);
    } catch (e) {
      return Left(CacheFailure(message: 'Error Search Notes'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateNote(Note note) async {
    try {
      await localDatasource.updateNote(
          id: note.id, title: note.title, content: note.content);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: 'Error Update Note'));
    }
  }
}
