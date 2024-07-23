import 'package:flutter/material.dart';

class FunnyChatTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Color.fromRGBO(73, 50, 39, 1),
        onPrimary: Colors.black,
        secondary: Color(0xFFEDF2F6),
        onSecondary: Color(0xFF2B333E),
          secondaryContainer: Color(0xFF00521c),
        secondaryFixedDim: Color(0xFF5E7A90),
        tertiary: Color(0xFF9DB7CB),
        tertiaryContainer: Color(0xEEEEEEFF),
        surfaceContainer: Color(0xFF3CED78)
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black, width: 2.0),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFEDF2F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF9DB7CB),
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Colors.black,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF00521c),
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.normal,
          fontSize: 10,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        headlineLarge: TextStyle(
          color: Color(0xFF2B333E),
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.normal,
          fontSize: 10,
        ),
        bodySmall: TextStyle(
          color: Color(0xFF5E7A90),
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        headlineSmall: TextStyle(
          color: Color(0xFF2B333E),
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        titleSmall: TextStyle(
          color: Colors.green,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Colors.black,
        ),
        labelSmall: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color(0xFF9DB7CB),
        ),
        labelLarge: TextStyle(
          color: Color(0xFF2B333E),
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
          fontSize: 32,
        ),
        displayMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF00521c)
      ),
        displaySmall: TextStyle(
            fontSize: 14,
            color: Color(0xFF2B333E)
        ),
      ),
    );
  }

  static InputDecoration searchInputDecoration({
    required String hintText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      hintStyle: const TextStyle(
        color: Color(0xFF9DB7CB),
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      filled: true,
      fillColor: const Color(0xFFEDF2F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
    );
  }

  static InputDecoration chatInputDecoration({
    required String hintText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      hintStyle: const TextStyle(
        color: Color(0xFF9DB7CB),
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      filled: true,
      fillColor: const Color(0xEEEEEEFF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
    );
  }

  static BoxDecoration iconContainerDecoration() {
    return BoxDecoration(
      color: const Color(0xFFEDF2F6),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
