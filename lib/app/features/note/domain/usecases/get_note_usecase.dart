import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_note_app/app/core/failure/failure.dart';
import 'package:my_note_app/app/features/note/domain/entities/note.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/note_repository.dart';

class GetNoteUseCase implements UseCase<List<Note>, NoParams> {
  final NoteRepository _noteRepository;

  GetNoteUseCase(this._noteRepository);

  @override
  Future<Either<Failure, List<Note>>> call(NoParams params) async {
    return await _noteRepository.getNotes();
  }
}

class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}
