import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_46/presentation/themes/custom_colors.dart';

class AppTextField extends StatelessWidget {
  final String placeholder;
  final void Function(String)? onChanged;
  final TextEditingController controller;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsets? padding;
  final bool enabled;
  final Color? backgroundColor;
  final Widget? prefix;
  final Size? size;
  final bool hasBorder;
  final Widget? suffix;
  final int? maxLines;
  final int? maxLength;

  const AppTextField({
    super.key,
    required this.placeholder,
    required this.controller,
    this.textAlignVertical,
    this.padding,
    this.onChanged,
    this.enabled = true,
    this.backgroundColor,
    this.prefix,
    this.size, 
    this.hasBorder = true,
    this.suffix,
    this.maxLines,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size?.width ?? double.infinity,
      height: size?.height ?? 42,
      child: CupertinoTextField(
        maxLines: maxLines,
        maxLength: maxLength,
        enabled: enabled,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        textAlignVertical: textAlignVertical,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onBackground),
        placeholderStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
        decoration: BoxDecoration(
          color: backgroundColor ??
              Theme.of(context).extension<CustomColors>()!.containerBg,
          borderRadius: BorderRadius.circular(30),
        ),
        onChanged: onChanged,
        prefix: prefix,
        placeholder: placeholder,
        suffix: suffix,
        controller: controller,
      ),
    );
  }
}
