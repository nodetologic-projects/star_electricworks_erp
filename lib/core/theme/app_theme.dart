import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFFF8F6F4); // Near-white
  static const Color textPrimary = Color(0xFF131C25); // Navy (body text and dark UI)
  static const Color primaryMaroon = Color(0xFF501817); // Maroon (primary brand)
  static const Color secondaryOrange = Color(0xFFE54626); // Orange (secondary accent)
  
  static const Color warningAmber = Color(0xFFB45309);
  static const Color errorRed = Color(0xFFC0392B);
  static const Color successGreen = Color(0xFF2F6E4F);

  static ThemeData get themeData {
    final baseTextTheme = GoogleFonts.manropeTextTheme();

    // Customize baseTextTheme to enforce our constraints:
    // - two weights only (regular=400, semibold=600)
    // - base size 15, minimum 13
    TextTheme applyConstraints(TextTheme base) {
      TextStyle? constrain(TextStyle? style) {
        if (style == null) return null;
        
        // Ensure size constraints
        double fontSize = style.fontSize ?? 15;
        if (fontSize < 13) fontSize = 13;
        
        // Ensure weight constraints (default to regular, use semibold if it was bold/w600+)
        FontWeight fontWeight = FontWeight.w400;
        if (style.fontWeight != null && style.fontWeight!.value >= 600) {
          fontWeight = FontWeight.w600;
        }

        return style.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textPrimary,
        );
      }

      return base.copyWith(
        displayLarge: constrain(base.displayLarge),
        displayMedium: constrain(base.displayMedium),
        displaySmall: constrain(base.displaySmall),
        headlineLarge: constrain(base.headlineLarge),
        headlineMedium: constrain(base.headlineMedium),
        headlineSmall: constrain(base.headlineSmall),
        titleLarge: constrain(base.titleLarge),
        titleMedium: constrain(base.titleMedium),
        titleSmall: constrain(base.titleSmall),
        bodyLarge: constrain(base.bodyLarge),
        bodyMedium: constrain(base.bodyMedium),
        bodySmall: constrain(base.bodySmall),
        labelLarge: constrain(base.labelLarge),
        labelMedium: constrain(base.labelMedium),
        labelSmall: constrain(base.labelSmall),
      );
    }

    final customTextTheme = applyConstraints(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryMaroon,
        primary: primaryMaroon,
        error: errorRed,
        surface: background,
        onSurface: textPrimary,
      ).copyWith(
        // Inject custom warning color if needed via extensions, 
        // but typically tertiary or secondary can be used for custom semantic colors.
        tertiary: warningAmber, 
      ),
      textTheme: customTextTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return Colors.grey;
            return primaryMaroon;
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return secondaryOrange.withValues(alpha: 0.8);
            }
            return null;
          }),
          minimumSize: WidgetStateProperty.all(const Size(64, 44)),
          textStyle: WidgetStateProperty.all(customTextTheme.labelLarge),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size(64, 44),
          textStyle: customTextTheme.labelLarge,
          side: const BorderSide(color: textPrimary, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryMaroon,
          minimumSize: const Size(64, 44),
          textStyle: customTextTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryMaroon, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        errorStyle: const TextStyle(
          color: errorRed,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

extension TextStyleX on TextStyle {
  TextStyle get mono => GoogleFonts.ibmPlexMono(textStyle: this);
}
