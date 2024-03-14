import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_46/presentation/themes/custom_colors.dart';
import 'package:theme_provider/theme_provider.dart';

class DefaultTheme {
  static final dark = AppTheme(
    id: 'dark',
    data: ThemeData(
      scaffoldBackgroundColor: darkColors.background,
      colorScheme: darkColors,
      textTheme: textTheme,
      extensions: const [CustomColors.dark],
    ),
    description: 'App dark theme',
  );

  static final light = AppTheme(
    id: 'light',
    data: ThemeData(
      scaffoldBackgroundColor: ligthColors.background,
      colorScheme: ligthColors,
      textTheme: textTheme,
      extensions: const [CustomColors.light],
    ),
    description: 'App light theme',
  );

  static const darkColors = ColorScheme(
    primary: Colors.black,
    primaryContainer: Color(0xFF063780),
    onPrimary: Colors.black,
    secondary: Color(0xFF5393FF),
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    background: Color(0xFF222222),
    onBackground: Colors.white,
    brightness: Brightness.dark,
    surface: Color(0xFFC9C9C9),
    onSurface: Colors.black,
    onPrimaryContainer: Colors.black,
  );

  static const ligthColors = ColorScheme(
    primary: Colors.white,
    primaryContainer: Colors.white,
    secondary: Color(0xFF111315),
    surface: Color(0xFFFEFEFE),
    onSurface: Colors.black,
    background: Color(0xFFF2F2F2),
    secondaryContainer: Color(0xFF34C85A),
    onBackground: Colors.black,
    error: Colors.white,
    onError: Colors.white,
    brightness: Brightness.light,
    onPrimary: Colors.white,
    onSecondary: Color(0xFF0D0D0D),
  );

  static final textTheme = TextTheme(
    headlineLarge: GoogleFonts.tourney(
      fontWeight: FontWeight.w800,
      fontSize: 36.0,
      height: 1.2,
    ),
    bodyLarge: GoogleFonts.workSans(
      fontWeight: FontWeight.w400,
      fontSize: 20.0,
      height: 1.2,
    ),
    bodyMedium: GoogleFonts.playfairDisplay(
      fontWeight: FontWeight.w400,
      fontSize: 16.0,
      height: 1.5,
    ),
    displayLarge: GoogleFonts.playfairDisplay(
      fontWeight: FontWeight.w700,
      fontSize: 30.0,
      height: 1.2,
    ),
    displayMedium: const TextStyle(
      fontFamily: 'SF-Pro-Display',
      fontSize: 20,
      fontWeight: FontWeight.w500,
      height: 1.2,
      letterSpacing: -0.32,
    ),
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: -0.32,
    ),
    headlineMedium: GoogleFonts.tourney(
      fontWeight: FontWeight.w500,
      fontSize: 22.0,
      height: 1.1,
    ),
    titleMedium: const TextStyle(
      fontFamily: 'SF-Pro-Display',
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: GoogleFonts.tourney(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
      height: 1.0,
    ),
    titleLarge: const TextStyle(
      fontFamily: 'SF-Pro-Display',
      fontSize: 20,
      fontWeight: FontWeight.w400,
    ),
    labelSmall: GoogleFonts.playfairDisplay(
      fontWeight: FontWeight.w400,
      fontSize: 12.0,
      height: 2,
    ),
    labelMedium: const TextStyle(
      fontFamily: 'SF-Pro-Display',
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
      height: 1.2,
    ),
    labelLarge: GoogleFonts.playfairDisplay(
      fontWeight: FontWeight.w500,
      fontSize: 20.0,
      height: 1.2,
    ),
    bodySmall: const TextStyle(
      fontFamily: 'SF-Pro-Display',
      fontWeight: FontWeight.w400,
      fontSize: 12.0,
      height: 1.2,
      letterSpacing: -0.32,
    ),
  );
}
