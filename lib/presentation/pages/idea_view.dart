import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_46/business/controllers/ideas_controller.dart';
import 'package:pp_46/business/helpers/extensions/string_extension.dart';
import 'package:pp_46/business/helpers/image/image_helper.dart';
import 'package:pp_46/data/entity/idea_entity.dart';
import 'package:pp_46/presentation/themes/app_theme.dart';
import 'package:theme_provider/theme_provider.dart';

class IdeaViewArguments {
  final IdeasController controller;
  final Idea idea;

  IdeaViewArguments({required this.controller, required this.idea});
}

class IdeaView extends StatefulWidget {
  const IdeaView({super.key, required this.idea, required this.controller});

  final IdeasController controller;
  final Idea idea;

  @override
  State<IdeaView> createState() => _IdeaViewState();
}

class _IdeaViewState extends State<IdeaView> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeProvider.themeOf(context).id == DefaultTheme.light.id;
    Uint8List bytes = base64Decode(widget.idea.base64Image);
    var photo = Image.memory(
      bytes,
      fit: BoxFit.cover,
    );

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: widget.controller,
        builder: (BuildContext context, IdeasState state, Widget? child) {
          return Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            color: Theme.of(context).colorScheme.background,
            child: SafeArea(
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
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: ImageHelper.svgImage(
                          isDarkMode
                              ? state.isLiked ?? false
                                  ? SvgNames.likeDarkEnabled
                                  : SvgNames.likeDark
                              : state.isLiked ?? false
                                  ? SvgNames.likeLightEnabled
                                  : SvgNames.likeLight,
                        ),
                        onPressed: () => widget.controller.like(widget.idea),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 316,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: photo.image,
                          fit: BoxFit.cover,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            blurRadius: 20,
                            spreadRadius: 0,
                            offset: Offset(0, 0),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 16),
                  Text(widget.idea.name.capitalize, style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground)),
                  const SizedBox(height: 10),
                  Text(widget.idea.text, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onBackground))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
