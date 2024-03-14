import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pp_46/business/helpers/email_helper.dart';
import 'package:pp_46/business/helpers/image/image_helper.dart';
import 'package:pp_46/business/helpers/text_helper.dart';
import 'package:pp_46/presentation/themes/app_theme.dart';
import 'package:theme_provider/theme_provider.dart';

class AgreementView extends StatelessWidget {
  const AgreementView({super.key, required this.agreementType});

  final AgreementType agreementType;

  String get _agreementText =>
      agreementType == AgreementType.privacy ? TextHelper.privacy : TextHelper.terms;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeProvider.themeOf(context).id == DefaultTheme.light.id;
    return Scaffold(
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
                  Text(agreementType == AgreementType.privacy ? 'Privacy Policy' : 'Terms of use',
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.onBackground)),
                  const Spacer(),
                  const SizedBox(width: 36,)
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 0, right: 0, bottom: 20),
                  child: MarkdownBody(
                    data: _agreementText,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                      p: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      a: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      code: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      checkbox: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      h1: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      h2: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      h3: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      h4: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      em: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      del: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                      listBullet: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                    ),
                    onTapLink: (text, href, title) => EmailHelper.launchEmailSubmission(
                      toEmail: text,
                      subject: '',
                      body: '',
                      errorCallback: () {},
                      doneCallback: () {},
                    ),
                    selectable: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AgreementType {
  privacy,
  terms,
}
