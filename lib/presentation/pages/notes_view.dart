import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_46/business/controllers/notes_controller.dart';
import 'package:pp_46/business/helpers/date_helper.dart';
import 'package:pp_46/business/helpers/extensions/string_extension.dart';
import 'package:pp_46/business/helpers/image/image_helper.dart';
import 'package:pp_46/data/entity/note_entity.dart';
import 'package:pp_46/presentation/themes/app_theme.dart';
import 'package:pp_46/presentation/themes/custom_colors.dart';
import 'package:pp_46/presentation/widgets/app_button.dart';
import 'package:pp_46/presentation/widgets/app_text_field.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  final _searchController = TextEditingController();
  final _notesController = NotesController();

  var _searchQuery = '';

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {
      _speechEnabled = false;
    });
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _searchQuery = _lastWords;
      _searchController.text = _lastWords;
    });
  }

  Future<void> edit({required String key, required Note editedNote}) async {
    await _notesController.editNote(key, editedNote);
    Navigator.of(context).pop();
  }

  void save({required String name, required String text, required DateTime dateTime}) {
    _notesController.addNote(Note(name: name, text: text, dateTime: dateTime));
    Navigator.of(context).pop();
  }

  void _showEditNote(Note editedNote) {
    final nameNoteController = TextEditingController()..text = editedNote.name;
    final textNoteController = TextEditingController()..text = editedNote.text;
    DateTime dateTime = editedNote.dateTime;

    showCupertinoModalPopup(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
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
                          onPressed: () {},
                          child: ImageHelper.svgImage(
                              isDarkMode ? SvgNames.backDark : SvgNames.backLight),
                        ),
                        const Spacer(),
                        Text('Edit note',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: Theme.of(context).colorScheme.onBackground)),
                        const Spacer(),
                        const SizedBox(height: 36, width: 36),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      placeholder: 'Type your Note-name',
                      controller: nameNoteController,
                      maxLength: 16,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      placeholder: 'Type here...',
                      controller: textNoteController,
                      maxLines: 10,
                      size: const Size(double.infinity, 164),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                          callback: textNoteController.text.isNotEmpty &&
                                  nameNoteController.text.isNotEmpty
                              ? () async => await edit(
                                  key: editedNote.name,
                                  editedNote: Note(
                                    name: nameNoteController.text,
                                    text: textNoteController.text,
                                    dateTime: dateTime,
                                  ))
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

  bool buttonState = false;

  void _showAddNote() {
    final nameNoteController = TextEditingController();
    final textNoteController = TextEditingController();
    DateTime dateTime = DateTime.now();

    showCupertinoModalPopup(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            void updateSaveButtonState() {
              setState(() {
                buttonState =
                    nameNoteController.text.isNotEmpty && textNoteController.text.isNotEmpty;
              });
            }

            nameNoteController.addListener(updateSaveButtonState);
            textNoteController.addListener(updateSaveButtonState);
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
                        Text('New Note',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: Theme.of(context).colorScheme.onBackground)),
                        const Spacer(),
                        const SizedBox(height: 36, width: 36),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      placeholder: 'Type your Note-name',
                      controller: nameNoteController,
                      maxLength: 16,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      placeholder: 'Type here...',
                      controller: textNoteController,
                      maxLines: 10,
                      size: const Size(double.infinity, 164),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                                    name: nameNoteController.text,
                                    text: textNoteController.text,
                                    dateTime: dateTime,
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

  void _handleSearchUpdate(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
                    'Notes',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: Theme.of(context).colorScheme.onBackground),
                  ),
                  const Spacer(),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _showAddNote,
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
              ValueListenableBuilder(
                valueListenable: _notesController,
                builder: (BuildContext context, NotesState state, Widget? child) {
                  if (state.notes.isEmpty) {
                    return EmptyNoteState(
                      addNoteAction: _showAddNote,
                    );
                  } else {
                    final filteredNotes = (_searchQuery.isEmpty
                            ? state.notes
                            : state.notes.where(
                                (note) {
                                  final lowerName = note.name.toLowerCase();
                                  final lowerQuery = _searchQuery.toLowerCase();
                                  return lowerName.startsWith(lowerQuery) ||
                                      lowerName.contains(lowerQuery);
                                },
                              ))
                        .toList();
                    return filteredNotes.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: filteredNotes.length,
                              itemBuilder: (BuildContext context, int index) {
                                final note = filteredNotes[index];
                                return NoteContainer(
                                  note: note,
                                  editAction: _showEditNote,
                                );
                              },
                            ),
                          )
                        : EmptyNoteState(
                            addNoteAction: _showAddNote,
                          );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteContainer extends StatelessWidget {
  const NoteContainer({super.key, required this.note, required this.editAction});

  final Note note;
  final Function(Note note) editAction;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Text(
                  note.name.capitalize,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(height: 10),
                Text(
                  note.text,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(left: 15, bottom: 6, top: 6, right: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).extension<CustomColors>()!.opacityContainer,
            ),
            child: Row(
              children: [
                Text(
                  DateHelper().formatDateTime(note.dateTime),
                  style: TextStyle(
                      fontFamily: 'SF-Pro-Display',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: -0.32,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const Spacer(),
                SizedBox(
                  height: 28,
                  width: 28,
                  child: CupertinoButton(
                    onPressed: () async => await editAction(note),
                    padding: EdgeInsets.zero,
                    child: ImageHelper.svgImage(SvgNames.edit, width: 28, height: 28),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class EmptyNoteState extends StatelessWidget {
  const EmptyNoteState({super.key, required this.addNoteAction});

  final VoidCallback addNoteAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        ImageHelper.getImage(ImageNames.quotes),
        Text(
          'You dont have any Notes',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        const SizedBox(height: 10),
        CupertinoButton(
          onPressed: () => addNoteAction.call(),
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
