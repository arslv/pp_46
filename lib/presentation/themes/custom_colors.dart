import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color containerBg;
  final Color onContainerBg;
  final Color onContainerText;
  final Color opacityContainer;

  const CustomColors({
    required this.containerBg,
    required this.onContainerBg,
    required this.onContainerText,
    required this.opacityContainer,
  });

  @override
  CustomColors copyWith({
    Color? containerBg,
    Color? onContainerBg,
    Color? onContainerText,
    Color? opacityContainer,
  }) {
    return CustomColors(
      containerBg: containerBg ?? this.containerBg,
      onContainerBg: onContainerBg ?? this.onContainerBg,
      onContainerText: onContainerText ?? this.onContainerText,
      opacityContainer: opacityContainer ?? this.opacityContainer,
    );
  }

  static const light = CustomColors(
    containerBg: Colors.white,
    onContainerBg: Color(0xFF889096),
    onContainerText: Color(0x889096),
    opacityContainer: Color(0xFFF2F2F2),
  );

  static const dark = CustomColors(
    containerBg: Color(0xFF363636),
    onContainerBg: Color(0xFF434343),
    onContainerText: Colors.white,
    opacityContainer: Color(0xFF434343),
  );

  @override
  ThemeExtension<CustomColors> lerp(covariant ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      containerBg: Color.lerp(containerBg, other.containerBg, t)!,
      onContainerBg: Color.lerp(onContainerBg, other.onContainerBg, t)!,
      onContainerText: Color.lerp(onContainerText, other.onContainerText, t)!,
      opacityContainer: Color.lerp(opacityContainer, other.opacityContainer, t)!,
    );
  }
}
