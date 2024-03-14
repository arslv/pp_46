import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_46/data/entity/idea_entity.dart';
import 'package:pp_46/data/entity/note_entity.dart';
import 'package:pp_46/data/entity/quote_entity.dart';
import 'package:pp_46/data/repository/database_service.dart';

class QuotesController extends ValueNotifier<QuotesState> {
  QuotesController() : super(QuotesState.initial()) {
    _init();
  }

  final dataBase = GetIt.instance.get<DatabaseService>();

  Future<void> _init() async {
    final quotes = dataBase.quotes();
    final categories = dataBase.quoteCategories;

    if (value.selectedCategory == null) {
      value = value.copyWith(quotes: quotes, categories: categories, selectedCategory: 'Favorite');
    } else {
      value = value.copyWith(quotes: quotes, categories: categories);
    }
    notifyListeners();
  }

  void addQuote(QuoteEntity quote) {
    dataBase.addQuote(quote.author, quote);
    refresh();
  }

  void selectCategory(String category) {
    value = value.copyWith(selectedCategory: category);
    notifyListeners();
  }

  void like(QuoteEntity quote) {
    dataBase.addFavoriteQuote(quote.author);
    notifyListeners();
    refresh();
  }

  void refresh() => _init();
}

class QuotesState {
  final List<QuoteEntity> quotes;
  final List<String> categories;
  final String? selectedCategory;

  const QuotesState({
    required this.quotes,
    required this.categories,
    this.selectedCategory,
  });

  factory QuotesState.initial() => const QuotesState(
    quotes: [],
    categories: [],
    selectedCategory: null,
  );

  QuotesState copyWith({
    List<QuoteEntity>? quotes,
    List<String>? categories,
    String? selectedCategory,
  }) =>
      QuotesState(
        quotes: quotes ?? this.quotes,
        categories: categories ?? this.categories,
        selectedCategory: selectedCategory ?? this.selectedCategory,
      );
}
