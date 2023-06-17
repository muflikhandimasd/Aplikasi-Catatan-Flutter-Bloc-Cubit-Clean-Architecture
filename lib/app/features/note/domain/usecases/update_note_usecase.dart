import 'package:dartz/dartz.dart';
import 'package:my_note_app/app/core/failure/failure.dart';
import 'package:my_note_app/app/features/note/domain/entities/note.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/note_repository.dart';

class UpdateNoteUseCase extends UseCase<Unit, Note> {
  final NoteRepository _noteRepository;

  UpdateNoteUseCase(this._noteRepository);

  @override
  Future<Either<Failure, Unit>> call(Note params) async {
    return await _noteRepository.updateNote(
      Note(
        id: params.id,
        title: params.title,
        content: params.content,
        lastEditedTime: DateTime.now(),
      ),
    );
  }
}
