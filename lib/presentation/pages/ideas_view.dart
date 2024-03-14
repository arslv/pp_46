import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pp_46/business/controllers/ideas_controller.dart';
import 'package:pp_46/business/helpers/dialog_helper.dart';
import 'package:pp_46/business/helpers/extensions/string_extension.dart';
import 'package:pp_46/business/helpers/image/image_helper.dart';
import 'package:pp_46/business/services/navigation/route_names.dart';
import 'package:pp_46/data/entity/idea_entity.dart';
import 'package:pp_46/presentation/pages/idea_view.dart';
import 'package:pp_46/presentation/themes/app_theme.dart';
import 'package:pp_46/presentation/themes/custom_colors.dart';
import 'package:pp_46/presentation/widgets/app_button.dart';
import 'package:pp_46/presentation/widgets/app_text_field.dart';
import 'package:pp_46/presentation/widgets/category_row.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:theme_provider/theme_provider.dart';

class IdeasView extends StatefulWidget {
  const IdeasView({super.key});

  @override
  State<IdeasView> createState() => _IdeasViewState();
}

class _IdeasViewState extends State<IdeasView> {
  final _searchController = TextEditingController();
  final _ideasController = IdeasController();

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
    setState(() {
      _speechEnabled = false;
    });
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

  void save(
      {required String name,
      required String text,
      required DateTime dateTime,
      required String base64Image,
      required String category}) {
    _ideasController.addIdea(Idea(
      name: name,
      text: text,
      dateTime: dateTime,
      base64Image: base64Image,
      isLiked: false,
      category: category,
    ));
    Navigator.of(context).pop();
  }

  void _showAddIdea() {
    final ImagePicker _picker = ImagePicker();
    Image? selectedPhoto;
    String base64Image = '';

    final nameIdeaController = TextEditingController();
    final textIdeaController = TextEditingController();

    String selectedCategory = '';
    DateTime dateTime = DateTime.now();


    void _showCategoryPickerDialog(Widget child) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
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
                buttonState = nameIdeaController.text.isNotEmpty &&
                    textIdeaController.text.isNotEmpty &&
                    base64Image != '';
              });
            }

            Future<void> takeAndSavePhoto() async {
              final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
              if (pickedFile == null) {
                DialogHelper.showErrorDialog(context, 'Something going wrong, please try again.');
                return;
              }

              Uint8List imageBytes = await pickedFile.readAsBytes();

              setState(() {
                base64Image = base64Encode(imageBytes);
                Uint8List bytes = base64Decode(base64Image);
                selectedPhoto = Image.memory(bytes);
                updateSaveButtonState();
              });
            }


            nameIdeaController.addListener(updateSaveButtonState);
            textIdeaController.addListener(updateSaveButtonState);
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
                        Text('New Idea',
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
                                selectedCategory = _ideasController.value.categories[selectedItem];
                              });
                            },
                            children: List<Widget>.generate(
                                _ideasController.value.categories.length, (int index) {
                              return Center(child: Text(_ideasController.value.categories[index]));
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
                      placeholder: 'Type your Idea-name',
                      controller: nameIdeaController,
                      maxLength: 64,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      placeholder: 'Type here...',
                      controller: textIdeaController,
                      maxLines: 16,
                      size: const Size(double.infinity, 164),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                          onPressed: () async {
                            await takeAndSavePhoto();
                            setState;
                          },
                          padding: EdgeInsets.zero,
                          child: selectedPhoto != null
                              ? ImageHelper.svgImage(SvgNames.imageSelecterSelected)
                              : ImageHelper.svgImage(SvgNames.imageSelecter),
                        ),
                        const SizedBox(width: 10),
                        CupertinoButton(
                          onPressed: () => _showDateTimeDialog(
                            CupertinoDatePicker(
                              initialDateTime: DateTime.now(),
                              mode: CupertinoDatePickerMode.date,
                              use24hFormat: true,
                              showDayOfWeek: false,
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() {
                                  dateTime = newDate;
                                });
                              },
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          child: ImageHelper.svgImage(SvgNames.calendar),
                        ),
                        const SizedBox(width: 10),
                        AppButton(
                          name: 'Save',
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          callback: buttonState
                              ? () => save(
                                    name: nameIdeaController.text,
                                    text: textIdeaController.text,
                                    base64Image: base64Image,
                                    dateTime: dateTime,
                                    category: selectedCategory,
                                  )
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void _showDateTimeDialog(Widget child) {
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

  @override
  void dispose() {
    _searchController.dispose();
    _ideasController.dispose();
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
          valueListenable: _ideasController,
          builder: (BuildContext context, IdeasState state, Widget? child) {
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
                          'Ideas',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(color: Theme.of(context).colorScheme.onBackground),
                        ),
                        const Spacer(),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: _showAddIdea,
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
                      selectAction: _ideasController.selectCategory,
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder(
                      valueListenable: _ideasController,
                      builder: (BuildContext context, IdeasState state, Widget? child) {
                        if (state.ideas.isEmpty) {
                          return EmptyNoteState(
                            addIdeaAction: _showAddIdea,
                          );
                        } else {
                          final filteredIdeas = (_searchQuery.isEmpty
                                  ? state.selectedCategory == 'Favorite'
                                      ? state.ideas.where((element) => element.isLiked)
                                      : state.selectedCategory == 'All'
                                          ? state.ideas
                                          : state.ideas.where((element) =>
                                              element.category == state.selectedCategory)
                                  : state.selectedCategory == 'Favorite'
                                      ? state.ideas.where((element) {
                                          final lowerName = element.name.toLowerCase();
                                          final lowerQuery = _searchQuery.toLowerCase();
                                          return (lowerName.startsWith(lowerQuery) ||
                                              lowerName.contains(lowerQuery) && element.isLiked);
                                        })
                                      : state.ideas.where((element) {
                                          final lowerName = element.name.toLowerCase();
                                          final lowerQuery = _searchQuery.toLowerCase();
                                          return (lowerName.startsWith(lowerQuery) ||
                                              lowerName.contains(lowerQuery) &&
                                                  element.category == state.selectedCategory);
                                        }))
                              .toList();
                          return filteredIdeas.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: filteredIdeas.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final idea = filteredIdeas[index];
                                      return IdeaContainer(
                                        idea: idea,
                                        controller: _ideasController,
                                      );
                                    },
                                  ),
                                )
                              : EmptyNoteState(
                                  addIdeaAction: _showAddIdea,
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

class IdeaContainer extends StatelessWidget {
  const IdeaContainer({super.key, required this.idea, required this.controller});

  final Idea idea;
  final IdeasController controller;

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(idea.base64Image);
    var photo = Image.memory(
      bytes,
      fit: BoxFit.cover,
    );
    return CupertinoButton(
      onPressed: () {
        controller.select(idea);
        Navigator.of(context).pushNamed(RouteNames.idea,
            arguments: IdeaViewArguments(controller: controller, idea: idea));
      },
      padding: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Theme.of(context).extension<CustomColors>()!.containerBg,
            borderRadius: BorderRadius.circular(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 126,
                        height: 83,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(image: photo.image, fit: BoxFit.cover)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          idea.name.capitalize,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(color: Theme.of(context).colorScheme.onBackground),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    idea.text,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyNoteState extends StatelessWidget {
  const EmptyNoteState({super.key, required this.addIdeaAction});

  final VoidCallback addIdeaAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        ImageHelper.getImage(ImageNames.quotes),
        Text(
          'You dont have any Ideas',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        const SizedBox(height: 10),
        CupertinoButton(
          onPressed: () => addIdeaAction.call(),
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
