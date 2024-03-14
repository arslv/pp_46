import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_46/business/controllers/quotes_controller.dart';
import 'package:pp_46/business/helpers/image/image_helper.dart';
import 'package:pp_46/data/entity/quote_entity.dart';
import 'package:pp_46/presentation/themes/app_theme.dart';
import 'package:pp_46/presentation/themes/custom_colors.dart';
import 'package:pp_46/presentation/widgets/app_button.dart';
import 'package:pp_46/presentation/widgets/app_text_field.dart';
import 'package:pp_46/presentation/widgets/category_row.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:theme_provider/theme_provider.dart';

class QuotesView extends StatefulWidget {
  const QuotesView({super.key});

  @override
  State<QuotesView> createState() => _QuotesViewState();
}

class _QuotesViewState extends State<QuotesView> {
  final _searchController = TextEditingController();
  final _quotesController = QuotesController();

  var _searchQuery = '';

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {_speechEnabled = false;});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _searchQuery = _lastWords;
      _searchController.text = _lastWords;
    });
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void save({
    required String quote,
    required String author,
    required String category,
  }) {
    _quotesController.addQuote(QuoteEntity(
      quote: quote,
      author: author,
      isLiked: false,
      category: category,
    ));
    Navigator.of(context).pop();
  }

  void _showAddQuote() {
    final quouteQuoteController = TextEditingController();
    final authorQuoteController = TextEditingController();
    String selectedCategory = _quotesController.value.categories[0];

    void _showCategoryPickerDialog(Widget child) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: child,
          ),
        ),
      );
    }

    bool buttonState = false;

    showCupertinoModalPopup(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            void updateSaveButtonState() {
              setState(() {
                buttonState = quouteQuoteController.text.isNotEmpty &&
                    authorQuoteController.text.isNotEmpty;
              });
            }
            quouteQuoteController.addListener(updateSaveButtonState);
            authorQuoteController.addListener(updateSaveButtonState);
            bool isDarkMode = ThemeProvider.themeOf(context).id == DefaultTheme.dark.id;
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.of(context).pop(),
                          child: ImageHelper.svgImage(
                              isDarkMode ? SvgNames.backDark : SvgNames.backLight),
                        ),
                        const Spacer(),
                        Text('New Quote',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: Theme.of(context).colorScheme.onBackground)),
                        const Spacer(),
                        const SizedBox(height: 36, width: 36),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _showCategoryPickerDialog(
                          CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: 30,
                            scrollController: FixedExtentScrollController(
                              initialItem: 0,
                            ),
                            onSelectedItemChanged: (int selectedItem) {
                              setState(() {
                                selectedCategory = _quotesController.value.categories[selectedItem];
                              });
                            },
                            children: List<Widget>.generate(
                                _quotesController.value.categories.length, (int index) {
                              return Center(child: Text(_quotesController.value.categories[index]));
                            }),
                          ),
                        );
                      },
                      child: Container(
                        height: 42,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context).extension<CustomColors>()!.containerBg,
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Text(
                                'Select category: $selectedCategory',
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.5),
                                    ),
                              ),
                              const Spacer(),
                              const Icon(CupertinoIcons.chevron_down, color: Color(0xFF889096))
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      placeholder: 'Type author name',
                      controller: authorQuoteController,
                      maxLength: 64,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      placeholder: 'Type here quote...',
                      controller: quouteQuoteController,
                      maxLines: 16,
                      size: const Size(double.infinity, 164),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      name: 'Save',
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      callback: buttonState
                          ? () => save(
                                quote: quouteQuoteController.text,
                                author: authorQuoteController.text,
                                category: selectedCategory,
                              )
                          : null,
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quotesController.dispose();
    super.dispose();
  }

  void _handleSearchUpdate(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ValueListenableBuilder(
          valueListenable: _quotesController,
          builder: (BuildContext context, QuotesState state, Widget? child) {
            return Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Quotes',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(color: Theme.of(context).colorScheme.onBackground),
                        ),
                        const Spacer(),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: _showAddQuote,
                          child: ImageHelper.svgImage(SvgNames.add,
                              color: Theme.of(context).colorScheme.onBackground),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      size: const Size(double.infinity, 48),
                      backgroundColor: Theme.of(context).extension<CustomColors>()!.containerBg,
                      placeholder: 'Search',
                      onChanged: _handleSearchUpdate,
                      hasBorder: false,
                      controller: _searchController,
                      enabled: true,
                      textAlignVertical: TextAlignVertical.center,
                      suffix: CupertinoButton(
                        onPressed: () =>
                        _speechToText.isNotListening ? _startListening() : _stopListening(),
                        padding: EdgeInsets.zero,
                        child: Icon(
                          _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                          size: 24,
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                        ),
                      ),
                      prefix: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 0),
                        child: Icon(
                          Icons.search,
                          size: 24,
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CategoryRow(
                      categories: state.categories,
                      selectedCategory: state.selectedCategory!,
                      selectAction: _quotesController.selectCategory,
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder(
                      valueListenable: _quotesController,
                      builder: (BuildContext context, QuotesState state, Widget? child) {
                        if (state.quotes.isEmpty) {
                          return EmptyNoteState(
                            addQuoteAction: _showAddQuote,
                          );
                        } else {
                          final filteredIdeas =
                              (_searchQuery.isEmpty && state.selectedCategory == 'All'
                                      ? state.quotes
                                      : state.selectedCategory == 'Favorite'
                                          ? state.quotes.where((element) {
                                              final lowerName = element.quote.toLowerCase();
                                              final lowerQuery = _searchQuery.toLowerCase();
                                              return (lowerName.startsWith(lowerQuery) ||
                                                      lowerName.contains(lowerQuery)) &&
                                                  element.isLiked;
                                            })
                                          : state.quotes.where(
                                              (quotes) {
                                                final lowerName = quotes.quote.toLowerCase();
                                                final lowerQuery = _searchQuery.toLowerCase();
                                                return (lowerName.startsWith(lowerQuery) ||
                                                        lowerName.contains(lowerQuery)) &&
                                                    quotes.category == state.selectedCategory;
                                              },
                                            ))
                                  .toList();
                          return filteredIdeas.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: filteredIdeas.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final quoute = filteredIdeas[index];
                                      return QuoteContainer(
                                        quote: quoute,
                                        controller: _quotesController,
                                      );
                                    },
                                  ),
                                )
                              : EmptyNoteState(
                                  addQuoteAction: _showAddQuote,
                                );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class QuoteContainer extends StatelessWidget {
  const QuoteContainer({super.key, required this.quote, required this.controller});

  final QuoteEntity quote;
  final QuotesController controller;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeProvider.themeOf(context).id == DefaultTheme.dark.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<CustomColors>()!.containerBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "\"${quote.quote}\"",
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(right: 16, top: 5),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => controller.like(quote),
                        child: ImageHelper.svgImage(
                          isDarkMode
                              ? quote.isLiked
                                  ? SvgNames.likeDarkEnabled
                                  : SvgNames.likeDark
                              : quote.isLiked
                                  ? SvgNames.likeLightEnabled
                                  : SvgNames.likeLight,
                          color: isDarkMode
                              ? quote.isLiked
                                  ? null
                                  : Colors.white
                              : null,
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    quote.author,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmptyNoteState extends StatelessWidget {
  const EmptyNoteState({super.key, required this.addQuoteAction});

  final VoidCallback addQuoteAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        ImageHelper.getImage(ImageNames.quotes),
        Text(
          'You dont have any Qoutes',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        const SizedBox(height: 10),
        CupertinoButton(
          onPressed: () => addQuoteAction.call(),
          padding: EdgeInsets.zero,
          child: Text(
            'Click to add',
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(color: CupertinoColors.activeBlue),
          ),
        )
      ],
    );
  }
}
