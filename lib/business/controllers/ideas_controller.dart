import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_46/data/entity/idea_entity.dart';
import 'package:pp_46/data/entity/note_entity.dart';
import 'package:pp_46/data/repository/database_service.dart';

class IdeasController extends ValueNotifier<IdeasState> {
  IdeasController() : super(IdeasState.initial()) {
    _init();
  }

  final dataBase = GetIt.instance.get<DatabaseService>();

  Future<void> _init() async {
    final ideas = dataBase.ideas();
    final categories = dataBase.ideaCategories;

    if (value.selectedCategory == null) {
      value = value.copyWith(ideas: ideas, categories: categories, selectedCategory: 'Favorite');
    } else {
      value = value.copyWith(ideas: ideas, categories: categories);
    }
    notifyListeners();
  }

  void addIdea(Idea idea) {
    dataBase.addIdea(idea.name, idea);
    refresh();
  }

  void select(Idea idea) {
    value = value.copyWith(selectedIdea: idea, isLiked: idea.isLiked);
    notifyListeners();
  }

  void selectCategory(String category) {
    value = value.copyWith(selectedCategory: category);
    notifyListeners();
  }

  void like(Idea idea) {
    dataBase.addFavoriteIdea(idea.name);
    var newValue = !value.isLiked!;
    value = value.copyWith(isLiked: newValue);
    notifyListeners();
    refresh();
  }

  void refresh() => _init();
}

class IdeasState {
  final List<Idea> ideas;
  final Idea? selectedIdea;
  final bool? isLiked;
  final List<String> categories;
  final String? selectedCategory;

  const IdeasState({
    required this.ideas,
    this.selectedIdea,
    this.isLiked,
    required this.categories,
    this.selectedCategory,
  });

  factory IdeasState.initial() => const IdeasState(
        ideas: [],
        selectedIdea: null,
        isLiked: null,
        categories: [],
        selectedCategory: null,
      );

  IdeasState copyWith({
    List<Idea>? ideas,
    Idea? selectedIdea,
    bool? isLiked,
    List<String>? categories,
    String? selectedCategory,
  }) =>
      IdeasState(
        ideas: ideas ?? this.ideas,
        selectedIdea: selectedIdea ?? this.selectedIdea,
        isLiked: isLiked ?? this.isLiked,
        categories: categories ?? this.categories,
        selectedCategory: selectedCategory ?? this.selectedCategory,
      );
}
