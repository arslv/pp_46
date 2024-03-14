import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pp_46/data/entity/idea_entity.dart';
import 'package:pp_46/data/entity/note_entity.dart';
import 'package:pp_46/data/entity/quote_entity.dart';

class DatabaseService {
  late final Box<dynamic> _common;
  late final Box<Note> _notes;
  late final Box<Idea> _ideas;
  late final Box<QuoteEntity> _quotes;
  late final Box<String> _ideaCategories;
  late final Box<String> _quotesCategories;

  Future<DatabaseService> init() async {
    await Hive.initFlutter();
    final appDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDirectory.path);

    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(IdeaAdapter());
    Hive.registerAdapter(QuoteEntityAdapter());

    _common = await Hive.openBox('_common');
    _notes = await Hive.openBox('_notes');
    _ideas = await Hive.openBox('_ideas');
    _quotes = await Hive.openBox('_quotes');
    _ideaCategories = await Hive.openBox('_ideaCategories');
    _quotesCategories = await Hive.openBox('_quotesCategories');

    _setupIdeaCategories();
    _setupQuoteCategories();

    return this;
  }

  //notes
  void addNote(String key, Note value) => _notes.put(key, value);
  Note? getNote(String key) => _notes.get(key);
  List<Note> notes() => _notes.values.toList();
  Future<void> editNote(String key, Note editedNote) async{
    Note selectedNote = getNote(key)!;
    selectedNote.name = editedNote.name;
    selectedNote.text = editedNote.text;
    selectedNote.dateTime = editedNote.dateTime;
    _notes.delete(key);
    addNote(editedNote.name, selectedNote);
  }

  //ideas
  void addIdea(String key, Idea value) => _ideas.put(key, value);
  Idea? getIdea(String key) => _ideas.get(key);
  List<Idea> ideas() => _ideas.values.toList();
  void addFavoriteIdea(String key) {
    var selectedIdea = getIdea(key);
    selectedIdea?.isLiked = !selectedIdea.isLiked;
    selectedIdea?.save();
  }

  //quotes
  void addQuote(String key, QuoteEntity value) => _quotes.put(key, value);
  QuoteEntity? getQuote(String key) => _quotes.get(key);
  List<QuoteEntity> quotes() => _quotes.values.toList();
  void addFavoriteQuote(String key) {
    var selectedQuote = getQuote(key);
    selectedQuote?.isLiked = !selectedQuote.isLiked;
    selectedQuote?.save();
  }

  //categories
  void addIdeaCategory(String key, String category) => _ideaCategories.put(key, category);
  void deleteIdeaCategory(String key) => _ideaCategories.delete(key);
  List<String> get ideaCategories => _ideaCategories.values.toList();

  void addQuoteCategory(String key, String category) => _quotesCategories.put(key, category);
  void deleteQuotesCategory(String key) => _quotesCategories.delete(key);
  List<String> get quoteCategories => _quotesCategories.values.toList();

  void _setupIdeaCategories() {
    if (_ideaCategories.isEmpty) {
      addIdeaCategory('All', 'All');
      addIdeaCategory('Art', 'Art');
      addIdeaCategory('Music', 'Music');
      addIdeaCategory('Decor', 'Decor');
      addIdeaCategory('Books', 'Books');
    }
  }

  void _setupQuoteCategories() {
    if (_quotesCategories.isEmpty) {
      addQuoteCategory('All', 'All');
    }
  }

  void put(String key, dynamic value) => _common.put(key, value);

  dynamic get(String key) => _common.get(key);
}
