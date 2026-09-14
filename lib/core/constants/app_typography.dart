import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Literary book typography system blending classical English serif (EB Garamond)
/// with authentic Arabic calligraphy (Amiri).
abstract class AppTypography {
  // Classical Book English Typography (EB Garamond)
  static TextStyle get displayLarge => GoogleFonts.ebGaramond(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.25,
      );

  static TextStyle get displayMedium => GoogleFonts.ebGaramond(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.3,
      );

  static TextStyle get appTitle => GoogleFonts.ebGaramond(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      );

  static TextStyle get headlineLarge => GoogleFonts.ebGaramond(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
        height: 1.35,
      );

  static TextStyle get headlineMedium => GoogleFonts.ebGaramond(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  static TextStyle get titleLarge => GoogleFonts.ebGaramond(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.35,
      );

  static TextStyle get titleMedium => GoogleFonts.ebGaramond(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleSmall => GoogleFonts.ebGaramond(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get sectionHeading => GoogleFonts.ebGaramond(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
      );

  // Long-Form Reading & Content
  static TextStyle get bodyLarge => GoogleFonts.ebGaramond(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.65,
      );

  static TextStyle get bodyMedium => GoogleFonts.ebGaramond(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.55,
      );

  static TextStyle get bodySmall => GoogleFonts.ebGaramond(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );

  // Labels, Metadata & Captions
  static TextStyle get labelLarge => GoogleFonts.ebGaramond(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      );

  static TextStyle get labelMedium => GoogleFonts.ebGaramond(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static TextStyle get labelSmall => GoogleFonts.ebGaramond(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      );

  // Dedicated Academic & Scriptural Styles
  static TextStyle get hadithMatnEnglish => GoogleFonts.ebGaramond(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.65,
      );

  static TextStyle get tafseerText => GoogleFonts.ebGaramond(
        fontSize: 14.5,
        fontWeight: FontWeight.w400,
        height: 1.6,
        fontStyle: FontStyle.italic,
      );

  static TextStyle get scientificAnalysisText => GoogleFonts.ebGaramond(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static TextStyle get researchCitationText => GoogleFonts.ebGaramond(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get metadataText => GoogleFonts.ebGaramond(
        fontSize: 11.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      );

  // Traditional Arabic Quranic & Hadith Typography (Amiri)
  static TextStyle get quranTextLarge => GoogleFonts.amiri(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 2.2, // Generous multiplier prevents diacritic / tashkeel clipping
      );

  static TextStyle get quranTextMedium => GoogleFonts.amiri(
        fontSize: 24,
        fontWeight: FontWeight.normal,
        height: 2.1,
      );

  static TextStyle get quranTextSmall => GoogleFonts.amiri(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        height: 2.0,
      );
}
