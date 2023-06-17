import 'package:dartz/dartz.dart';
import 'package:my_note_app/app/features/note/domain/entities/note.dart';

import '../../../../app.dart';
import '../repositories/note_repository.dart';

class DeleteNoteUseCase extends UseCase<Unit, Note> {
  final NoteRepository _noteRepository;

  DeleteNoteUseCase(this._noteRepository);

  @override
  Future<Either<Failure, Unit>> call(Note params) async {
    return await _noteRepository.deleteNote(
      params.id,
    );
  }
}
