import 'package:get_it/get_it.dart';
import 'package:my_note_app/app/features/note/data/repositories/note_repository_impl.dart';
import 'package:my_note_app/app/features/note/domain/entities/note.dart';
import 'package:my_note_app/app/features/note/domain/repositories/note_repository.dart';
import 'package:my_note_app/app/features/note/domain/usecases/create_note_usecase.dart';
import 'package:my_note_app/app/features/note/domain/usecases/delete_note_usecase.dart';
import 'package:my_note_app/app/features/note/domain/usecases/get_note_usecase.dart';
import 'package:my_note_app/app/features/note/domain/usecases/search_note_usecase.dart';
import 'package:my_note_app/app/features/note/domain/usecases/update_note_usecase.dart';
import 'package:my_note_app/objectbox.g.dart';

import '../../features/note/data/datasources/note_local_datasource.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/note/presentation/cubit/note_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final box = await openBox();
  sl.registerLazySingleton<Box<Note>>(() => box);
  sl.registerLazySingleton<NoteLocalDatasource>(
      () => NoteLocalDatasourceImpl(box: sl()));
  sl.registerLazySingleton<NoteRepository>(
      () => NoteRepositoryImpl(localDatasource: sl()));

  // UseCase
  sl.registerLazySingleton<GetNoteUseCase>(() => GetNoteUseCase(sl()));
  sl.registerLazySingleton<SearchNoteUseCase>(() => SearchNoteUseCase(sl()));
  sl.registerLazySingleton<CreateNoteUseCase>(() => CreateNoteUseCase(sl()));
  sl.registerLazySingleton<UpdateNoteUseCase>(() => UpdateNoteUseCase(sl()));
  sl.registerLazySingleton<DeleteNoteUseCase>(() => DeleteNoteUseCase(sl()));

  // Bloc
  sl.registerFactory<NoteCubit>(() => NoteCubit(
        createNote: sl(),
        getNote: sl(),
        searchNote: sl(),
        updateNote: sl(),
        deleteNote: sl(),
      ));
}

Future<Box<Note>> openBox() async {
  final documentsDir = await getApplicationDocumentsDirectory();
  final store = await openStore(directory: p.join(documentsDir.path, "notes"));
  final box = store.box<Note>();
  return box;
}
