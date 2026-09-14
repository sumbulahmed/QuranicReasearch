import 'package:flutter/material.dart';

/// Centralized color palette embodying an old Islamic / literary manuscript,
/// vintage research journal, and elegant classic book aesthetic.
abstract class AppColors {
  // Brand Primaries (Deep Maroon / Burgundy)
  static const Color primaryMaroon = Color(0xFF5B1425);
  static const Color primaryMaroonLight = Color(0xFF7A2438);
  static const Color primaryMaroonDark = Color(0xFF3B0914);

  // Antique Paper / Parchment Palette
  static const Color parchment = Color(0xFFFBF7EE);
  static const Color parchmentCard = Color(0xFFFFFDF9);
  static const Color parchmentSubtle = Color(0xFFF4EFE2);
  static const Color parchmentDarker = Color(0xFFEBE2CF);
  static const Color parchmentBorder = Color(0xFFE0D5C1);
  static const Color parchmentBorderSubtle = Color(0xFFECE4D4);

  // Antique Gold & Sepia Accents (Muted & Used Sparingly)
  static const Color accentGold = Color(0xFFB89047);
  static const Color accentGoldLight = Color(0xFFD4B372);
  static const Color accentGoldMuted = Color(0xFFEADDBF);
  static const Color accentSepia = Color(0xFF6E5648);
  static const Color accentSepiaLight = Color(0xFF8C7161);

  // Legacy Aliases (pointing to new classic literary palette)
  static const Color primaryEmerald = primaryMaroon;
  static const Color primaryEmeraldLight = primaryMaroonLight;
  static const Color primaryEmeraldDark = primaryMaroonDark;
  static const Color accentTeal = accentSepia;
  static const Color accentCyan = accentGold;

  // Refined Scholarly Evidence Taxonomy (Muted Mineral & Earth Tones)
  static const Color evidenceStrong = Color(0xFF2E5E41);      // Forest sage / olive consensus
  static const Color evidenceEmerging = Color(0xFFB37324);    // Warm amber ochre
  static const Color evidenceModerate = Color(0xFFB37324);    // Backward compatible alias
  static const Color evidencePossible = Color(0xFF3D6076);    // Muted slate indigo
  static const Color evidenceUnsupported = Color(0xFF9A3838); // Terracotta crimson

  // Light Theme (Warm Antique Parchment)
  static const Color lightBackground = parchment;
  static const Color lightSurface = parchmentCard;
  static const Color lightSurfaceCard = parchmentCard;
  static const Color lightSurfaceSubtle = parchmentSubtle;
  static const Color lightBorder = parchmentBorder;
  static const Color lightBorderSubtle = parchmentBorderSubtle;
  static const Color lightTextPrimary = Color(0xFF2C211D);     // Dark sepia / warm brown-maroon
  static const Color lightTextHeading = primaryMaroon;         // Deep maroon for headings
  static const Color lightTextSecondary = Color(0xFF5C4E48);   // Dark brown body text
  static const Color lightTextMuted = Color(0xFF8A7A71);       // Muted warm taupe

  // Dark Theme (Aged Leather & Midnight Parchment)
  static const Color darkBackground = Color(0xFF191514);
  static const Color darkSurface = Color(0xFF231E1C);
  static const Color darkSurfaceCard = Color(0xFF231E1C);
  static const Color darkSurfaceSubtle = Color(0xFF2D2724);
  static const Color darkBorder = Color(0xFF403631);
  static const Color darkBorderSubtle = Color(0xFF332B27);
  static const Color darkTextPrimary = Color(0xFFF4EDE2);     // Antique cream
  static const Color darkTextHeading = Color(0xFFE6B8C2);     // Vintage rose maroon
  static const Color darkTextSecondary = Color(0xFFC7BCB0);
  static const Color darkTextMuted = Color(0xFF8E8378);

  // Semantic Status
  static const Color success = evidenceStrong;
  static const Color warning = evidenceEmerging;
  static const Color error = evidenceUnsupported;
  static const Color info = evidencePossible;
}
