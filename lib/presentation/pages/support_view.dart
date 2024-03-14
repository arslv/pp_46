import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_46/business/helpers/email_helper.dart';
import 'package:pp_46/business/helpers/image/image_helper.dart';
import 'package:pp_46/presentation/themes/app_theme.dart';
import 'package:pp_46/presentation/widgets/app_text_field.dart';
import 'package:theme_provider/theme_provider.dart';

class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  var _isButtonEnabled = false;

  Future<void> _send() async => await EmailHelper.launchEmailSubmission(
        toEmail: 'ksuvei@finconte.site',
        subject: _subjectController.text,
        body: _messageController.text,
        errorCallback: () {},
        doneCallback: () => setState(() {
          _subjectController.clear();
          _messageController.clear();
          _isButtonEnabled = false;
        }),
      );

  void _onChanged(String value) => setState(
        () => _isButtonEnabled =
            _subjectController.text.isNotEmpty && _messageController.text.isNotEmpty,
      );

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeProvider.themeOf(context).id == DefaultTheme.light.id;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: ImageHelper.svgImage(
                        isDarkMode ? SvgNames.backLight : SvgNames.backDark),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  Text('Support',
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.onBackground)),
                  const Spacer(),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _isButtonEnabled ? _send : null,
                    child: Text(
                      'Send',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: _isButtonEnabled
                              ? CupertinoColors.activeBlue
                              : CupertinoColors.activeBlue.withOpacity(0.3)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  _ContactInput(
                    onChanged: _onChanged,
                    controller: _subjectController,
                    placeholder: 'Title',
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 19),
                  _ContactInput(
                    onChanged: _onChanged,
                    controller: _messageController,
                    placeholder: 'Message',
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactInput extends StatelessWidget {
  final void Function(String) onChanged;
  final String placeholder;
  final TextEditingController controller;
  final bool isDarkMode;

  const _ContactInput({
    required this.onChanged,
    required this.controller,
    required this.placeholder,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(placeholder: placeholder, controller: controller, onChanged: onChanged);
  }
}
