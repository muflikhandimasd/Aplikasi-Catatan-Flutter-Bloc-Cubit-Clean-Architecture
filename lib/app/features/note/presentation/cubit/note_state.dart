part of 'note_cubit.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<Note> notes;

  const NoteLoaded(this.notes);

  @override
  // TODO: implement props
  List<Object> get props => [notes];
}

class NoteError extends NoteState {
  final String message;

  const NoteError(this.message);

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
