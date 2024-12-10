import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFADD6CF), // Using Pastel Blue as the base seed color
    primary: const Color(0xFFADD6CF), // Pastel Blue
    secondary: const Color(0xFFF0AF9E), // Pastel Pink
    tertiary: const Color(0xFF9FB693), // Laurel Green
    background: const Color(0xFFF8E8C4), // Lemon Meringue
    error: const Color(0xFFE48364), // Copper
  ),
  scaffoldBackgroundColor: const Color(0xfffaf6f2), // Lemon Meringue
  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black54,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFFF0AF9E), // Pastel Pink
    elevation: 0,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  bottomNavigationBarTheme:  BottomNavigationBarThemeData(
    backgroundColor: Color(0xfffaf6f2), // Lemon Meringue
    selectedItemColor: Color(0xFFE48364), // Copper
    unselectedItemColor: Colors.grey,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFFADD6CF), // Pastel Blue
    labelStyle: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    secondaryLabelStyle: GoogleFonts.poppins(
      fontSize: 14,
      color: Colors.black,
    ),
    selectedColor: const Color(0xFFF0AF9E), // Pastel Pink
    disabledColor: Colors.grey.shade300,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF9FB693), // Laurel Green
    foregroundColor: Colors.white,
  ),
  dividerColor: Colors.black12,
);
