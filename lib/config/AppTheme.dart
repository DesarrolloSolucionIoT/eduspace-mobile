import 'package:flutter/material.dart';

class AppColors {
  // Paleta original del mobile (gradiente azul → verde)
  static const Color primary = Color(0xFF1976D2);
  static const Color secondary = Color(0xFF43E97B);

  static const Color danger = Color(0xFFE53935);
  static const Color warning = Color(0xFFF59E0B);

  // Colores de sensores (sobre cards blancas)
  static const Color sensorTemp = Color(0xFF38bdf8);
  static const Color sensorHumidity = Color(0xFFa78bfa);
  static const Color sensorOccupancy = Color(0xFF6366f1);

  static const Color stateOk = Color(0xFF22c55e);
  static const Color stateWarn = Color(0xFFF59E0B);
  static const Color stateDanger = Color(0xFFE53935);

  static const Color cardBg = Colors.white;
  static const Color textMain = Color(0xFF1f2937);
  static const Color textMuted = Color(0xFF6b7280);
  static const Color border = Color(0xFFE5E7EB);
}

class AppGradients {
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 12,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F7FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        useMaterial3: false,
      );
}
