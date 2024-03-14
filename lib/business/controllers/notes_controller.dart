import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_46/data/entity/note_entity.dart';
import 'package:pp_46/data/repository/database_service.dart';

class NotesController extends ValueNotifier<NotesState> {
  NotesController() : super(NotesState.inital()) {
    _init();
  }

  final dataBase = GetIt.instance.get<DatabaseService>();

  Future<void> _init() async {
    final notes = dataBase.notes();
    value = value.copyWith(notes: notes);
    notifyListeners();
  }

  void addNote(Note note) {
    dataBase.addNote(note.name, note);
    refresh();
  }

  Future<void> editNote(String key, Note editedNote) async{
    await dataBase.editNote(key, editedNote);
    refresh();
  }

  void refresh() => _init();
}

class NotesState {
  final List<Note> notes;

  const NotesState({
    required this.notes,
  });

  factory NotesState.inital() => NotesState(
        notes: [],
      );

  NotesState copyWith({
    List<Note>? notes,
  }) =>
      NotesState(
        notes: notes ?? this.notes,
      );
}
