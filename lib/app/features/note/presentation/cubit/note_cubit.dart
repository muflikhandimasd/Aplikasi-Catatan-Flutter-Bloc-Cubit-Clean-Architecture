import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_note_app/app/features/note/domain/usecases/create_note_usecase.dart';
import 'package:my_note_app/app/features/note/domain/usecases/delete_note_usecase.dart';
import 'package:my_note_app/app/features/note/domain/usecases/get_note_usecase.dart';
import 'package:my_note_app/app/features/note/domain/usecases/search_note_usecase.dart';
import 'package:my_note_app/app/features/note/domain/usecases/update_note_usecase.dart';

import '../../domain/entities/note.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final CreateNoteUseCase createNote;
  final GetNoteUseCase getNote;
  final SearchNoteUseCase searchNote;
  final UpdateNoteUseCase updateNote;
  final DeleteNoteUseCase deleteNote;

  NoteCubit({
    required this.createNote,
    required this.getNote,
    required this.searchNote,
    required this.updateNote,
    required this.deleteNote,
  }) : super(NoteInitial());

  @override
  void onChange(Change<NoteState> change) {
    if (kDebugMode) {
      log(change.toString());
    }
    super.onChange(change);
  }

  void get() async {
    emit(NoteLoading());
    final result = await getNote(const NoParams());
    result.fold((failure) => emit(NoteError(failure.message)),
        (notes) => emit(NoteLoaded(notes)));
  }

  void create(Note note) async {
    emit(NoteLoading());
    final result = await createNote(note);
    result.fold((failure) => emit(NoteError(failure.message)), (_) {
      get();
    });
  }

  void update(Note note) async {
    emit(NoteLoading());
    final result = await updateNote(note);
    result.fold((failure) => emit(NoteError(failure.message)), (_) {
      get();
    });
  }

  void search(String query) async {
    emit(NoteLoading());
    final result = await searchNote(query);

    result.fold((failure) => emit(NoteError(failure.message)),
        (notes) => emit(NoteLoaded(notes)));
  }

  void delete(Note note) async {
    emit(NoteLoading());
    final result = await deleteNote(note);
    result.fold((failure) => emit(NoteError(failure.message)), (_) {
      get();
    });
  }
}
