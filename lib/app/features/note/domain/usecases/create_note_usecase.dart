import 'package:dartz/dartz.dart';
import 'package:my_note_app/app/app.dart';

import '../entities/note.dart';
import '../repositories/note_repository.dart';

class CreateNoteUseCase implements UseCase<Unit, Note> {
  final NoteRepository _noteRepository;

  CreateNoteUseCase(this._noteRepository);

  @override
  Future<Either<Failure, Unit>> call(Note params) async {
    return await _noteRepository.insertNote(
      Note(
        title: params.title,
        content: params.content,
        lastEditedTime: DateTime.now(),
      ),
    );
  }
}
