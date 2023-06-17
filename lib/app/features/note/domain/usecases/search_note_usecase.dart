import 'package:dartz/dartz.dart';

import '../../../../app.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

class SearchNoteUseCase extends UseCase<List<Note>, String> {
  final NoteRepository _noteRepository;

  SearchNoteUseCase(this._noteRepository);
  @override
  Future<Either<Failure, List<Note>>> call(String params) async {
    return await _noteRepository.searchNotes(params);
  }
}
